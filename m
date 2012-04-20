Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2DTIJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:09:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54709 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2DTIJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:09:23 -0400
Date: Fri, 20 Apr 2012 09:09:14 +0100
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
Message-ID: <20120420080914.GF6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 07:58:57PM -0700, Linus Torvalds wrote:
> On Thu, Apr 19, 2012 at 7:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm... ?I really wonder if we *want* filp_close() under any kind of
> > locks. ?You are right - it should not be deferred. ?I haven't finished
> > checking the callers of that puppy, but if we really do it while holding
> > any kind of lock, we are asking for trouble. ?So I'd rather switch
> > filp_close() to use of fput_nodefer() if that turns out to be possible.
> 
> Ok, fair enough, looks like a reasonable plan to me.

Actually, scratch that; I think I have a better variant
	* switch to fget_light/fput_light where possible; it's not needed
for the rest, but is useful anyway
	* move the guts of filp_close() (everything prior to fput() it does
in the end) into a new helper, turning filp_close() into a couple of calls
(inlined, at that).  Equivalent transformation.
	* add fput_nodefer(); does the same thing fput() does now.  Make
fput() defer the call of __fput().  Add a filp_close_nodefer() - same as
filp_close(), but the second call in it is fput_nodefer(), not fput().  And
switch the callers that are known to be done outside of any locks to
filp_close_nodefer().  Switch accept4()/socketpair() to fput_nodefer()
(for freshly created struct file in case of cleanup on failure exit).

Note that we do *not* need to bother with fput_light() - even if it does
fput(), that fput() won't usually be the final one.  We'd need it to
race with close() or dup2() from another thread for that to happen.  So
we only need to review the callers of filp_close() and there are much
fewer of those.

We also get something else out of that - AFAICS, the kludge in __scm_destroy()
can be killed after that.  We did it to prevent recursion on fput(), right?
Now that recursion will be gone...

I'd probably not bother with trying to be clever in doing the deferral itself -
the point is to make it rare, so it's not a hot path anyway.  We can play
with per-CPU lists, etc., but in this case dumber is better.

Comments?  I'm half-asleep right now, so I might be missing something
obvious...
