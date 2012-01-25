Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2AYPYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:24:33 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:48954 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752975Ab2AYPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:24:32 -0500
Date: Wed, 25 Jan 2012 23:10:58 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: [PATCH] eCryptfs: write optimization
To: "Tyler Hicks" <tyhicks@canonical.com>
Cc: "ecryptfs" <ecryptfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-Id: <120125231058365612da29f3ab1c3bb2d794f83e9305@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.88.165.8
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <cc5a657086e6fb9837c13116a23d2ded>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0PFOdWF004689

Hi,
  ecryptfs_write_begin() grabs a page from page cache for writing. 
If the page does not contain valid data, or the data are older than 
the counterpart on the disk, eCryptfs will read out the corresponding data 
from the disk into the eCryptfs page cache, decrypt them, 
then perform writting. However, for current page, if the length of 
the data to be written into is equal to page size, that means the whole 
page of data will be overwritten, in which case, it does not matter whatever 
the data were before, it is beneficial to perform writting directly.

This is useful while using eCryptfs in backup situation, user copies file
out from eCryptfs folder, modifies, and copies the revised file back to
replace the original one. 

With this optimization, according to our test, iozone 'write' operation on an existing 
file with write size being multiple of page size will enjoy a steady 3x speedup.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
		Yunchuan Wen <wenyunchuan@kylinos.com.cn>

---

 fs/ecryptfs/mmap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6a44148..9724ef2 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -346,7 +346,8 @@ static int ecryptfs_write_begin(struct file *file,
 			if (prev_page_end_size
 			    >= i_size_read(page->mapping->host)) {
 				zero_user(page, 0, PAGE_CACHE_SIZE);
-			} else {
+				SetPageUptodate(page);
+			} else if (len < PAGE_CACHE_SIZE) {
 				rc = ecryptfs_decrypt_page(page);
 				if (rc) {
 					printk(KERN_ERR "%s: Error decrypting "
@@ -356,8 +357,8 @@ static int ecryptfs_write_begin(struct file *file,
 					ClearPageUptodate(page);
 					goto out;
 				}
+				SetPageUptodate(page);
 			}
-			SetPageUptodate(page);
 		}
 	}
 	/* If creating a page or more of holes, zero them out via truncate.  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
