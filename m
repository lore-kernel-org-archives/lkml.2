Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2APV0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:26:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48179 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2APV0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:26:05 -0500
MIME-Version: 1.0
In-Reply-To: <1326746949.3467.16.camel@lenny>
References: <cover.1326673414.git.luto@amacapital.net> <1326746949.3467.16.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jan 2012 13:25:42 -0800
Message-ID: <CALCETrW3WyzaGBMJZzfohD=MRwdmeV9bAo4Leg1gaSnPL5URpg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
To: Colin Walters <walters@verbum.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:49 PM, Colin Walters <walters@verbum.org> wrote:
> On Sun, 2012-01-15 at 16:37 -0800, Andy Lutomirski wrote:
>> To make the no_new_privs discussion more concrete, here is an updated
>> series that is actually useful.  It adds PR_SET_NO_NEW_PRIVS
>
> I think it'd be clearer to call it PR_SET_NOSUID - basically it should
> match the semantics for MS_NOSUID mounts, as if on every exec()
> thereafter the target binary was on a nosuid filesystem.

The MS_NOSUID semantics are somewhat ridiculous for selinux, and I'd
rather not make them match for no_new_privs.  AppArmor completely
ignores MS_NOSUID, so I think the rename would just cause more
confusion.

>
> You might then change this flag to only take effect on a later exec(),
> which would solve your race condition for the hypothetical PAM module.

That would just make it more complicated.  The race is already solved
in the current patch, anyway.

>
>>  with the
>> same semantics as before (plus John Johansen's AppArmor fix and with
>> improved bisectability).  It then allows some unshare flags
>
> What's the rationale behind the unshare subset?  Did you actually
> analyze any setuid binaries found on Debian/Fedora etc. and determined
> that e.g. CLONE_NEWNET was problematic for some reason?

CLONE_NEWNET seems more likely to consume significant kernel resources
than the others.  I didn't have a great reason, though.  Unsharing the
filesystem namespace is possibly dangerous because it could prevent an
unmount in the original namespace from taking effect everywhere.

>
> I actually want CLONE_NEWNET for my build tool, so I can be sure the
> arbitrary code I'm executing as part of the build at least isn't
> downloading more new code.
>
>

Fair enough.  I may add this in v3.  seccomp is an even better
solution, though :)

--Andy
