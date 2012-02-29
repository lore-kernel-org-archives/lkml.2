Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2B2J32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:29:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab2B2J3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:29:25 -0500
Date: Wed, 29 Feb 2012 10:29:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] tpm_tis: fix tis_lock with respect to RCU
Message-ID: <alpine.LNX.2.00.1202291026520.31150@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup_tis() -> tpm_remove_hardware() -> syncrhonize_rcu() is being 
called in an atomic context (tis_lock spinlock held), which is not 
allowed. Convert tis_lock to mutex.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/char/tpm/tpm_tis.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index e1712a5..9a9300a 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -78,7 +78,7 @@ enum tis_defaults {
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
 static LIST_HEAD(tis_chips);
-static DEFINE_SPINLOCK(tis_lock);
+static DEFINE_MUTEX(tis_lock);
 
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int is_itpm(struct pnp_dev *dev)
@@ -691,9 +691,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	}
 
 	INIT_LIST_HEAD(&chip->vendor.list);
-	spin_lock(&tis_lock);
+	mutex_lock(&tis_lock);
 	list_add(&chip->vendor.list, &tis_chips);
-	spin_unlock(&tis_lock);
+	mutex_unlock(&tis_lock);
 
 
 	return 0;
@@ -857,7 +857,7 @@ static void __exit cleanup_tis(void)
 {
 	struct tpm_vendor_specific *i, *j;
 	struct tpm_chip *chip;
-	spin_lock(&tis_lock);
+	mutex_lock(&tis_lock);
 	list_for_each_entry_safe(i, j, &tis_chips, list) {
 		chip = to_tpm_chip(i);
 		tpm_remove_hardware(chip->dev);
@@ -873,7 +873,7 @@ static void __exit cleanup_tis(void)
 		iounmap(i->iobase);
 		list_del(&i->list);
 	}
-	spin_unlock(&tis_lock);
+	mutex_unlock(&tis_lock);
 #ifdef CONFIG_PNP
 	if (!force) {
 		pnp_unregister_driver(&tis_pnp_driver);
-- 
1.7.8.3

