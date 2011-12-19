Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LSAxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:53:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:55186 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1LSAxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:53:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Colin Walters <walters@verbum.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
References: <1323280461.10724.13.camel@lenny>
	<20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	<20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
	<m1k45xyreb.fsf@fess.ebiederm.org> <1324224103.21713.26.camel@lenny>
Date: Sun, 18 Dec 2011 16:55:12 -0800
In-Reply-To: <1324224103.21713.26.camel@lenny> (Colin Walters's message of
	"Sun, 18 Dec 2011 11:01:43 -0500")
Message-ID: <m1ehw1mlcf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/nS3OY/V4fhDEYeXs+c2yBY7MY44WkGbI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1701]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Colin Walters <walters@verbum.org>
X-Spam-Relay-Country: **
Subject: Re: chroot(2) and bind mounts as non-root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Walters <walters@verbum.org> writes:

> On Thu, 2011-12-15 at 22:14 -0800, Eric W. Biederman wrote:
>
>> Which means it is safe to enter a new user namespace without root
>> privileges as once you are in if you execute a suid app it will be suid
>> relative to your user namespace.  The careful changing of capable to
>> ns_capable will allow other namespaces and other things that today are
>> root only because of fears of mucking up the execution environment to be
>> enabled.
>> 
>> What is slightly up in the air is how do we map user namespaces to
>> filesystems.  The simplest solution looks to be to setup a uid and gid
>> mappings from each child user namespace to the initial system user
>> namespace.  Then in a child user namespace setuid(2) will fail if
>> you attempt to use an id that does not have a mapping.
>
> But setting up a mapping is a privileged operation, right?  So then it
> seems that practically speaking in an "out of the box" scenario on a
> distro like RHEL or Debian, since there's no mapping configured, after a
> process enters a new namespace it can't run setuid binaries?  

Sort of.  Allowing the use of more than your current uid in the mapping
is a privileged operation.  I have a prototype that does an upcall using
the request-key infrastructure for the validation.

I expect by the time this makes it to "out of the box" experiences on
enterprise distros, useradd and friends will be giving out 1000 or so uids
to new accounts.

> Also I don't see how user namespaces can replace "fakeroot" if this is
> true.  The whole point of fakeroot is being able to do things like "make
> install DESTDIR=/home/user/tmpdir && tar cz -C /home/user/tmpdir -f
> foo.tar.gz ." to get a tarball with root-owned files, without actually
> requiring the privileges to temporarily make real root owned files.  But
> without a privileged mapping operation there's no way to map uid 0 in
> the namespace to something else on the filesystem, right?

Inside the user namespace the creators uid appears as uid 0.

> Basically it's not clear to me how you make user namespaces really
> flexible without patching the filesystems to support persisting the
> namespaces somehow.  Unix diehards will probably groan at this, but
> honestly the Windows approach where "uids" (SIDs) are strings has its
> appeal...that still requires patching filesystems (and in the end lots
> of userspace) but it's much more flexible.

The only thing that makes this better is a multi-part identifier stored
on disk where one part is a domain the identifier comes from.   That way
you can store overlapping identifiers and since your domains don't
conflict you are good.

At which point gaining access to a different persistent domain
identifier then your default one becomes a persistent identifier.

In practice I don't see any difference between that and gaining
access to a range of uids.  So I going forward with a range of uids
as my default case as that works with all unix filesystems without
extra work.

I don't know how a windows SIDs based system deals with storing files
from anther domain on the local filesystem.

Nothing prevents other filesystems using other algorithms besides
just storing the mapped uids for dealing with namespaces.   My goal
was to come up with a good default .

> I can see how the user namespace work is useful for containers though.

Oh definitely there.

I actually was thinking of a similar distributed build and test
environment as one of my test cases when I validated my design
the last round.

>> At the same time this means that
>> once you enter a user namespace all of the capabilities you can
>> acquire
>> are relative to that user namespace.
>
> So it seems like practically speaking if the goal is to be able to
> securely run code that "feels like" uid 0 in a container (e.g. start
> apache) you have to drop off most of the capabilities that let you take
> over the "host".  There's a number of these in CAP_SYS_ADMIN.

You misunderstood.  And you can look at the code in the kernel right
now for how this is implemented.

CAP_SYS_ADMIN in a user namespace is not the global CAP_SYS_ADMIN.

So despite having the user namespace's idea of CAP_SYS_ADMIN you can't
do the nasty CAP_SYS_ADMIN things.

So for the sites where CAP_SYS_ADMIN is required that are actually safe
for userspace once we remove the spoofing problem.  You will be allowed
to use those calls.

>> Still I find in the kernel it generally is easier to solve the general
>> case.  It makes everyone happy and it removes the need to ask people to
>> rewrite all of their in house applications.
>
> Right, clearly we can't just drop support for setuid binaries from the
> kernel, but we *do* have the source code to userspace...it's at least
> worth thinking about what could be better if we can assume there aren't
> setuid binaries.

Having a case where you don't have to worry about suid is very
compelling, and if I were to design an new unix like OS suid would
not be implemented.  I think the plan 9 guys got that right.

After going a couple rounds with how far can we go with suid being
disabled in my head I have decided to go down the user namespace route.
Especially since what is left is just cleaning up the code that is
in my tree and getting it merged.

> I need to think more about the user namespace stuff - but I'm not
> getting the impression so far it'll allow me to do what I want without
> adding a new setuid binary (or a mount hardlink) to util-linux
> basically.

I think the user namespace will do what you need. Certainly it appears
that everything in your example binary will be allowed by the time it is
done.  Still there is the old saying about a bird in the hand being
worth more than two birds in the bush.

Eric

