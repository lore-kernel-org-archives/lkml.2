Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2E3SFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:05:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:47691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab2E3SFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:05:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158802640"
Subject: [PATCH v2 3/4] scsi: queue async scan work to an async_schedule
 domain
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        mroos@linux.ee, Arjan van de Ven <arjan@linux.intel.com>,
        James Bottomley <JBottomley@parallels.com>
Date: Wed, 30 May 2012 11:21:40 -0700
Message-ID: <20120530182140.23574.4611.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation to enable async_synchronize_full() to be used as a
replacement for scsi_complete_async_scans(), i.e. to stop leaking scsi
internal details where they are not needed.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5e00e09..fb42aa0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1847,14 +1847,13 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
 	}
 }
 
-static int do_scan_async(void *_data)
+static void do_scan_async(void *_data, async_cookie_t c)
 {
 	struct async_scan_data *data = _data;
 	struct Scsi_Host *shost = data->shost;
 
 	do_scsi_scan_host(shost);
 	scsi_finish_async_scan(data);
-	return 0;
 }
 
 /**
@@ -1863,7 +1862,6 @@ static int do_scan_async(void *_data)
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct task_struct *p;
 	struct async_scan_data *data;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1878,9 +1876,11 @@ void scsi_scan_host(struct Scsi_Host *shost)
 		return;
 	}
 
-	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
-	if (IS_ERR(p))
-		do_scan_async(data);
+	/* register with the async subsystem so wait_for_device_probe()
+	 * will flush this work
+	 */
+	async_schedule(do_scan_async, data);
+
 	/* scsi_autopm_put_host(shost) is called in scsi_finish_async_scan() */
 }
 EXPORT_SYMBOL(scsi_scan_host);

