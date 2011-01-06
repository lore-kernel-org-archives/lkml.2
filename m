Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1AFAdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:33:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab1AFAdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:33:36 -0500
Date: Thu, 6 Jan 2011 11:33:27 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Change wait_for_completion_*_timeout to return a signed
 long
Message-ID: <20110106113327.5d224a8c@notabene.brown>
In-Reply-To: <20110105145725.3fa6d659.akpm@linux-foundation.org>
References: <20110105125016.64ccab0e@notabene.brown>
	<20110105145725.3fa6d659.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 14:57:25 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed, 5 Jan 2011 12:50:16 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > 
> > wait_for_completion_*_timeout can return:
> > 
> >  0 if the wait timed out
> >  -ve if the wait was interrupted
> >  +ve if the completion was completed.
> > 
> > As they currently return an 'unsigned long', the last two cases are not
> > easily distinguished which can easily result in buggy code, as is the
> > case for the recently added wait_for_completion_interruptible_timeout
> > call in net/sunrpc/cache.c
> > 
> > So change them both to return 'long'.  As MAX_SCHEDULE_TIMEOUT is
> > LONG_MAX, a large +ve return value should never overflow.
> > 
> > ...
> >
> > --- a/include/linux/completion.h
> > +++ b/include/linux/completion.h
> > @@ -80,11 +80,11 @@ extern void wait_for_completion(struct completion *);
> >  extern int wait_for_completion_interruptible(struct completion *x);
> >  extern int wait_for_completion_killable(struct completion *x);
> >  extern unsigned long wait_for_completion_timeout(struct completion *x,
> >  						   unsigned long timeout);
> > -extern unsigned long wait_for_completion_interruptible_timeout(
> > -			struct completion *x, unsigned long timeout);
> > -extern unsigned long wait_for_completion_killable_timeout(
> > -			struct completion *x, unsigned long timeout);
> > +extern long wait_for_completion_interruptible_timeout(
> > +	struct completion *x, unsigned long timeout);
> > +extern long wait_for_completion_killable_timeout(
> > +	struct completion *x, unsigned long timeout);
> >  extern bool try_wait_for_completion(struct completion *x);
> >  extern bool completion_done(struct completion *x);
> >  
> 
> That's a half-patch, isn't it?  wait_for_completion_interruptible()
> still incorrectly returns `int' and wait_for_completion_timeout() still
> returns `unsigned long'.

Half a patch is better than half a bug report is better than half an oops
message is better than none ..... (am I showing my age?)


wait_for_completion_interruptile returns either a negative error (-ERESTART)
or 0.  So 'int' is fine.  Ditto for wait_for_completion_killable.
wait_for_completion_timeout returns a positive timeout-remaining or 0, so
'unsigned long' is fine.

It is only when we come to combining 'interruptible' and 'timeout' that we
need signed and long.

Now maybe it would be good to use "signed long" for all of them because
consistency is a nice thing.  Or maybe it is best to specify in each case the
return type that is most clearly meaningful because that communicates more
clearly.
I really cannot say - I just wanted to fix a bug :-)

NeilBrown
