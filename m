Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536Ab2EOCeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:34:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53528 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893Ab2EOCSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 147/179] dm: fix idr leak on module removal
Date: Mon, 14 May 2012 22:14:03 -0400
Message-ID: <1337048075-6132-148-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d15b774c2920d55e3d58275c97fbe3adc3afde38 upstream.

Destroy _minor_idr when unloading the core dm module.  (Found by kmemleak.)

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/dm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c955f7f..6c65d49 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -36,6 +36,8 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+static DEFINE_IDR(_minor_idr);
+
 static DEFINE_SPINLOCK(_minor_lock);
 /*
  * For bio-based dm.
@@ -324,6 +326,12 @@ static void __exit dm_exit(void)
 
 	while (i--)
 		_exits[i]();
+
+	/*
+	 * Should be empty by this point.
+	 */
+	idr_remove_all(&_minor_idr);
+	idr_destroy(&_minor_idr);
 }
 
 /*
@@ -1772,8 +1780,6 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_IDR(_minor_idr);
-
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);
-- 
1.7.9.6

