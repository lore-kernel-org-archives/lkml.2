Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2APVr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:47:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43284 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656Ab2APVrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:47:23 -0500
X-Sasl-enc: 2C7AtOqqYNnLqCfmo5yjEo9C24ILgxORKWqcXCX8m+GN 1326750442
Subject: Re: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 16 Jan 2012 16:47:00 -0500
In-Reply-To: <CALCETrW3WyzaGBMJZzfohD=MRwdmeV9bAo4Leg1gaSnPL5URpg@mail.gmail.com>
References: <cover.1326673414.git.luto@amacapital.net>
	 <1326746949.3467.16.camel@lenny>
	 <CALCETrW3WyzaGBMJZzfohD=MRwdmeV9bAo4Leg1gaSnPL5URpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326750422.3467.31.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 13:25 -0800, Andy Lutomirski wrote:

> The MS_NOSUID semantics are somewhat ridiculous for selinux, 

I don't see how they're ridiculous.

> and I'd
> rather not make them match for no_new_privs. 

Note your patch for selinux does exactly the same thing in the NOSUID
case and your NO_NEW_PRIVS flag.  Right?

-       if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+       if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
+           (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
                new_tsec->sid = old_tsec->sid;


>  AppArmor completely
> ignores MS_NOSUID,

Ugh...well, I guess if it doesn't store any security data associated
with files, only with file names, then there's nothing for it to do.
Like I said before though, I think SELinux is the only sane LSM.

> CLONE_NEWNET seems more likely to consume significant kernel resources
> than the others. 

This actually brings up something we need to think about - if we're
heading towards being able to do bind mounts as non-root (which is
necessary for me) we'd need limits on e.g. the number of mounts that can
be made for a given uid/cgroup.

I have a picked-from-thin-air hardcoded limit of 50 in my setuid binary,
but I just realized that that's 50*RLIMIT_NPROC which is kind of
large...

>  I didn't have a great reason, though.  Unsharing the
> filesystem namespace is possibly dangerous because it could prevent an
> unmount in the original namespace from taking effect everywhere.

Hmmm...hadn't considered that either.  So the issue here is if a server
admin has e.g. a NFS mount and my build tool makes a new copy of the
mount namespace, a process may still have it busy when she goes to
unmount it?

> Fair enough.  I may add this in v3.  seccomp is an even better
> solution, though :)

Yeah, definitely more flexible, though realistic use of seccomp depends
on someone making a nice userspace tool to compile sets of syscalls like
"no networking".

