Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab1CWUp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:45:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1CWUpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iq3+Eib8u00sj0wZu5/ASUp0+fJJZ+v9rsMR6/ON8Gx6d/LavU0HVfDNQXhbHrOIU/
         ACET/AeTPeOZRp2T52y8Sxrqe6tE0QAE5SrWxrOb7mKSCq9+ItUIjWpCc1ZWy1JfTxvG
         AvLOVduzv3uQbDg9WWFbkpBZL11V9TbhoFr3U=
Message-ID: <4D8A5BE0.30802@gmail.com>
Date: Wed, 23 Mar 2011 23:45:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com> <20110322212519.GA12076@sgi.com> <20110322220505.GB13453@redhat.com> <20110323163255.GA17178@sgi.com> <20110323175320.GB9413@redhat.com> <20110323200008.GZ1239@redhat.com>
In-Reply-To: <20110323200008.GZ1239@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 11:00 PM, Don Zickus wrote:
> On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
>> Let me know if the patch fixes that problem.  Then it will be one less
>> thing to worry about. :-)
> 
> Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> against 2.6.38.  Sorry about that.
> 
> Cheers,
> Don
> 
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 87eab4a..62ec8e9 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1375,7 +1375,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	if ((handled > 1) ||
>  		/* the next nmi could be a back-to-back nmi */
>  	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
> -	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
> +	     (__this_cpu_read(pmu_nmi.handled) > 0) && handled && this_nmi)) {

Don, why do you need to check for this_nmi here? it's zero for first nmi in a
system (right?), so I fail to get the reason for such check. What I miss?

>  		/*
>  		 * We could have two subsequent back-to-back nmis: The
>  		 * first handles more than one counter, the 2nd
> @@ -1386,6 +1386,8 @@ perf_event_nmi_handler(struct notifier_block *self,
>  		 * handling more than one counter. We will mark the
>  		 * next (3rd) and then drop it if unhandled.
>  		 */
> +		//if ((__this_cpu_read(pmu_nmi.handled) == 1) && (handled == 1))
> +		//	trace_printk("!! fixed?\n");
>  		__this_cpu_write(pmu_nmi.marked, this_nmi + 1);
>  		__this_cpu_write(pmu_nmi.handled, handled);
>  	}


-- 
    Cyrill
