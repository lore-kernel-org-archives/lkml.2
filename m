Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2ICPE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:04:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38217 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:04:25 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: sedat.dilek@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Subject: Re: [PATCH 08/13] fs: limit filesystem stacking depth
In-Reply-To: <CA+icZUVz1DNBipOOT_j+ewKSuuFR0775RKyRWq4CcDqwafqC8Q@mail.gmail.com>
	(Sedat Dilek's message of "Thu, 16 Aug 2012 15:24:08 +0200")
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-9-git-send-email-miklos@szeredi.hu>
	<CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
	<87sjbnce4k.fsf@tucsk.pomaz.szeredi.hu>
	<CA+icZUVz1DNBipOOT_j+ewKSuuFR0775RKyRWq4CcDqwafqC8Q@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Mon, 03 Sep 2012 17:05:55 +0200
Message-ID: <87mx17du3w.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

>>
>> Yes, setting it to 2 is defensive, it would need more stack depth
>> analysis to see what an acceptable number would be.
>>
>
> Can you describe such an analysis method (in case you need help for
> testing it)?


I attached a systemtap script (x86-64 specific) which prints stack use
for stacked overlayfs filesystems.  Interpret output like this:

7288    0  ovl_lookup (bash/5721)
^          ^
|          |
|          +- function name (process/pid)
|
+------------ current stack use

7080  208          ovl_permission (bash/5721)
      ^    ^
      |    |
      |    +- stacking depth indicated by indentation
      |
      +------ stack increase from previous stacking level


You can try it on various setups (overlayfs being used as the lower
and/or upper level) and executing various filesystem operations.

Looks like "copy up" is the most stack hungry operation, it may be worth
trying to reduce its stack usage.

Thanks,
Miklos
---

global rec_level, stacks

probe
	kernel.function("ovl_permission"),
	kernel.function("ovl_getattr"),
	kernel.function("ovl_dir_getattr"),
	kernel.function("ovl_setattr"),
	kernel.function("ovl_setxattr"),
	kernel.function("ovl_listxattr"),
	kernel.function("ovl_removexattr"),
	kernel.function("ovl_dentry_open"),
	kernel.function("ovl_lookup"),
	kernel.function("ovl_mkdir"),
	kernel.function("ovl_symlink"),
	kernel.function("ovl_unlink"),
	kernel.function("ovl_rmdir"),
	kernel.function("ovl_rename"),
	kernel.function("ovl_link"),
	kernel.function("ovl_create"),
	kernel.function("ovl_mknod"),
	kernel.function("ovl_follow_link"),
	kernel.function("ovl_put_link"),
	kernel.function("ovl_readlink"),
	kernel.function("ovl_dir_open"),
	kernel.function("ovl_readdir"),
	kernel.function("ovl_dir_llseek"),
	kernel.function("ovl_dir_fsync"),
	kernel.function("ovl_dir_release"),
	kernel.function("ovl_dentry_release"),
	kernel.function("ovl_put_super"),
	kernel.function("ovl_statfs")
{
	tid = tid();
	i = rec_level[tid]++;
	stack_rem = u_register("rbp") & 0x1fff;
	stacks[tid, i] = stack_rem;
	delta = i > 0 ? stacks[tid, i - 1] - stack_rem : 0;
	printf("%4i %4i %-*s %s (%s/%i)\n", stack_rem, delta, i * 8, "", probefunc(), execname(), tid);
}

probe
	kernel.function("ovl_permission").return,
	kernel.function("ovl_getattr").return,
	kernel.function("ovl_dir_getattr").return,
	kernel.function("ovl_setattr").return,
	kernel.function("ovl_setxattr").return,
	kernel.function("ovl_listxattr").return,
	kernel.function("ovl_removexattr").return,
	kernel.function("ovl_dentry_open").return,
	kernel.function("ovl_lookup").return,
	kernel.function("ovl_mkdir").return,
	kernel.function("ovl_symlink").return,
	kernel.function("ovl_unlink").return,
	kernel.function("ovl_rmdir").return,
	kernel.function("ovl_rename").return,
	kernel.function("ovl_link").return,
	kernel.function("ovl_create").return,
	kernel.function("ovl_mknod").return,
	kernel.function("ovl_follow_link").return,
	kernel.function("ovl_put_link").return,
	kernel.function("ovl_readlink").return,
	kernel.function("ovl_dir_open").return,
	kernel.function("ovl_readdir").return,
	kernel.function("ovl_dir_llseek").return,
	kernel.function("ovl_dir_fsync").return,
	kernel.function("ovl_dir_release").return,
	kernel.function("ovl_dentry_release").return,
	kernel.function("ovl_put_super").return,
	kernel.function("ovl_statfs").return
{
	rec_level[tid()]--;
}


