Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1LRQCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 11:02:06 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57619 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab1LRQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 11:02:03 -0500
X-Sasl-enc: Oy3gUQggRBJlSGd+wsDUrDHLepz762icJ6WSxjJJ9TE9 1324224122
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Date: Sun, 18 Dec 2011 11:01:43 -0500
In-Reply-To: <m1k45xyreb.fsf@fess.ebiederm.org>
References: <1323280461.10724.13.camel@lenny>
	 <20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	 <20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
	 <m1k45xyreb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324224103.21713.26.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 22:14 -0800, Eric W. Biederman wrote:

> Which means it is safe to enter a new user namespace without root
> privileges as once you are in if you execute a suid app it will be suid
> relative to your user namespace.  The careful changing of capable to
> ns_capable will allow other namespaces and other things that today are
> root only because of fears of mucking up the execution environment to be
> enabled.
> 
> What is slightly up in the air is how do we map user namespaces to
> filesystems.  The simplest solution looks to be to setup a uid and gid
> mappings from each child user namespace to the initial system user
> namespace.  Then in a child user namespace setuid(2) will fail if
> you attempt to use an id that does not have a mapping.

But setting up a mapping is a privileged operation, right?  So then it
seems that practically speaking in an "out of the box" scenario on a
distro like RHEL or Debian, since there's no mapping configured, after a
process enters a new namespace it can't run setuid binaries?  

Also I don't see how user namespaces can replace "fakeroot" if this is
true.  The whole point of fakeroot is being able to do things like "make
install DESTDIR=/home/user/tmpdir && tar cz -C /home/user/tmpdir -f
foo.tar.gz ." to get a tarball with root-owned files, without actually
requiring the privileges to temporarily make real root owned files.  But
without a privileged mapping operation there's no way to map uid 0 in
the namespace to something else on the filesystem, right?

Basically it's not clear to me how you make user namespaces really
flexible without patching the filesystems to support persisting the
namespaces somehow.  Unix diehards will probably groan at this, but
honestly the Windows approach where "uids" (SIDs) are strings has its
appeal...that still requires patching filesystems (and in the end lots
of userspace) but it's much more flexible.

I can see how the user namespace work is useful for containers though.

> At the same time this means that
> once you enter a user namespace all of the capabilities you can
> acquire
> are relative to that user namespace.

So it seems like practically speaking if the goal is to be able to
securely run code that "feels like" uid 0 in a container (e.g. start
apache) you have to drop off most of the capabilities that let you take
over the "host".  There's a number of these in CAP_SYS_ADMIN.

> Still I find in the kernel it generally is easier to solve the general
> case.  It makes everyone happy and it removes the need to ask people to
> rewrite all of their in house applications.

Right, clearly we can't just drop support for setuid binaries from the
kernel, but we *do* have the source code to userspace...it's at least
worth thinking about what could be better if we can assume there aren't
setuid binaries.

I need to think more about the user namespace stuff - but I'm not
getting the impression so far it'll allow me to do what I want without
adding a new setuid binary (or a mount hardlink) to util-linux
basically.


