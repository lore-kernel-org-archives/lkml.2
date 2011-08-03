Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1HCXfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:35:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab1HCXai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:54 2011
Message-Id: <20110803221254.376940267@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:02:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alasdair G Kergon <agk@redhat.com>
Subject: [102/102] dm: fix idr leak on module removal
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alasdair G Kergon <agk@redhat.com>

commit d15b774c2920d55e3d58275c97fbe3adc3afde38 upstream.

Destroy _minor_idr when unloading the core dm module.  (Found by kmemleak.)

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -37,6 +37,8 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+static DEFINE_IDR(_minor_idr);
+
 static DEFINE_SPINLOCK(_minor_lock);
 /*
  * For bio-based dm.
@@ -313,6 +315,12 @@ static void __exit dm_exit(void)
 
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
@@ -1705,8 +1713,6 @@ static int dm_any_congested(void *conges
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_IDR(_minor_idr);
-
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);


