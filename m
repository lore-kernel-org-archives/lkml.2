Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab1BPAvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:36 -0500
Received: from kroah.org ([198.145.64.141]:46159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1BPAv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.817690640@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 148/176] nilfs2: fix crash after one superblock became unavailable
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 0ca7a5b9ac5d301845dd6382ff25a699b6263a81 upstream.

Fixes the following kernel oops in nilfs_setup_super() which could
arise if one of two super-blocks is unavailable.

> BUG: unable to handle kernel NULL pointer dereference at   (null)
> Pid: 3529, comm: mount.nilfs2 Not tainted 2.6.37 #1 /
> EIP: 0060:[<c03196bc>] EFLAGS: 00010202 CPU: 3
> EIP is at memcpy+0xc/0x1b
> Call Trace:
>  [<f953720e>] ? nilfs_setup_super+0x6c/0xa5 [nilfs2]
>  [<f95369e9>] ? nilfs_get_root_dentry+0x81/0xcb [nilfs2]
>  [<f9537a08>] ? nilfs_mount+0x4f9/0x62c [nilfs2]
>  [<c02745cf>] ? kstrdup+0x36/0x3f
>  [<f953750f>] ? nilfs_mount+0x0/0x62c [nilfs2]
>  [<c0293940>] ? vfs_kern_mount+0x4d/0x12c
>  [<c02a5100>] ? get_fs_type+0x76/0x8f
>  [<c0293a68>] ? do_kern_mount+0x33/0xbf
>  [<c02a784a>] ? do_mount+0x2ed/0x714
>  [<c02a6171>] ? copy_mount_options+0x28/0xfc
>  [<c02a7ce3>] ? sys_mount+0x72/0xaf
>  [<c0473085>] ? syscall_call+0x7/0xb

Reported-by: Wakko Warner <wakko@animx.eu.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Wakko Warner <wakko@animx.eu.org>
LKML-Reference: <20110121024918.GA29598@animx.eu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -733,7 +733,8 @@ static int nilfs_setup_super(struct nilf
 		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
 	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
 	/* synchronize sbp[1] with sbp[0] */
-	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+	if (sbp[1])
+		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
 }
 


