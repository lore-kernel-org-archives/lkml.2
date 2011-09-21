Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1IUFoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:44:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:32384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1IUFoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:44:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50583831"
Message-ID: <4E79799D.4040507@intel.com>
Date: Wed, 21 Sep 2011 13:43:57 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-5-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:43 PM, Don Zickus wrote:
[snip]
> @@ -313,7 +359,31 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	}
>  	raw_spin_unlock(&nmi_reason_lock);
>  
> -	unknown_nmi_error(reason, regs);
> +	/*
> +	 * Only one NMI can be latched at a time.  To handle
> +	 * this we may process multiple nmi handlers at once to
> +	 * cover the case where an NMI is dropped.  The downside
> +	 * to this approach is we may process an NMI prematurely,
> +	 * while its real NMI is sitting latched.  This will cause
> +	 * an unknown NMI on the next run of the NMI processing.
> +	 * 
> +	 * We tried to flag that condition above, by setting the
> +	 * swallow_nmi flag when we process more than one event.
> +	 * This condition is also only present on the second half
> +	 * of a back-to-back NMI, so we flag that condition too.
> +	 *
> +	 * If both are true, we assume we already processed this
> +	 * NMI previously and we swallow it.  Otherwise we reset
> +	 * the logic.
> +	 *
> +	 * I am sure there are scenarios where we accidentally
> +	 * swallow a real 'unknown' NMI.  But this is the best
> +	 * we can do for now.

Why not describe a scenario where we swallow a real 'unknown' NMI?  So
that someone working on the code in the future will know the challenge?

Best Regards,
Huang Ying

> +	 */
> +	if (b2b && __this_cpu_read(swallow_nmi))
> +		;
> +	else
> +		unknown_nmi_error(reason, regs);
>  }
>  
>  dotraplinkage notrace __kprobes void

