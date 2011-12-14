Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1LNN0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:26:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:11213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1LNN0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:26:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87187059"
Subject: Re: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
From: Lin Ming <ming.m.lin@intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
In-Reply-To: <4EE8813B.1090802@mvista.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
	 <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
	 <4EE8813B.1090802@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Dec 2011 21:24:31 +0800
Message-ID: <1323869071.2656.7.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 18:58 +0800, Sergei Shtylyov wrote:
> Hello.
> 
> On 14-12-2011 7:17, Lin Ming wrote:
> 
> > Commit af8db15 disabled device's runtime PM during shutdown.
> 
>     Please also specify that commit's summary in parens.

OK. Here it is.

>From 7e3dcebe235d005126c03a3976bca859691110bc Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Wed, 14 Dec 2011 10:14:21 +0800
Subject: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown

Commit af8db15(PM / driver core: disable device's runtime PM during
shutdown) makes pm_runtime_suspended(dev) always return false.
So sd's runtime status can't be checked with pm_runtime_suspended(dev)
any more.

Fix it by checking runtime status with pm_runtime_status_suspended(dev).

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7b3f807..284b087 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2742,7 +2742,12 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
-	if (pm_runtime_suspended(dev))
+	/*
+	 * Check runtime status with pm_runtime_status_suspended(dev)
+	 * instead of pm_runtime_suspended(dev),
+	 * because device_shutdown() has disabled the device's runtime PM.
+	 */
+	if (pm_runtime_status_suspended(dev))
 		goto exit;
 
 	if (sdkp->WCE) {
-- 
1.7.2.5



