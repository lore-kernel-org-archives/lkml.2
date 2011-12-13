Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1LMOWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:22:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:40057 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1LMOWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:22:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95637943"
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
In-Reply-To: <CAF1ivSbRejpSEVfHAhOUxaqAedkCQVHWOgsJGFLM2yt2QaxtuQ@mail.gmail.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
	 <1323048028-10421-6-git-send-email-ming.m.lin@intel.com>
	 <CAF1ivSbRejpSEVfHAhOUxaqAedkCQVHWOgsJGFLM2yt2QaxtuQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 13 Dec 2011 22:20:40 +0800
Message-ID: <1323786040.3769.24.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 21:56 +0800, Lin Ming wrote:
> +
> +static int ata_port_resume(struct device *dev)
> +{
> +       struct ata_port *ap = to_ata_port(dev);
> +       int rc;
> +
> +       rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
> +               ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
> +       return rc;
> +}

I just realized that the ata port runtime PM status need to be updated
after system resume.

I tried below patch.
Unfortunately, it causes a problem that sd can't resume correctly.

During system resume, ata port is resumed first and then sd resumed.

When ata port resumed, device_resume(...) calls pm_runtime_put_sync(..),
which causes ata port to be runtime suspended immediately.

So sd resume fails because it requires ata port to be active to handle
start device command.

This seems a PM core's bug.

device_resume(...) should not runtime suspend the parent device, because
its children have not resumed yet.

Alan, 

What do you think?

---
 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 15a3d4d..8996758 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
 	return ata_port_suspend_common(dev);
 }
 
-static int ata_port_resume(struct device *dev)
+static int ata_port_resume_common(struct device *dev)
 {
 	struct ata_port *ap = to_ata_port(dev);
 	int rc;
@@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
+}
+
 static int ata_port_runtime_idle(struct device *dev)
 {
 	return pm_runtime_suspend(dev);
@@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.resume = ata_port_resume,
 
 	.runtime_suspend = ata_port_suspend_common,
-	.runtime_resume = ata_port_resume,
+	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
 






