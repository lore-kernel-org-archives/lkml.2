Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2IJLtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:49:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35822 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab2IJLs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:48:59 -0400
Date: Mon, 10 Sep 2012 19:49:20 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: About function __create_file  in debugfs
References: <201209081741013286843@gmail.com>, 
	<20120908152533.GB1838@kroah.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201209101949173901481@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8ABnKIG017607

On 2012-09-08 23:25 gregkh <gregkh@linuxfoundation.org> Wrote:
>On Sat, Sep 08, 2012 at 05:41:05PM +0800, Jianpeng Ma wrote:
>> Hi:
>> 	At present,i used blktrace to trace block io.But i always met error, the message like:
>> >BLKTRACESETUP(2) /dev/sdc failed: 2/No such file or directory
>> >Thread 0 failed open /sys/kernel/debug/block/(null)/trace0: 2/No such file or directory
>> >Thread 2 failed open /sys/kernel/debug/block/(null)/trace2: 2/No such file or directory
>> >Thread 3 failed open /sys/kernel/debug/block/(null)/trace3: 2/No such file or directory
>> 
>> >Thread 1 failed open /sys/kernel/debug/block/(null)/trace1: 2/No such file or directory
>> >FAILED to start thread on CPU 0: 1/Operation not permitted
>> >FAILED to start thread on CPU 1: 1/Operation not permitted
>> >FAILED to start thread on CPU 2: 1/Operation not permitted
>> >FAILED to start thread on CPU 3: 1/Operation not permitted
>> 
>> But those isn't important. I add some message in kernel and found the reason is inode already existed.
>> But the function __create_file dosen't return correctly errno.So blktrace tool can't print correctly message.
>> I think func __create_file should return correctly message(ERR_PTR(error)) not NULL.
>
>Patches are always welcome :)
>
>greg k-h

Thanks, the patch is:
Func debugfs_create_symlink/debugfs_create_file/debugfs_create_dir,
it only return NULL when error counted. We should correctly error info
instead of.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/debugfs/inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..1e94350 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -302,8 +302,10 @@ struct dentry *__create_file(const char *name, umode_t mode,
 
 	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
 			      &debugfs_mount_count);
-	if (error)
+	if (error) {
+		dentry = ERR_PTR(error);
 		goto exit;
+	}
 
 	/* If the parent is not specified, we create it in the root.
 	 * We need the root dentry to do this, which is in the super 
@@ -337,7 +339,7 @@ struct dentry *__create_file(const char *name, umode_t mode,
 	mutex_unlock(&parent->d_inode->i_mutex);
 
 	if (error) {
-		dentry = NULL;
+		dentry = ERR_PTR(error);
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
 exit:
@@ -442,10 +444,10 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 
 	link = kstrdup(target, GFP_KERNEL);
 	if (!link)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	result = __create_file(name, S_IFLNK | S_IRWXUGO, parent, link, NULL);
-	if (!result)
+	if (IS_ERR_OR_NULL(result))
 		kfree(link);
 	return result;
 }
-- 
1.7.9.5


But i searched kernel-code and found at-least 100 places used those code.
How about those code? Am i correct those or not?
Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
