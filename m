Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0DUVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:46:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43329 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0DUVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BM2bv+Bf57bPV/TqZbGcMXTMLUBiv22bPKKEXb/ZeK89LoVmj3oNbbASHrnEo6n02W
         R7jjD7RoppgskKXSns7awH421NBHJESxAb5/PQxnDwYWrRSr8kx10BFIjxIraKKEiGmn
         LgtKAIjyuSCP2jdFmzLLLSQ8pAYSlefCWAaYo=
Date: Wed, 21 Apr 2010 23:46:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/6] [watchdog] convert touch_softlockup_watchdog to
	touch_watchdog
Message-ID: <20100421214610.GE8677@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-3-git-send-email-dzickus@redhat.com> <20100421204559.GB8677@nowhere> <20100421213142.GY15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421213142.GY15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 05:31:42PM -0400, Don Zickus wrote:
> On Wed, Apr 21, 2010 at 10:46:01PM +0200, Frederic Weisbecker wrote:
> > On Tue, Apr 20, 2010 at 11:23:59AM -0400, Don Zickus wrote:
> > > Just a scripted conversion to remove touch_softlockup_watchdog.
> > > 
> > > Also converts the once case of touch_all_softlockup_watchdogs to
> > > touch_all_watchdogs.
> > > 
> > > This is done as part of the removal of the old softlockup code and
> > > transition to the new softlockup code.
> > > 
> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > 
> > 
> > In fact I worry a bit about this unification of watchdog touching.
> > When we touch the softlockup watchdog, do we also want to touch
> > the nmi watchdog?
> > 
> > Most of the time, I think we don't want to. We usually touch the
> > softlockup detector because we know we are abnormally delaying
> > the softlockup kthread from being scheduled, and if we are in such
> > situation, it means we are doing something in a sensitive context:
> > typically the kind of context favorable to create hardlockups...
> > 
> > But the opposite is right: if we touch the nmi watchdog: it means we
> > are abnormally delaying irqs, which means we also are abnormally
> > delaying the softlockup kthread from being scheduled, so if we
> > touch the nmi watchdog, we also want to touch the softlockup
> > detector.
> > 
> > Hence I guess we want to keep the current state:
> > 
> > - touch_nmi_watchdog() = touch softlockup and nmi watchdogs
> > - touch_softlockup_watchdog() = only touch softlockup watchdog
> 
> Hmm ok I see what you are saying.  A little tweak and I have this
> compiled-tested only patch that I think satisifies you.
> 
> I didn't really touch the touch_nmi_watchdog() code in the kernel, so it
> still calls a stub function in kernel/watchdog.c.  Add a boolean to that
> path and I think it accomplishes the logic you are looking for.
> 
> Cheers,
> Don


Yeah looks good.

Could you send this patch with a changelog and your sign-off?

Thanks!

> 
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 9898c7c..c1a89ac 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -31,6 +31,7 @@ int watchdog_enabled;
>  int __read_mostly softlockup_thresh = 60;
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
> +static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
>  static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
>  static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
>  static DEFINE_PER_CPU(bool, watchdog_touch_sync);
> @@ -147,6 +148,7 @@ void touch_watchdog_sync(void)
>  
>  void touch_nmi_watchdog(void)
>  {
> +	__get_cpu_var(watchdog_nmi_touch) = true;
>  	touch_watchdog();
>  }
>  EXPORT_SYMBOL(touch_nmi_watchdog);
> @@ -203,11 +205,10 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  		 struct pt_regs *regs)
>  {
>  	int this_cpu = smp_processor_id();
> -	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
>  	char warn = per_cpu(watchdog_warn, this_cpu);
>  
> -	if (touch_ts == 0) {
> -		__touch_watchdog();
> +	if (__get_cpu_var(watchdog_nmi_touch) == true) {
> +		__get_cpu_var(watchdog_nmi_touch) = false;
>  		return;
>  	}
>  

