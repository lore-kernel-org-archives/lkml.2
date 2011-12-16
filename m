Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1LPGNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:13:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47349 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1LPGNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:13:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Colin Walters <walters@verbum.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
References: <1323280461.10724.13.camel@lenny>
	<20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	<20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
Date: Thu, 15 Dec 2011 22:14:36 -0800
In-Reply-To: <1323982580.31563.15.camel@lenny> (Colin Walters's message of
	"Thu, 15 Dec 2011 15:56:18 -0500")
Message-ID: <m1k45xyreb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/AJaHk7Ez0uxkfgwXKE8nTo1LynvLnmOY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Colin Walters <walters@verbum.org>
X-Spam-Relay-Country: **
Subject: Re: chroot(2) and bind mounts as non-root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Walters <walters@verbum.org> writes:

> On Mon, 2011-12-12 at 23:11 +0000, Serge E. Hallyn wrote:
>
>> Look at the cap_get_bound.3 manpage, and look for CAP_IS_SUPPORTED.
>> If you start at CAP_LAST_CAP and keep going up/down depending on whether
>> it was support or not it shouldn't take too long to find the last
>> valid value.  Not ideal, but should be reliable.
>
> Blah =/  I think I'll just rely on the MS_NOSUID bind mount for now.
>
>> I haven't taken a critical look at the mount code but other than that
>> it seems reasonable and useful to me!  Thanks.
>
> Can you link me to any discussion of how the user namespace stuff you're
> working on would enable any of this (chroot, bind mounts) to be
> available to "unprivileged" users?  Is it that once a non-uid 0 process
> enters a new namespace, when executing a setuid 0 binary from the
> filesystem, because that binary is from a different user namespace, the
> setuid bits don't apply?
>
> What does it even mean for a file to be "owned" by a user namespace -
> unless you're talking about patching e.g. ext4 to persist namespaces
> somehow.
>
> Where I'd ultimately like to get is having this utility in util-linux,
> but before I propose that I'd like to have a good idea what the
> possibilities are with user namespaces.

The essentials is that all of the security credentials a process sees
(uids, gids, capabilities, keys) all belong to the user namespace.  This
allows process migration while still being able to use the same global
identifiers you were using before.  At the same time this means that
once you enter a user namespace all of the capabilities you can acquire
are relative to that user namespace.

You can look at the details of ns_capable (merged) to see how those
capabilities will work.

It is envisioned that the other namespaces will start recording the user
namespace that created them so we can evaluate ns_capable relative to
the creator of those namespaces.  (It is trivial work we are just
holding off so we don't introduce a security hole while we get the
other bits implemented).

Which means it is safe to enter a new user namespace without root
privileges as once you are in if you execute a suid app it will be suid
relative to your user namespace.  The careful changing of capable to
ns_capable will allow other namespaces and other things that today are
root only because of fears of mucking up the execution environment to be
enabled.

What is slightly up in the air is how do we map user namespaces to
filesystems.  The simplest solution looks to be to setup a uid and gid
mappings from each child user namespace to the initial system user
namespace.  Then in a child user namespace setuid(2) will fail if
you attempt to use an id that does not have a mapping.

Similarly in fs/exec.c:prepare_binprm() at the point where we test
MNT_NOSUID we will add an additional test to see if the uid and gid
of the executable will map to the target user namespace.  If the ids
don't map we skip the suid step entirely.

Since except at the edges of userspace we use uids and gids in the
initial user namespace, the implications for confusing other security
mechanisms is minimized.

The downside of requiring a mapping is that there is the tiniest bit of
user policy that will have to be added to the distributions to take full
advantage of the user namespace.  If you don't have that policy setup
your real uid will not change but you will appear to userspace and uid
0. Which should be sufficient to compile, chroot, mount and just about
everything else interesting without privileges.

> The more I think about this though, the more I am a big fan of what the
> OpenWall people are doing - if it gets me chroot as a user, I am totally
> on board with just removing all setuid binaries.  We're already fairly
> far along on doing that in GNOME by using PolicyKit mechanisms
> anyways.

I am a great fan of the idea of removing from user space applications
the ability to gain privileges during exec.  There are some many fewer
cases you have to audit for, and it requires less kernel code to support
overall.  Although I admit the direction you have suggested at the
beginning of this thread has it's appeal.

Still I find in the kernel it generally is easier to solve the general
case.  It makes everyone happy and it removes the need to ask people to
rewrite all of their in house applications.

Eric
