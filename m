Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0LQUIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:08:00 -0500
Received: from kroah.org ([198.145.64.141]:38976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab0LQUHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:07:47 -0500
Date: Fri, 17 Dec 2010 11:58:29 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as
 creator/owner of uts_namespace
Message-ID: <20101217195829.GB1410@kroah.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217173125.GA29982@kroah.com>
 <m18vzoryit.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18vzoryit.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:26:50AM -0800, Eric W. Biederman wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Fri, Dec 17, 2010 at 03:24:58PM +0000, Serge E. Hallyn wrote:
> >> copy_process() handles CLONE_NEWUSER before the rest of the
> >> namespaces.  So in the case of clone(CLONE_NEWUSER|CLONE_NEWUTS)
> >> the new uts namespace will have the new user namespace as its
> >> owner.  That is what we want, since we want root in that new
> >> userns to be able to have privilege over it.
> >> 
> >> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> >> ---
> >>  include/linux/utsname.h |    3 +++
> >>  init/version.c          |    2 ++
> >>  kernel/nsproxy.c        |    3 +++
> >>  kernel/user.c           |    8 ++++++--
> >>  kernel/utsname.c        |    4 ++++
> >>  5 files changed, 18 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> >> index 69f3997..85171be 100644
> >> --- a/include/linux/utsname.h
> >> +++ b/include/linux/utsname.h
> >> @@ -37,9 +37,12 @@ struct new_utsname {
> >>  #include <linux/nsproxy.h>
> >>  #include <linux/err.h>
> >>  
> >> +struct user_namespace;
> >> +
> >>  struct uts_namespace {
> >>  	struct kref kref;
> >>  	struct new_utsname name;
> >> +	struct user_namespace *user_ns;
> >>  };
> >>  extern struct uts_namespace init_uts_ns;
> >>  
> >> diff --git a/init/version.c b/init/version.c
> >> index 79fb8c2..9eb19fb 100644
> >> --- a/init/version.c
> >> +++ b/init/version.c
> >> @@ -21,6 +21,7 @@ extern int version_string(LINUX_VERSION_CODE);
> >>  int version_string(LINUX_VERSION_CODE);
> >>  #endif
> >>  
> >> +extern struct user_namespace init_user_ns;
> >>  struct uts_namespace init_uts_ns = {
> >>  	.kref = {
> >>  		.refcount	= ATOMIC_INIT(2),
> >
> > Wait, WTF?
> >
> > You have a static kref and you try to automatically instanciate it here?
> > As it's static, why are you even having a kref at all, what good does it
> > do you, you can't delete the thing, it's always around, so just remove
> > it entirely please.
> >
> > Or, dynamically create it properly.  In other words, this is majorly
> > broken.
> 
> There is a very weird case for the data structures the initial task has
> references to.  The initial task never goes away and so those data
> structure never go away.  Furthermore we need many of those data
> structures before we have a memory allocator ready.  So we statically
> allocate a single data structure and up it's reference count to ensure
> that the count never goes to zero.

Why not just dynamically create this structure once and then, if what
you say is really true, you never have to worry about the structure
going away, right?

> There are also major benefits to have the version of something that is
> never freed never going away, because it means you can just reference it
> in code.  So while I would be happy to say this is special don't use a
> kref and roll the reference counting logic by hand, we aren't
> dynamically allocating init_uts_ns any time soon.

Why have a reference count at all if it's not needed or used here?

confused,

greg k-h
