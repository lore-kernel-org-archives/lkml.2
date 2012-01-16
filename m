Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2APUPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:15:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54550 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2APUPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120116200618.GN23916@ZenIV.linux.org.uk>
References: <cover.1326673414.git.luto@amacapital.net> <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
 <20120116200618.GN23916@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jan 2012 12:15:09 -0800
Message-ID: <CALCETrU62cq43hd7Wray0eZQfbQ9+hkuuo9AzCFgrL_2h_v7qw@mail.gmail.com>
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jan 15, 2012 at 04:37:21PM -0800, Andy Lutomirski wrote:
>
>> +     is_chrooted = (fs->root.mnt->mnt_mountpoint !=
>> +                    fs->root.mnt->mnt_parent->mnt_root ||
>> +                    fs->root.dentry != fs->root.mnt->mnt_root);
>
> Folks, is it _that_ hard to at least try to compile your patches?  Hint:
> this one will *not*.  That sad detail aside, this test would have been
> a pile of garbage even on the kernels that used to have mnt_mountpoint
> in struct vfsmount.  What *are* you trying to test here?  The last part
> at least does make some sense - it's "process root happens to be the
> root of some vfsmount".  The first part, though, makes no sense whatsoever;
> it's "... and that vfsmount is mounted on top of root of some other
> vfsmount".

I compiled it, booted it, and tested it.  I based it off an oldish
kernel, though, so I can rebase.

The first approach I tried was (from memory -- may not compile at all
on any version) fs->root.mnt != fs->root.mnt->mnt_parent.  That didn't
work.  The issue is that on dracut-based distros, AFAICT, the root (in
the sense of the root of the tree of struct vfsmounts) is rootfs.  The
apparent root (the filesystem containing /, /usr, etc) is mounted on
top of (rootfs)/.  Dracut then does something with the effect of
chroot("/").  So you end up with the vfsmount that contains "/" not
being the actual root vfsmount.  But there's nothing hidden by the
chroot -- even if fs->root.mnt pointed at rootfs, "/" would still
follow the mountpoint into the actual filesystem.

An different approach would be to have fs_struct keep track of a hard
and a soft root.  chroot would stay CAP_SYS_ADMIN only and change both
roots.  A new unprivileged_chroot would change only the soft root.
follow_dotdot would check both, so unprivileged_chroot wouldn't be
useful for breaking chroot.  The big downside would be an extra branch
on every follow_dotdot.

--Andy
