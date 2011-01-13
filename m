Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1AMBGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:06:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39129 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1AMBGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hrVcfj8aiYrqU5sqouEZVLQfWyukAxh6oFW5ScC3VviHALw3qfFHdZX5V/PJi7lKjX
         vxVH0BwK3ZgZHUIudXX3mdlxcavUwhhu1c7ZDVciqUNjNmEAImJTfkwWE49/fKjSq6sx
         TtNS1b2C76SZK9XbMcyIy7OBE9KdGYKJ2JzEA=
MIME-Version: 1.0
In-Reply-To: <29345.1294861630@jrobl>
References: <29345.1294861630@jrobl>
Date: Thu, 13 Jan 2011 12:06:44 +1100
Message-ID: <AANLkTinLDN3LGahTqRrLvNShAyMSs_Q_Gjhw=oCGAsby@mail.gmail.com>
Subject: Re: vfs-scale, chroot
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 6:47 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Hello Nick,
>
> I've got a crash around d_lock.
>
> # mount -t nfs host:/dir /nfs
> # chroot /nfs
>
> BUG: spinlock recursion on CPU#1, chroot/2524
>  lock: ffff88001d106880, .magic: dead4ead, .owner: chroot/2524, .owner_cpu: 1
> Call Trace:
>  [<ffffffff8128ca52>] ? spin_bug+0xa2/0xf0
>  [<ffffffff8128cd53>] ? do_raw_spin_lock+0x193/0x1b0
>  [<ffffffff814eaa5e>] ? _raw_spin_lock_nested+0x4e/0x60
>  [<ffffffff81137aef>] ? nameidata_dentry_drop_rcu+0xcf/0x1b0
>  [<ffffffff814eaab3>] ? _raw_spin_lock+0x43/0x50
>  [<ffffffff81137aef>] ? nameidata_dentry_drop_rcu+0xcf/0x1b0
>  [<ffffffff81137c1b>] ? d_revalidate+0x4b/0x70
>  [<ffffffff81139a75>] ? link_path_walk+0x655/0x1210
>  [<ffffffff81138702>] ? path_init_rcu+0x1c2/0x370
>  [<ffffffff811387e5>] ? path_init_rcu+0x2a5/0x370
>  [<ffffffff81138702>] ? path_init_rcu+0x1c2/0x370
>  [<ffffffff811059b3>] ? might_fault+0x53/0xb0
>  [<ffffffff8113a9fe>] ? do_path_lookup+0x8e/0x1d0
>  [<ffffffff8113b936>] ? user_path_at+0xa6/0xe0
>  [<ffffffff8114c167>] ? vfsmount_lock_local_unlock+0x77/0x90
>  [<ffffffff814ebab9>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff81090b15>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<ffffffff8112841e>] ? sys_chdir+0x2e/0x90
>  [<ffffffff8100bfd2>] ? system_call_fastpath+0x16/0x1b
>
> It looks like nameidata_dentry_drop_rcu() is trying spin_lock() twice
> for the same dentry when parent == dentry.
>
> - NFS ->d_revalidate() returns -ECHILD for LOOKUP_RCU
> - VFS d_revalidate() will try ->d_revalidate() again after dropping
>  LOOKUP_RCU by nameidata_dentry_drop_rcu().
> - nameidata_dentry_drop_rcu() calls
>        spin_lock(&parent->d_lock);
>        spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> - it may happen on all fs which specifies FS_REVAL_DOT
>
> If we have a function like below, it may be useful.
> But are there so many cases like this problem?
> If it is not so many, then the fix will be adding several
> "if (!IS_ROOT(dentry)" into nameidata_dentry_drop_rcu(), I think.

Hey, thanks for the report and the excellent debugging work! I agree
with your analysis. I'll prepare a patch for it shortly.

Thanks,
Nick
