Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0DBBER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:04:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0DBBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:04:14 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Michal Simek <monstr@monstr.eu>,
       Johannes Berg <johannes@sipsolutions.net>, Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Anatolij Gustschin <agust@denx.de>,
       Kai Jiang <b18973@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org
Date: Fri,  2 Apr 2010 03:02:15 +0200
Message-Id: <1270170140-325-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270170140-325-1-git-send-email-w.sang@pengutronix.de>
References: <1270170140-325-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 2/2] device_attributes: add sysfs_attr_init() for dynamic attributes
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe. Prevents further
"key xxx not in .data" bug-reports. Although some attributes could probably be
converted to static ones, this is left for people having hardware to test.

Found by this semantic patch:

@ init @
type T;
identifier A;
@@

        T {
                ...
                struct device_attribute A;
                ...
        };

@ main extends init @
expression E;
statement S;
identifier err;
T *name;
@@

        ... when != sysfs_attr_init(&name->A.attr);
(
+       sysfs_attr_init(&name->A.attr);
        if (device_create_file(E, &name->A))
                S
|
+       sysfs_attr_init(&name->A.attr);
        err = device_create_file(E, &name->A);
)

While reviewing, I put the initialization to apropriate places.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/macintosh/windfarm_core.c           |    1 +
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    8 ++++++++
 drivers/platform/x86/intel_menlow.c         |    1 +
 drivers/video/fsl-diu-fb.c                  |    1 +
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 419795f..f447642 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -209,6 +209,7 @@ int wf_register_control(struct wf_control *new_ct)
 	kref_init(&new_ct->ref);
 	list_add(&new_ct->link, &wf_controls);
 
+	sysfs_attr_init(&new_ct->attr.attr);
 	new_ct->attr.attr.name = new_ct->name;
 	new_ct->attr.attr.mode = 0644;
 	new_ct->attr.show = wf_show_control;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 6c23456..71f5056 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -423,10 +423,12 @@ static void pvr2_sysfs_add_debugifc(struct pvr2_sysfs *sfp)
 
 	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
 	if (!dip) return;
+	sysfs_attr_init(&dip->attr_debugcmd.attr);
 	dip->attr_debugcmd.attr.name = "debugcmd";
 	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
 	dip->attr_debugcmd.show = debugcmd_show;
 	dip->attr_debugcmd.store = debugcmd_store;
+	sysfs_attr_init(&dip->attr_debuginfo.attr);
 	dip->attr_debuginfo.attr.name = "debuginfo";
 	dip->attr_debuginfo.attr.mode = S_IRUGO;
 	dip->attr_debuginfo.show = debuginfo_show;
@@ -644,6 +646,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		return;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_minor_number.attr);
 	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
 	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
@@ -658,6 +661,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->v4l_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_radio_minor_number.attr);
 	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
 	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
@@ -672,6 +676,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_unit_number.attr);
 	sfp->attr_unit_number.attr.name = "unit_number";
 	sfp->attr_unit_number.attr.mode = S_IRUGO;
 	sfp->attr_unit_number.show = unit_number_show;
@@ -685,6 +690,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->unit_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_bus_info.attr);
 	sfp->attr_bus_info.attr.name = "bus_info_str";
 	sfp->attr_bus_info.attr.mode = S_IRUGO;
 	sfp->attr_bus_info.show = bus_info_show;
@@ -699,6 +705,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->bus_info_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_name.attr);
 	sfp->attr_hdw_name.attr.name = "device_hardware_type";
 	sfp->attr_hdw_name.attr.mode = S_IRUGO;
 	sfp->attr_hdw_name.show = hdw_name_show;
@@ -713,6 +720,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->hdw_name_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_desc.attr);
 	sfp->attr_hdw_desc.attr.name = "device_hardware_description";
 	sfp->attr_hdw_desc.attr.mode = S_IRUGO;
 	sfp->attr_hdw_desc.show = hdw_desc_show;
diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index f0a90a6..90ba5d7 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -396,6 +396,7 @@ static int intel_menlow_add_one_attribute(char *name, int mode, void *show,
 	if (!attr)
 		return -ENOMEM;
 
+	sysfs_attr_init(&attr->attr.attr); /* That is consistent naming :D */
 	attr->attr.attr.name = name;
 	attr->attr.attr.mode = mode;
 	attr->attr.show = show;
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 4637bcb..994358a 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1536,6 +1536,7 @@ static int __devinit fsl_diu_probe(struct of_device *ofdev,
 		goto error;
 	}
 
+	sysfs_attr_init(&machine_data->dev_attr.attr);
 	machine_data->dev_attr.attr.name = "monitor";
 	machine_data->dev_attr.attr.mode = S_IRUGO|S_IWUSR;
 	machine_data->dev_attr.show = show_monitor;
-- 
1.7.0

