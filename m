Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1LSEFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:05:20 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:56905 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1LSEFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:05:19 -0500
Date: Mon, 19 Dec 2011 04:06:04 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Colin Walters <walters@verbum.org>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Subject: Re: chroot(2) and bind mounts as non-root
Message-ID: <20111219040604.GA2205@hallyn.com>
References: <1323280461.10724.13.camel@lenny>
 <20111210052945.GA14931@hallyn.com>
 <1323708089.29338.39.camel@lenny>
 <20111212231149.GA16408@hallyn.com>
 <1323982580.31563.15.camel@lenny>
 <m1k45xyreb.fsf@fess.ebiederm.org>
 <1324224103.21713.26.camel@lenny>
 <m1ehw1mlcf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehw1mlcf.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Colin Walters <walters@verbum.org> writes:
> 
> > On Thu, 2011-12-15 at 22:14 -0800, Eric W. Biederman wrote:
> >
> >> Which means it is safe to enter a new user namespace without root
> >> privileges as once you are in if you execute a suid app it will be suid
> >> relative to your user namespace.  The careful changing of capable to
> >> ns_capable will allow other namespaces and other things that today are
> >> root only because of fears of mucking up the execution environment to be
> >> enabled.
> >> 
> >> What is slightly up in the air is how do we map user namespaces to
> >> filesystems.  The simplest solution looks to be to setup a uid and gid
> >> mappings from each child user namespace to the initial system user
> >> namespace.  Then in a child user namespace setuid(2) will fail if
> >> you attempt to use an id that does not have a mapping.
> >
> > But setting up a mapping is a privileged operation, right?  So then it
> > seems that practically speaking in an "out of the box" scenario on a
> > distro like RHEL or Debian, since there's no mapping configured, after a
> > process enters a new namespace it can't run setuid binaries?  
> 
> Sort of.  Allowing the use of more than your current uid in the mapping
> is a privileged operation.  I have a prototype that does an upcall using
> the request-key infrastructure for the validation.

If I understand you both right, I think what Eric said here is not relevant
to what Colin cares about.

Colin, for the case of "fakeroot debian/rules binary" or
build+create-tarball inside of a user namespace, all that will matter
to you is that yes, inside the user namespace which you created without
privilege you will be able to create files which are owned by (the user
namespace's) root, and so you'll be able to get the tarball or .deb with
root owned files.

The mapping Eric is talking about here is new even to me, but I think it
is an implementation detail referring to a proposal where each uid in the
container maps to a real uid on the host.  The only thing about that mapping
that matters is that none of the host uids conflict with existing host
uids (or uids mapped for other containers).  Now if you want to do cool
things like map uid 501 on the host to 1001 in the container as well as
502 on the host to 1010 in the container, that will be supported - and I
think that's what Eric is referring to.

But for the sake of fire-off-a-build, you can ignore that and use random
uids on the host side of the mapping.

> I expect by the time this makes it to "out of the box" experiences on
> enterprise distros, useradd and friends will be giving out 1000 or so uids
> to new accounts.
> 
> > Also I don't see how user namespaces can replace "fakeroot" if this is
> > true.  The whole point of fakeroot is being able to do things like "make
> > install DESTDIR=/home/user/tmpdir && tar cz -C /home/user/tmpdir -f
> > foo.tar.gz ." to get a tarball with root-owned files, without actually
> > requiring the privileges to temporarily make real root owned files.  But
> > without a privileged mapping operation there's no way to map uid 0 in
> > the namespace to something else on the filesystem, right?
> 
> Inside the user namespace the creators uid appears as uid 0.

That's the most important thing, for your (Colin) use case, which should
give you what you ened.

...

> > So it seems like practically speaking if the goal is to be able to
> > securely run code that "feels like" uid 0 in a container (e.g. start
> > apache) you have to drop off most of the capabilities that let you take
> > over the "host".  There's a number of these in CAP_SYS_ADMIN.
> 
> You misunderstood.  And you can look at the code in the kernel right
> now for how this is implemented.
> 
> CAP_SYS_ADMIN in a user namespace is not the global CAP_SYS_ADMIN.

In particular, compare

capable(CAP_SYS_ADMIN)

to

ns_capable(ns, CAP_SYS_ADMIN).

...

> I think the user namespace will do what you need. Certainly it appears

As do I.

> that everything in your example binary will be allowed by the time it is
> done.  Still there is the old saying about a bird in the hand being
> worth more than two birds in the bush.
> 
> Eric

Right, this isn't there yet, after all, and your (Colin) program is  :)

-serge
