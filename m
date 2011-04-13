Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1DMPzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:18 -0400
Received: from kroah.org ([198.145.64.141]:54224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab1DMPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:44 2011
Message-Id: <20110413155144.023501698@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [10/74] eCryptfs: Unlock page in write_begin error path
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -372,6 +372,11 @@ static int ecryptfs_write_begin(struct f
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
 


