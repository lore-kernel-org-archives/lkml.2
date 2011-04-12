Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1DLO6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:58:25 -0400
Received: from kroah.org ([198.145.64.141]:57409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968Ab1DLOhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:49 2011
Message-Id: <20110412143549.515762436@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [015/105] eCryptfs: Unlock page in write_begin error path
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 50f198ae16ac66508d4b8d5a40967a8507ad19ee upstream.

Unlock the page in error path of ecryptfs_write_begin(). This may
happen, for example, if decryption fails while bring the page
up-to-date.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -374,6 +374,11 @@ static int ecryptfs_write_begin(struct f
 	    && (pos != 0))
 		zero_user(page, 0, PAGE_CACHE_SIZE);
 out:
+	if (unlikely(rc)) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+	}
 	return rc;
 }
 


