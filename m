Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1HXWcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:32:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33405 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1HXWby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:31:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        Jan Beulich <jbeulich@novell.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] xen/pci: make bus notifier handler return sane values
Date: Wed, 24 Aug 2011 18:31:36 -0400
Message-Id: <1314225096-4861-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E557BD4.00FE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@novell.com>

Notifier functions are expected to return NOTIFY_* codes, not -E...
ones. In particular, since the respective hypercalls failing is not
fatal to the operation of the Dom0 kernel, it must be avoided to
return negative values here as those would make it appear as if
NOTIFY_STOP_MASK wa set, suppressing further notification calls to
other interested parties (which is also why we don't want to use
notifier_from_errno() here).

While at it, also notify the user of a failed hypercall.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
[v1: Added dev_err and the disable MSI/MSI-X call]
[v2: Removed the disable MSI/MSI-X call]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/pci.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index cef4baf..02c402b 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -96,13 +96,16 @@ static int xen_pci_notifier(struct notifier_block *nb,
 		r = xen_remove_device(dev);
 		break;
 	default:
-		break;
+		return NOTIFY_DONE;
 	}
-
-	return r;
+	if (r)
+		dev_err(dev, "Failed to %s - passthrough or MSI/MSI-X might fail!\n",
+			action == BUS_NOTIFY_ADD_DEVICE ? "add" :
+			(action == BUS_NOTIFY_DEL_DEVICE ? "delete" : "?"));
+	return NOTIFY_OK;
 }
 
-struct notifier_block device_nb = {
+static struct notifier_block device_nb = {
 	.notifier_call = xen_pci_notifier,
 };
 
-- 
1.7.4.1

