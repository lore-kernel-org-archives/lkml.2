Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2JITDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:03:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39572 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab2JITDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:03:05 -0400
X-Sasl-enc: ZDSj4Vm/EulFmdTs2ZSK1stKMlQwMhlDb4v7q6aoFI7c 1349809383
Date: Tue, 9 Oct 2012 12:03:00 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns (v3)
Message-ID: <20121009190300.GB22108@kroah.com>
References: <1349553393-902065-1-git-send-email-avagin@openvz.org>
 <20121009114821.dc4c2aff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009114821.dc4c2aff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:48:21AM -0700, Andrew Morton wrote:
> On Sat,  6 Oct 2012 23:56:33 +0400
> Andrew Vagin <avagin@openvz.org> wrote:
> 
> > Here is a stack trace of recursion:
> > free_pid_ns(parent)
> >   put_pid_ns(parent)
> >     kref_put(&ns->kref, free_pid_ns);
> >       free_pid_ns
> > 
> > This patch turns recursion into loops.
> > 
> > pidns can be nested many times, so in case of recursion
> > a simple user space program can provoke a kernel panic
> > due to exceed of a kernel stack.
> 
> So we should backport this into earlier kernels.
> 
> > --- a/include/linux/kref.h
> > +++ b/include/linux/kref.h
> > @@ -95,6 +95,18 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
> >  	return kref_sub(kref, 1, release);
> >  }
> >  
> > +/**
> > + * kref_put - decrement refcount for object.
> > + * @kref: object.
> > + *
> > + * Decrement the refcount.
> > + * Return 1 if refcount is zero.
> > + */
> > +static inline int __kref_put(struct kref *kref)
> > +{
> > +	return atomic_dec_and_test(&kref->refcount);
> > +}
> 
> Greg might be interested in this.
> 
> It's a pretty specialised thing and perhaps it needs some stern words
> in the description explaining when and why it should and shouldn't be
> used.
> 
> I wonder if people might (ab)use this to avoid the "doesn't
> have a release function" warning.

Yes they would, please don't do this at all.

In fact, why is it needed?  It doesn't solve anything (if it does,
something in the way the kref is being used is wrong.)

Please no, I don't want this patch.

greg k-h
