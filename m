Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2ITOrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab2ITOlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:41:31 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 05/10] asus-wmi: Restrict debugfs interface
Date: Thu, 20 Sep 2012 10:41:00 -0400
Message-Id: <1348152065-31353-6-git-send-email-mjg@redhat.com>
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have no way of validating what all of the Asus WMI methods do on a
given machine, and there's a risk that some will allow hardware state to
be manipulated in such a way that arbitrary code can be executed in the
kernel. Add a capability check to prevent that.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/asus-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c0e9ff4..3c10167 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1521,6 +1521,9 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
@@ -1537,6 +1540,9 @@ static int show_devs(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
 				    &retval);
 
@@ -1561,6 +1567,9 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     1, asus->debug.method_id,
 				     &input, &output);
-- 
1.7.11.4

