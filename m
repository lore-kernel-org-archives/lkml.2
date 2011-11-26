Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab1KZFZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 00:25:16 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:55469 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750806Ab1KZFZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 00:25:13 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Nov 2011 00:25:12 EST
Date: Sat, 26 Nov 2011 13:04:36 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: [PATCH]eCryptfs: quota check ignored in the context of kernel thr
 ead
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, ecryptfs@vger.kernel.org
Message-Id: <11112613043689e4ebac922bdda45ca181757479edcf@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 222.247.142.1
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <e4c8ddeb78f3d5934075682ae7d5c83c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAQ5PV18021875

Hi there,
   The latest eCryptfs changes the write path to perform the encryption in ecryptfs_writepage, which minimizes the number of encryptions, however, if the ecryptfs_writepage is invoked in the context of page cache write back kernel thread, to write out the dirty pages to the lower page cache, the quota check by the lower file system gotta be ignored since the kernel thread has the CAP_SYS_CAPABILITY. To validate this, just let a user application open a file, write much data into it, then sleep for several miniutes before close it, those data gotta definitely be safely written into the disk in despite of the user quota limit. The patch below try to fix this by simply temporarily removing the capability from the kernel thread before invoking ecryptfs_write_lower, thereafter, reassign it.

  Fixme: It seems those commented codes in the patch (prepare_creds(), ..., commit_creds()) do the thing in a more official way, but they perform too much validity checks which are not needed in our case. Only if the simple cap_lower/cap_raise call will trigger some race condtions, otherwise I think it should be ok?         

Cheers,
Li Wang

signed-off-by: Li Wang <liwang@nudt.edu.cn>
               Yong Peng <pengyong@kylinos.com.cn>

---
--- fs/ecryptfs/crypto.c.orig 2011-11-26 20:21:08.109304786 +0800
+++ fs/ecryptfs/crypto.c 2011-11-26 20:20:09.651315978 +0800
@@ -506,8 +506,33 @@ int ecryptfs_encrypt_page(struct page *p
        * (PAGE_CACHE_SIZE
           / crypt_stat->extent_size))
       + extent_offset), crypt_stat);
+  /*
+    * Temporarily remove the CAP_SYS_RESOURCE capability from the
+    * write back kernel thread to let it undergo quota check by
+    * the lower file system
+    */
+  if (current->flags & PF_KTHREAD) {
+   cap_lower(((struct cred *)current->cred)->cap_effective, CAP_SYS_RESOURCE);
+   /*
+     * struct cred *cred;
+     * cred = prepare_creds();
+     * if (unlikely(!cred)) {
+     *  rc = -ENOMEM;
+     * goto out;
+     * }
+     * cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
+     * rc = commit_creds(cred);
+     * if (rc)
+     *  goto out;
+     */  
+  }
   rc = ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
        offset, crypt_stat->extent_size);
+  /*
+    * Reassign the CAP_SYS_RESOURCE capability
+    */
+  if (current->flags & PF_KTHREAD)
+   cap_raise(((struct cred *)current->cred)->cap_effective, CAP_SYS_RESOURCE);
   if (rc < 0) {
    ecryptfs_printk(KERN_ERR, "Error attempting "
      "to write lower page; rc = [%d]"
  
 ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
