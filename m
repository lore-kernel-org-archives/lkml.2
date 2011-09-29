Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1I2WSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:18:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1I2WSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:18:21 -0400
Date: Fri, 30 Sep 2011 00:18:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm00@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmod: prevent kmod_loop_msg overflow in
 __request_module()
In-Reply-To: <20110929143129.e7c3c7e2.akpm00@gmail.com>
Message-ID: <alpine.LNX.2.00.1109292337030.24692@pobox.suse.cz>
References: <alpine.LNX.2.00.1109291749000.24692@pobox.suse.cz> <20110929143129.e7c3c7e2.akpm00@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Andrew Morton wrote:

> > Due to post-decrement
> 
> (post-increment)

Indeed, thanks for noticing.

> > in condition of kmod_loop_msg in __request_module(),
> > the system log can be spammed by much more than 5 instances of the 'runaway
> > loop' message if the number of events triggering it makes the kmod_loop_msg
> > to overflow.
> > 
> > Fix that by making sure we never increment it past the threshold.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  kernel/kmod.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/kmod.c b/kernel/kmod.c
> > index ddc7644..a4bea97 100644
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -114,10 +114,12 @@ int __request_module(bool wait, const char *fmt, ...)
> >  	atomic_inc(&kmod_concurrent);
> >  	if (atomic_read(&kmod_concurrent) > max_modprobes) {
> >  		/* We may be blaming an innocent here, but unlikely */
> > -		if (kmod_loop_msg++ < 5)
> > +		if (kmod_loop_msg < 5) {
> >  			printk(KERN_ERR
> >  			       "request_module: runaway loop modprobe %s\n",
> >  			       module_name);
> > +			kmod_loop_msg++;
> > +		}
> >  		atomic_dec(&kmod_concurrent);
> >  		return -ENOMEM;
> >  	}
> 
> Well, it will take two billion passes through here to cause the
> overflow.  I really hope you found this problem by inspection!

Unfortunately not, it was more painful experience than code reading :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
