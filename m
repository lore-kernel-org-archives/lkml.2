Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439Ab2FVGbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:31:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:37538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761383Ab2FVGai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:30:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183583152"
Subject: [set5 PATCH 3/6] scsi: queue async scan work to an async_schedule
 domain
To: linux-scsi@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>
Date: Thu, 21 Jun 2012 23:47:12 -0700
Message-ID: <20120622064712.21538.21140.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
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
index 2e5fe58..a381fa2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1842,14 +1842,13 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
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
@@ -1858,7 +1857,6 @@ static int do_scan_async(void *_data)
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct task_struct *p;
 	struct async_scan_data *data;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1873,9 +1871,11 @@ void scsi_scan_host(struct Scsi_Host *shost)
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

