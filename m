Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2BEPeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 10:34:03 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:40507 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752994Ab2BEPeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 10:34:00 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <528455107.21568@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <wenyunchuan@kylinos.com.cn>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2] eCryptfs: Write optimization for non-uptodate page
Date: Sun, 5 Feb 2012 23:33:51 +0800
Message-ID: <000801cce41b$927ae800$b770b800$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AczkG4QUrLTjb/xfRouJP/2gXi9NGg==
Content-Language: zh-cn
x-cr-hashedpuzzle: A45l Fy9+ K/xe MhZ8 PiMq PmGG T9rk U8n0 ZK42 bYmT cD4/ dgAA eEmH mBXi pvuC 1Jwk;5;ZQBjAHIAeQBwAHQAZgBzAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBmAHMAZABlAHYAZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAdAB5AGgAaQBjAGsAcwBAAGMAYQBuAG8AbgBpAGMAYQBsAC4AYwBvAG0AOwB3AGUAbgB5AHUAbgBjAGgAdQBhAG4AQABrAHkAbABpAG4AbwBzAC4AYwBvAG0ALgBjAG4A;Sosha1_v1;7;{57E91C25-BDEF-4EDB-AEBB-ACA13E95B278};bABpAHcAYQBuAGcAQABuAHUAZAB0AC4AZQBkAHUALgBjAG4A;Sun, 05 Feb 2012 15:33:31 GMT;WwBQAEEAVABDAEgAIAB2ADIAXQAgAGUAQwByAHkAcAB0AGYAcwA6ACAAVwByAGkAdABlACAAbwBwAHQAaQBtAGkAegBhAHQAaQBvAG4AIABmAG8AcgAgAG4AbwBuAC0AdQBwAHQAbwBkAGEAdABlACAAcABhAGcAZQA=
x-cr-puzzleid: {57E91C25-BDEF-4EDB-AEBB-ACA13E95B278}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_write_begin() grabs a page from page cache for writing. 
If the page does not contain valid data, or the data are older than 
the counterpart on the disk, eCryptfs will read out the corresponding data 
from the disk into the eCryptfs page cache, decrypt them, 
then perform writing. However, for current page, if the length of 
the data to be written into is equal to page size, that means the whole 
page of data will be overwritten, in which case, it does not matter whatever

the data were before, it is beneficial to perform writing directly.

This is especially useful while using eCryptfs in backup situation, user
copies file
out from eCryptfs folder, modifies, and copies the revised file back to
replace the original one. 

With this optimization, according to our test on a machine with IntelR Core
T 2 Duo processor, 
iozone 'write' operation on an existing file with write size being multiple
of page size will 
enjoy a steady 3x speedup.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>

--- 

Changes from v1:

The new version adds the code to handle short copy issue which may occure
in iov_iter_copy_from_user_atomic(). The idea is to let ecryptfs_write_end()
return zero,
in order to give iov_iter_fault_in_readable() a chance to handle the page
fault 
for the current iovec, then restart the copy operation.

 fs/ecryptfs/mmap.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 10ec695..c6f665e 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -350,7 +350,8 @@ static int ecryptfs_write_begin(struct file *file,
 			if (prev_page_end_size
 			    >= i_size_read(page->mapping->host)) {
 				zero_user(page, 0, PAGE_CACHE_SIZE);
-			} else {
+				SetPageUptodate(page);
+			} else if (len < PAGE_CACHE_SIZE) {
 				rc = ecryptfs_decrypt_page(page);
 				if (rc) {
 					printk(KERN_ERR "%s: Error
decrypting "
@@ -360,8 +361,8 @@ static int ecryptfs_write_begin(struct file *file,
 					ClearPageUptodate(page);
 					goto out;
 				}
+				SetPageUptodate(page);
 			}
-			SetPageUptodate(page);
 		}
 	}
 	/* If creating a page or more of holes, zero them out via truncate.
@@ -512,6 +513,13 @@ static int ecryptfs_write_end(struct file *file,
 		}
 		goto out;
 	}
+	if (!PageUptodate(page)) {
+		if (copied < PAGE_CACHE_SIZE) {
+			rc = 0;
+			goto out;
+		}
+		SetPageUptodate(page);
+	}
 	/* Fills in zeros if 'to' goes beyond inode size */
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {

