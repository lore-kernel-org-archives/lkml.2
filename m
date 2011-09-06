Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1IFQS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:18:57 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:2655
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1IFQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:18:51 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LR3ZZ9-02-358-02
X-M-MSG: 
Date: Tue, 6 Sep 2011 18:18:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [V3][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110906161842.GI14200@erda.amd.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314290748-23569-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.11 12:45:46, Don Zickus wrote:
> Previous patches allow the NMI subsystem to process multipe NMI events
> in one NMI.  As previously discussed this can cause issues when an event
> triggered another NMI but is processed in the current NMI.  This causes the
> next NMI to go unprocessed and become an 'unknown' NMI.
> 
> Having this print 'unknown' NMI to the console would be inaccurate and
> scare users.  As a result I have copied the 'skip unknown' NMI logic
> developed by Robert Richter (and simplfied a little because we can
> track _all_ NMIs better instead of just the perf ones) to the main
> NMI handling routine.
> 
> It is fairly simple, if when processing an NMI, the nmi_handle routine returns
> more than one event handled, then set a flag for future use.  This flag just
> says there might be a possible unknown NMI.  If an unknown NMI does come in,
> then it is skipped (swallowed).  Otherwise just clear the flag on the next NMI
> if it has events processed.
> 
> The algorithm isn't 100% accurate but for most loads we have seen in perf it
> captures a large majority of unknown NMIs.  Under high workloads there still
> is the chance that unknown NMIs can trigger because you can time it just right
> such that you are generating NMIs as fast as you can process them and go four
> or five NMIs before seeing the unknown NMI.
> 
> Without involving the concept of time when tracking these 'possible' NMIs,
> we may never be 100% reliable.  The idea with time being that back-to-back
> NMIs immediately follow each other.  Anything more than a micro second or so
> on modern machines between when the first NMI finished to when the second one
> starts, probably indicates a completely new event.
> 
> V2:
>   - forgot to add the 'read' code for swallow_nmi (went into next patch)
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/nmi.c |   29 +++++++++++++++++++++++++++--
>  1 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 45fcd82..435dc71 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -270,6 +270,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  	pr_emerg("Dazed and confused, but trying to continue\n");
>  }
>  
> +DEFINE_PER_CPU(bool, swallow_nmi);
> +
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
> @@ -281,8 +283,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	 * NMI can not be detected/processed on other CPUs.
>  	 */
>  	handled = nmi_handle(NMI_LOCAL, regs);
> -	if (handled)
> +	if (handled) {
> +		/*
> +		 * When handling multiple NMI events, we are not
> +		 * sure if the second NMI was dropped (because of
> +		 * too many NMIs), piggy-backed on the same NMI
> +		 * (perf) or is queued right behind this NMI.
> +		 * In the last case, we may accidentally get an
> +		 * unknown NMI because the event is already handled.
> +		 * Flag for this condition and swallow it later.
> +		 *
> +		 * FIXME: This detection has holes in it mainly
> +		 * because we can't tell _when_ the next NMI comes
> +		 * in.  A multi-handled NMI event followed by an 
> +		 * unknown NMI a second later, clearly should not
> +		 * be swallowed.
> +		 */
> +		if (handled > 1)
> +			__this_cpu_write(swallow_nmi, true);
> +		else
> +			__this_cpu_write(swallow_nmi, false);

See my comment for patch 3/6.

>  		return;
> +	}
>  
>  	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
>  	raw_spin_lock(&nmi_reason_lock);
> @@ -305,7 +327,10 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	}
>  	raw_spin_unlock(&nmi_reason_lock);
>  
> -	unknown_nmi_error(reason, regs);
> +	if (!__this_cpu_read(swallow_nmi))
> +		unknown_nmi_error(reason, regs);
> +
> +	__this_cpu_write(swallow_nmi, false);
>  }
>  
>  dotraplinkage notrace __kprobes void
> -- 
> 1.7.6
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

