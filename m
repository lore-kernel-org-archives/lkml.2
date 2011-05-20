Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab1ETAV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:21:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60741 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933276Ab1ETALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:10 -0400
X-Sasl-enc: tje/PPd5QzN1aDkUuePyGdqSFSmBxdM3863B9oOETOtK 1305850269
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/44] efivars: handle errors from register_efivars()
Date: Thu, 19 May 2011 17:10:21 -0700
Message-Id: <1305850262-9575-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

We should unwind and return an error if register_efivars() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff2fe40..5d1ec68 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -803,6 +803,8 @@ efivars_init(void)
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
+	if (error)
+		goto err_put;
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -810,10 +812,15 @@ efivars_init(void)
 		printk(KERN_ERR
 		       "efivars: Sysfs attribute export failed with error %d.\n",
 		       error);
-		unregister_efivars(&__efivars);
-		kobject_put(efi_kobj);
+		goto err_unregister;
 	}
 
+	return 0;
+
+err_unregister:
+	unregister_efivars(&__efivars);
+err_put:
+	kobject_put(efi_kobj);
 	return error;
 }
 
-- 
1.7.4.2

