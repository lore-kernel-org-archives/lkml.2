Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab2HWVNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412Ab2HWVNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:13:43 -0400
Date: Thu, 23 Aug 2012 17:13:56 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ShuoX Liu <shuox.liu@intel.com>,
        mjg59@srcf.ucam.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC][PATCH 3/3] cpuidle: count double the exit latency
Message-ID: <20120823171356.32d3a807@cuia.bos.redhat.com>
In-Reply-To: <20120823171104.38574add@cuia.bos.redhat.com>
References: <20120823171104.38574add@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some workloads, for example web servers talking to database servers,
a task on one CPU will wake up a task on another CPU, wait for that
other CPU to handle the job, and get the result back.  Each of those
wakeups is likely to incur the c-state exit latency.

By only counting the exit latency once, even though the round trip
involves two c-state exits, we can end up going into too deep a
c-state for the workload.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 47b1150..ccdb348 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -378,10 +378,13 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	/*
 	 * We correct for the exit latency; we are assuming here that the
 	 * exit latency happens after the event that we're interested in.
+	 * Pessimistically assume that we got woken up by another CPU,
+	 * so we count its exit latency, too.
 	 */
-	if (measured_us > data->exit_us)
-		measured_us -= data->exit_us;
-
+	if (measured_us > 2 * data->exit_us)
+		measured_us -= 2 * data->exit_us;
+	else
+		measured_us = 0;
 
 	/* update our correction ratio */
 

