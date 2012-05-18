Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946517Ab2ERXFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946505Ab2ERXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:02 -0400
Message-Id: <20120518211603.854880990@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kazuya Mio <k-mio@sx.jp.nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 48/54] wake up s_wait_unfrozen when ->freeze_fs fails
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuya Mio <k-mio@sx.jp.nec.com>

commit e1616300a20c80396109c1cf013ba9a36055a3da upstream.

dd slept infinitely when fsfeeze failed because of EIO.
To fix this problem, if ->freeze_fs fails, freeze_super() wakes up
the tasks waiting for the filesystem to become unfrozen.

When s_frozen isn't SB_UNFROZEN in __generic_file_aio_write(),
the function sleeps until FITHAW ioctl wakes up s_wait_unfrozen.

However, if ->freeze_fs fails, s_frozen is set to SB_UNFROZEN and then
freeze_super() returns an error number. In this case, FITHAW ioctl returns
EINVAL because s_frozen is already SB_UNFROZEN. There is no way to wake up
s_wait_unfrozen, so __generic_file_aio_write() sleeps infinitely.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1009,6 +1009,8 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
 		}


