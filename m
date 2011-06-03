Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1FCTEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:04:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:38815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab1FCTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,315,1304319600"; 
   d="scan'208";a="13242380"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
Date: Fri,  3 Jun 2011 12:03:41 -0700
Message-Id: <1307127821-21665-6-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We saw a case where gsmld_output was called after the MUX
was shutdown. In this case gsm->tty was null so tty_write_room(NULL)
was called which resulted in an exception.

checked for gsm->tty == NULL in gsmld_output()

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 22c844d..2908199 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2168,6 +2168,8 @@ EXPORT_SYMBOL_GPL(gsm_alloc_mux);
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 {
+	if (!gsm->tty)
+		return -ENXIO;
 	if (tty_write_room(gsm->tty) < len) {
 		set_bit(TTY_DO_WRITE_WAKEUP, &gsm->tty->flags);
 		return -ENOSPC;
-- 
1.7.0.4

