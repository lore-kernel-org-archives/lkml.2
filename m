Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab2AZFEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 00:04:44 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:37379 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750726Ab2AZFEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 00:04:42 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <527553462.07149@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "'Tyler Hicks'" <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
In-Reply-To: <527531938.27851@eyou.net>
Subject: [PATCH v2] eCryptfs: write optimization
Date: Thu, 26 Jan 2012 13:04:34 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7600.16807
Thread-Index: Aczbs/0rESicKC59TRG7/Z/LahKNIAAMznwg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  The new version adds the code to handle short copy issue which may occure
in iov_iter_copy_from_user_atomic(). The idea is to let ecryptfs_write_end() return zero,
therefore, give iov_iter_fault_in_readable() a chance to handle the page fault 
for the current iovec, then restart the copy operation.

Cheers,
Li Wang

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
               Yunchuan Wen <wenyunchuan@kylinos.com.cn>

---
 
fs/ecryptfs/mmap.c |   12 ++++++++++--
1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6a44148..b3fa499 100644
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


