Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1I1Kbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:31:50 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:5001
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab1I1Kbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:31:49 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LS8AKS-01-1WS-02
X-M-MSG: 
Date: Wed, 28 Sep 2011 12:31:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110928103140.GD6063@erda.amd.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
 <1316805435-14832-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316805435-14832-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.11 15:17:13, Don Zickus wrote:
> @@ -89,6 +89,15 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
>  
>  		handled += a->handler(type, regs);
>  
> +		/*
> + 		 * Optimization: only loop once if this is not a 
> + 		 * back-to-back NMI.  The idea is nothing is dropped
> + 		 * on the first NMI, only on the second of a back-to-back
> + 		 * NMI.  No need to waste cycles going through all the
> + 		 * handlers.
> + 		 */
> +		if (!b2b && handled)
> +			break;

I don't think we can leave this in. As said, there are cases that 2
nmis trigger but the handler is called only once. Only the first would
be handled then, and the second get lost cause there is no 2nd nmi
call.

>  	}
>  
>  	rcu_read_unlock();
> @@ -251,7 +260,13 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  {
>  	int handled;
>  
> -	handled = nmi_handle(NMI_UNKNOWN, regs);
> +	/*
> +	 * Use 'false' as back-to-back NMIs are dealt with one level up.
> +	 * Of course this makes having multiple 'unknown' handlers useless
> +	 * as only the first one is ever run (unless it can actually determine
> +	 * if it caused the NMI)
> +	 */
> +	handled = nmi_handle(NMI_UNKNOWN, regs, false);
>  	if (handled) 
>  		return;
>  #ifdef CONFIG_MCA
> @@ -274,19 +289,49 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  	pr_emerg("Dazed and confused, but trying to continue\n");
>  }
>  
> +static DEFINE_PER_CPU(bool, swallow_nmi);
> +static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
> +
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
>  	int handled;
> +	bool b2b = false;
>  
>  	/*
>  	 * CPU-specific NMI must be processed before non-CPU-specific
>  	 * NMI, otherwise we may lose it, because the CPU-specific
>  	 * NMI can not be detected/processed on other CPUs.
>  	 */
> -	handled = nmi_handle(NMI_LOCAL, regs);
> -	if (handled)
> +
> +	/*
> +	 * Back-to-back NMIs are interesting because they can either
> +	 * be two NMI or more than two NMIs (any thing over two is dropped
> +	 * due to NMI being edge-triggered).  If this is the second half
> +	 * of the back-to-back NMI, assume we dropped things and process
> +	 * more handlers.  Otherwise reset the 'swallow' NMI behaviour
> +	 */
> +	if (regs->ip == __this_cpu_read(last_nmi_rip))
> +		b2b = true;
> +	else
> +		__this_cpu_write(swallow_nmi, false);
> +
> +	__this_cpu_write(last_nmi_rip, regs->ip);

Just a minor thing and if you make a new version of this patch: You
could move the write to the else branch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

