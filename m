Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab2HWVNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934474Ab2HWVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:13:45 -0400
Date: Thu, 23 Aug 2012 17:11:55 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ShuoX Liu <shuox.liu@intel.com>,
        mjg59@srcf.ucam.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC][PATCH 1/3] cpuidle: fix underflow in stddev calculation
Message-ID: <20120823171155.5d9dc482@cuia.bos.redhat.com>
In-Reply-To: <20120823171104.38574add@cuia.bos.redhat.com>
References: <20120823171104.38574add@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation to determine the standard deviation used unsigned
integers. Since some of the values are guaranteed to be below the
average, this would always lead to large unsigned 32 bit numbers,
which would then be multiplied and added to a 64 bit integer,
potentially leading to a totally unpredictable result.

I am not sure if/why this code has ever worked.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 5b1f2c3..f4fe5c3 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -212,9 +212,10 @@ static void detect_repeating_patterns(struct menu_device *data)
 	if (avg > data->expected_us)
 		return;
 
-	for (i = 0; i < INTERVALS; i++)
-		stddev += (data->intervals[i] - avg) *
-			  (data->intervals[i] - avg);
+	for (i = 0; i < INTERVALS; i++) {
+		int diff = (int)data->intervals[i] - avg;
+		stddev += diff * diff;
+	}
 
 	stddev = stddev / INTERVALS;
 
