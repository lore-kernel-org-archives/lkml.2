Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab1KAG3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:29:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49111 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1KAG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:29:16 -0400
Date: Tue, 1 Nov 2011 09:28:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Mark A. Grondona" <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] edac: sb_edac: add sanity check to silence static checker
Message-ID: <20111101062852.GA19020@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EAF91B4.0026,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume the the check on if (limit <= prv) prevents n_tads from
actually reaching MAX_TAD.  The problem with that is that it relies
on the hardware returning the right value and Smatch complains that
if it doesn't we could have a buffer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Feel free to ignore this patch if you want.  I don't have very stong
feelings about this either way.

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..ebf386c 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -970,6 +970,12 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			break;
 		prv = limit;
 	}
+	if (n_tads == MAX_TAD) {
+		sprintf(msg, "Could not discover the memory channel");
+		edac_mc_handle_ce_no_info(mci, msg);
+		return -EINVAL;
+	}
+
 	ch_way = TAD_CH(reg) + 1;
 	sck_way = TAD_SOCK(reg) + 1;
 	/*
