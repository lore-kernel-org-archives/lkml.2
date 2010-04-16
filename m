Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab0DPWk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:40:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40473 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab0DPWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:40:26 -0400
From: Vernon Mauery <vernux@us.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Vernon Mauery <vernux@us.ibm.com>
Subject: [PATCH] Always call i7core_[ur]dimm_check_mc_ecc_err
Date: Fri, 16 Apr 2010 15:40:19 -0700
Message-Id: <1271457619-4585-1-git-send-email-vernux@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an error in function i7core_check_error

In commit d8922d1ba082832de2a215da7233126a7ff45637 which
converts the driver to use double buffering, there is a
change in the logic.  Before, if mce_count was zero, it
skipped over a couple of statements and finished out with
a call to the *check_mc_ecc_err function.  The current
code checks to see if mce_count is 0 and then exits.

This change reverts the behavior back to the original
where if there are no errors to report, we skip to the
end and call the *check_mc_ecc_err function.

This fix allows the driver to work again on my Nehalem
based blades again.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
---
 drivers/edac/i7core_edac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index e944b63..339bf0c 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1634,7 +1634,7 @@ static void i7core_check_error(struct mem_ctl_info *mci)
 	count = (pvt->mce_out + MCE_LOG_LEN - pvt->mce_in)
 		% MCE_LOG_LEN;
 	if (!count)
-		return;
+		goto check_ce_error;
 
 	m = pvt->mce_outentry;
 	if (pvt->mce_in + count > MCE_LOG_LEN) {
@@ -1667,6 +1667,7 @@ static void i7core_check_error(struct mem_ctl_info *mci)
 	/*
 	 * Now, let's increment CE error counts
 	 */
+check_ce_error:
 	if (!pvt->is_registered)
 		i7core_udimm_check_mc_ecc_err(mci);
 	else
-- 
1.7.0.4

