Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1IFLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 07:43:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56102 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1IFLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:43:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: FUSE kmemleak report
References: <20110905223734.GB26980@sucs.org>
	<CAHkRjk4QXbzzS6_Ks8W_QF14ijQdrXUEN82ifnm8ecxenqYiKA@mail.gmail.com>
Date: Tue, 06 Sep 2011 13:43:27 +0200
In-Reply-To: <CAHkRjk4QXbzzS6_Ks8W_QF14ijQdrXUEN82ifnm8ecxenqYiKA@mail.gmail.com>
	(Catalin Marinas's message of "Tue, 6 Sep 2011 11:35:55 +0100")
Message-ID: <874o0pkiao.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On 5 September 2011 23:37, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> kmemleak is reporting that 32 bytes are being leaked by FUSE:
>>
>> unreferenced object 0xe373b270 (size 32):
>>  comm "fusermount", pid 1207, jiffies 4294707026 (age 2675.187s)
>>  hex dump (first 32 bytes):
>>    01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>  backtrace:
>>    [<b05517d7>] kmemleak_alloc+0x27/0x50
>>    [<b0196435>] kmem_cache_alloc+0xc5/0x180
>>    [<b02455be>] fuse_alloc_forget+0x1e/0x20
>>    [<b0245670>] fuse_alloc_inode+0xb0/0xd0
>>    [<b01b1a8c>] alloc_inode+0x1c/0x80
>>    [<b01b290f>] iget5_locked+0x8f/0x1a0
>>    [<b0246022>] fuse_iget+0x72/0x1a0
>>    [<b02461da>] fuse_get_root_inode+0x8a/0x90
>>    [<b02465cf>] fuse_fill_super+0x3ef/0x590
>>    [<b019e56f>] mount_nodev+0x3f/0x90
>>    [<b0244e95>] fuse_mount+0x15/0x20
>>    [<b019d1bc>] mount_fs+0x1c/0xc0
>>    [<b01b5811>] vfs_kern_mount+0x41/0x90
>>    [<b01b5af9>] do_kern_mount+0x39/0xd0
>>    [<b01b7585>] do_mount+0x2e5/0x660
>>    [<b01b7966>] sys_mount+0x66/0xa0
>>
>> This leak report is consistent and happens once per boot on
>> 3.1.0-rc5-dirty.
>
> IIUC, kmemleak reports the fuse_forget_link that corresponds to the
> root inode (allocated via fuse_fill_super). The root inode is later
> freed (did the mount failed?) but not the forget link. I'm not
> familiar with this code, so note exactly sure where the forget link
> should have been freed.

Sitsofe, thanks for the report.

Could you please try the patch below?

Thanks,
Miklos


diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 168a80f..5cb8614 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -258,10 +258,14 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
 	forget->forget_one.nlookup = nlookup;
 
 	spin_lock(&fc->lock);
-	fc->forget_list_tail->next = forget;
-	fc->forget_list_tail = forget;
-	wake_up(&fc->waitq);
-	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+	if (fc->connected) {
+		fc->forget_list_tail->next = forget;
+		fc->forget_list_tail = forget;
+		wake_up(&fc->waitq);
+		kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+	} else {
+		kfree(forget);
+	}
 	spin_unlock(&fc->lock);
 }
 
