Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2AYPJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:09:12 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:59431 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751274Ab2AYPJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:09:10 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <527503333.04197@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "Tyler Hicks" <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: write optimization
Date: Wed, 25 Jan 2012 23:08:58 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: Aczbc0M2E3m8UKvGRPe2U2OeTB49wQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7600.16807
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  ecryptfs_write_begin() grabs a page from page cache for writing. 
If the page does not contain valid data, or the data are older than 
the counterpart on the disk, eCryptfs will read out the corresponding data 
from the disk into the eCryptfs page cache, decrypt them, 
then perform writing. However, for current page, if the length of 
the data to be written into is equal to page size, that means the whole 
page of data will be overwritten, in which case, it does not matter whatever 
the data were before, it is beneficial to perform writing directly.

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
 	/* If creating a page or more of holes, zero them out via truncate.  

