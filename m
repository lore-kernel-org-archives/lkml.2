Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1HFAJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:09:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab1HFAJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:54 2011
Message-Id: <20110806000254.209867732@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alasdair G Kergon <agk@redhat.com>
Subject: [53/55] dm: fix idr leak on module removal
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -36,6 +36,8 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+static DEFINE_IDR(_minor_idr);
+
 static DEFINE_SPINLOCK(_minor_lock);
 /*
  * For bio-based dm.
@@ -315,6 +317,12 @@ static void __exit dm_exit(void)
 
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
@@ -1663,8 +1671,6 @@ static int dm_any_congested(void *conges
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_IDR(_minor_idr);
-
 static void free_minor(int minor)
 {
 	spin_lock(&_minor_lock);


