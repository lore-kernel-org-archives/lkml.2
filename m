Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab0GAScn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:32:43 -0400
Received: from kroah.org ([198.145.64.141]:40746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103Ab0GASYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:11 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.594223863@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 116/149] iwlwifi: recalculate average tpt if not current
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 3d79b2a9eeaa066b35c49fbb17e3156a3c482c3e upstream.

We currently have this check as a BUG_ON, which is being hit by people.
Previously it was an error with a recalculation if not current, return that
code.

The BUG_ON was introduced by:
commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
Author: Guy Cohen <guy.cohen@intel.com>
Date:   Tue Sep 9 10:54:54 2008 +0800

    iwlwifi: Added support for 3 antennas

... the portion adding the BUG_ON is reverted since we are encountering the error
and BUG_ON was created with assumption that error is not encountered.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2193,9 +2193,12 @@ static void rs_rate_scale_perform(struct
 
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
-
-	BUG_ON(window->average_tpt != ((window->success_ratio *
-			tbl->expected_tpt[index] + 64) / 128));
+	if (window->average_tpt != ((window->success_ratio *
+			tbl->expected_tpt[index] + 64) / 128)) {
+		IWL_ERR(priv, "expected_tpt should have been calculated by now\n");
+		window->average_tpt = ((window->success_ratio *
+					tbl->expected_tpt[index] + 64) / 128);
+	}
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl &&


