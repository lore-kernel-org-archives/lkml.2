Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1FNUY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:24:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:13002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab1FNUYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,366,1304319600"; 
   d="scan'208";a="16208785"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 2/2] tty: n_gsm: improper skb_pull() use was leaking framed data
Date: Tue, 14 Jun 2011 13:23:29 -0700
Message-Id: <1308083009-9218-3-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/2] N_GSM bugfix patchset : June 14, 2011>
References: <[PATCH 0/2] N_GSM bugfix patchset : June 14, 2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gsm_dlci_data_output_framed() was doing:
memcpy(dp, skb_pull(dlci->skb, len), len);

The problem is skb_pull() returns the post-increment data ptr
so the first chunk of dlci->skb->data is leaked.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 16af6cf..20dd6b9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -875,7 +875,8 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 		*dp++ = last << 7 | first << 6 | 1;	/* EA */
 		len--;
 	}
-	memcpy(dp, skb_pull(dlci->skb, len), len);
+	memcpy(dp, dlci->skb->data, len);
+	skb_pull(dlci->skb, len);
 	__gsm_data_queue(dlci, msg);
 	if (last)
 		dlci->skb = NULL;
-- 
1.7.0.4

