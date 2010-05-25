Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab0EYWRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:17:18 -0400
Received: from smtp123.mail.ukl.yahoo.com ([77.238.184.54]:32724 "HELO
	smtp123.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759063Ab0EYWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:17:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=wWQZra/1zLji3LGcKEsDQjWibgza1YV74VUL9rkAmjslczHbG3pOd88kWY+nHyHsJUUuYGp/BVI5E4wul+ZBEJ2FBuk+3btplodRsOkOjupQpkpJaKqZo4miaaHYx0s8zgt2eDlAHhVpluY6/P7FIU9bLLJrgyXiaKyesvKfhMo=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: K19.TbsVM1l7HsRJf.e4chHw_y0HrKi8WO52I1GqMsgqWNQluwuutMuZ_hAwt7KIcYJl_nLeddE1OmB1jZhr3WbBnvNIAwayYC_0Dyn.hQ_MTqfFD6JzI8HL4LKfGzs4hG9Fr1dzBjZoRGt51BD_BQvN4eAWTYx4np.9DAY_RAkt807.hwccaGSHGUy.Fsd0ERAK7Ae6jkS5Q49et6guPHZ6VRRZ8TT9FMYMscNdTitXJyJeh_.M2R09sIMXzqoYmAHINptSHGTTpTbOE7LfLRZEB3Hox8Bf
X-Yahoo-Newman-Property: ymail-3
From: Albert Herranz <albert_herranz@yahoo.es>
To: npiggin@suse.de, jayakumar.lkml@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Cc: Albert Herranz <albert_herranz@yahoo.es>
Subject: [RFT PATCH 2/2] fb_defio: redo fix for non-dirty ptes
Date: Wed, 26 May 2010 00:17:00 +0200
Message-Id: <1274825820-10246-2-git-send-email-albert_herranz@yahoo.es>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274825820-10246-1-git-send-email-albert_herranz@yahoo.es>
References: <1274825820-10246-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed by Nick Piggin, ->page_mkwrite provides a way to keep a page
locked until the associated PTE is marked dirty.

Re-implement the fix by using this mechanism.

LKML-Reference: <20100525160149.GE20853@laptop>
Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
 drivers/video/fb_defio.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 0e4dcdb..a3e8cc7 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -100,6 +100,16 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
 
+	/*
+	 * We want the page to remain locked from ->page_mkwrite until
+	 * the PTE is marked dirty to avoid page_mkclean() being called
+	 * before the PTE is updated, which would leave the page ignored
+	 * by defio.
+	 * Do this by locking the page here and informing the caller
+	 * about it with VM_FAULT_LOCKED.
+	 */
+	lock_page(page);
+
 	/* we loop through the pagelist before adding in order
 	to keep the pagelist sorted */
 	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
@@ -121,7 +131,7 @@ page_already_added:
 
 	/* come back after delay to process the deferred IO */
 	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
-	return 0;
+	return VM_FAULT_LOCKED;
 }
 
 static const struct vm_operations_struct fb_deferred_io_vm_ops = {
-- 
1.7.0.4

