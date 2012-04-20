Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2DTCyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:54:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48930 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2DTCyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:54:44 -0400
Date: Fri, 20 Apr 2012 03:54:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420025438.GD6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 07:31:01PM -0700, Linus Torvalds wrote:
> On Thu, Apr 19, 2012 at 5:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > However, there's an approach that might be feasible. ?Most of the time
> > the final fput() *is* done without any locks held and there's a very
> > large subclass of those call sites - those that come via fput_light().
> > What we could do, and what might be maintainable is:
> > ? ? ? ?* prohibit fput_light() with locks held. ?Right now we are very
> > close to that (or already there - I haven't finished checking).
> > ? ? ? ?* convert low-hanging fget/fput in syscalls to fget_light/fput_light.
> > Makes sense anyway.
> 
> Many of them would make sense, yes (looking at vfs_fstatat() etc.
> 
> But a lot of fput() calls come from close() -> filp_close -> fput().
> 
> And the "fput_light()" model *only* works together with fget_light()
> as it is now.
> 
> So I do think you need some other model. Of course, we can just do
> "fput_light(file, 1)" instead - that seems pretty ugly, though. But
> just making "fput()" do a defer on the last count sounds actively
> *wrong* for things like close(), which may actually have serious
> consistency guarantees (ie the process doing the close() may "know"
> that it is the last user, and depend on the fact that the close() did
> actually delete the inode etc.

Umm...  I really wonder if we *want* filp_close() under any kind of
locks.  You are right - it should not be deferred.  I haven't finished
checking the callers of that puppy, but if we really do it while holding
any kind of lock, we are asking for trouble.  So I'd rather switch
filp_close() to use of fput_nodefer() if that turns out to be possible.

FWIW, the set of primitives I'm thinking of right now is

__fput(file) - same as now
schedule_fput(file) - takes the only reference to file and schedules __fput()
fput_nodefer(file)
{
        if (atomic_long_dec_and_test(&file->f_count))
                __fput(file);
}
fput(file)
{
	if (unlikely(!fput_atomic(file))
		schedule_fput(file);
}
fput_light(file, need_fput)
{
	if (need_fput)
		fput_nodefer(file);
}
fput_light_defer(file, need_fput) // for callers in some weird ioctls, might
				  // not be needed at all
{
	if (need_fput)
		fput(file);
}

and filp_close() would, if that turns out to be possible, call fput_nodefer()
instead of fput().  If we *do* have places where we need deferral in
filp_close() (and I'm fairly sure that any such place is a deadlock right
now), well, we'll need a variant of filp_close() sans the call of fput...()
and those places would call that, followed by full (deferring) fput().
