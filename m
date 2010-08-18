Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0HRVox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:44:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50525 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0HRVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rro702hy2lR3+4fcZRWw4Z+TM5f6V8xqPOdguSF/KuYDcTvK3isHLGUCodxz9ZcRg9
         9aAkUh7FKpfJWqzDAfwQgkrkhQs8JxUP9mb87TUhYxk5Ts10ID+tPDyGZTJvj3MTeaH9
         vt63nVYve690rX9Pgiz4VPDXHVhCV5eOl+Fxw=
Date: Thu, 19 Aug 2010 01:44:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
	touch_softlockup_watchdog
Message-ID: <20100818214447.GC11949@lenovo>
References: <20100813102158.GA5434@swordfish.minsk.epam.com> <20100818123346.02028e96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818123346.02028e96.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 12:33:46PM -0700, Andrew Morton wrote:
> On Fri, 13 Aug 2010 13:21:58 +0300
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> 
> > Hello,
> > 
> > Got this traces today:
> > 
> > ...
> > 

...

> >  void touch_softlockup_watchdog(void)
> >  {
> > -	__get_cpu_var(watchdog_touch_ts) = 0;
> > +	int this_cpu = get_cpu();
> > +	per_cpu(watchdog_touch_ts, this_cpu) = 0;
> > +	put_cpu();
> >  }
> >  EXPORT_SYMBOL(touch_softlockup_watchdog);
> >  
> > @@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
> >  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> >  void touch_nmi_watchdog(void)
> >  {
> > -	__get_cpu_var(watchdog_nmi_touch) = true;
> > +	int this_cpu = get_cpu();
> > +	per_cpu(watchdog_nmi_touch, this_cpu) = true;
> > +	put_cpu();
> >  	touch_softlockup_watchdog();
> >  }
> >  EXPORT_SYMBOL(touch_nmi_watchdog);
> 
> Why did this start happening?  Surely we've called
> touch_softlockup_watchdog() from within preemptible code before now. 

indeed, and we've been using __raw interface before (2.6.18)

void touch_softlockup_watchdog(void)
{
	__raw_get_cpu_var(touch_timestamp) = jiffies;
}

> Methinks that
> 
> : commit 26e09c6eee14f4827b55137ba0eedc4e77cd50ab
> : Author:     Don Zickus <dzickus@redhat.com>
> : AuthorDate: Mon May 17 18:06:04 2010 -0400
> : Commit:     Frederic Weisbecker <fweisbec@gmail.com>
> : CommitDate: Wed May 19 11:32:14 2010 +0200
> : 
> :     lockup_detector: Convert per_cpu to __get_cpu_var for readability
> 
> was simply broken?  That would be strange, given that it's been sitting
> around since May 17.
> 
> If we don't want to revert 26e09c6eee14f4827b55137ba0eedc4e77cd50ab
> then I'd suggest that we simply switch to raw_smp_processor_id(): those
> newly-added get_cpu/put_cpu calls don't do anything useful.
>

I think it's fine to use __get_cpu_var in touch_nmi_watchdog (which should not
be called with irq enabled since it ticks anyway then, at least on x86) for hardware
nmi watchdog, can't conclude anything about softlockup (except that we had __raw
interface before) since I'm not familiar with soflockup watchdog at moment.

	-- Cyrill
