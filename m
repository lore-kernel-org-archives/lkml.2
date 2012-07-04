Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2GDJHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:07:24 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56604 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab2GDJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:07:21 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/2 v2] Input: synaptics - add sysfs access to firmware ID & board ID
Date: Wed,  4 Jul 2012 17:07:17 +0800
Message-Id: <1341392837-19115-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
References: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow userspace to query firmware ID and board ID, which are read and
cached during device initialization.

This information can be read, for instance, by a userspace feedback
reporting tool, to include this information in its reports.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |   41 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 7e0eca7..3b24a0f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1258,6 +1258,17 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	}
 }
 
+/*****************************************************************************
+ *	sysfs interface
+ ****************************************************************************/
+/* Sysfs entry for board ID */
+static ssize_t synaptics_show_board_id(struct psmouse *psmouse, void *data,
+				       char *buf)
+{
+	struct synaptics_data *priv = psmouse->private;
+	return scnprintf(buf, PAGE_SIZE, "%lu\n", priv->board_id);
+}
+
 static ssize_t synaptics_show_disable_gesture(struct psmouse *psmouse,
 					      void *data, char *buf)
 {
@@ -1296,9 +1307,30 @@ static ssize_t synaptics_set_disable_gesture(struct psmouse *psmouse,
 	return len;
 }
 
+/* Sysfs entry for firmware ID */
+static ssize_t synaptics_show_firmware_id(struct psmouse *psmouse, void *data,
+					  char *buf)
+{
+	struct synaptics_data *priv = psmouse->private;
+	return scnprintf(buf, PAGE_SIZE, "%lu\n", priv->firmware_id);
+}
+
+PSMOUSE_DEFINE_RO_ATTR(board_id, S_IRUGO, NULL, synaptics_show_board_id);
 PSMOUSE_DEFINE_ATTR(disable_gesture, S_IWUSR | S_IRUGO, NULL,
 		    synaptics_show_disable_gesture,
 		    synaptics_set_disable_gesture);
+PSMOUSE_DEFINE_RO_ATTR(firmware_id, S_IRUGO, NULL, synaptics_show_firmware_id);
+
+static struct attribute *synaptics_attrs[] = {
+	&psmouse_attr_board_id.dattr.attr,
+	&psmouse_attr_firmware_id.dattr.attr,
+	NULL
+};
+
+static struct attribute_group synaptics_attr_group = {
+	.attrs = synaptics_attrs,
+};
+
 
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
@@ -1308,6 +1340,9 @@ static void synaptics_disconnect(struct psmouse *psmouse)
 		device_remove_file(&psmouse->ps2dev.serio->dev,
 				   &psmouse_attr_disable_gesture.dattr);
 
+	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
+			   &synaptics_attr_group);
+
 	synaptics_reset(psmouse);
 	kfree(priv);
 	psmouse->private = NULL;
@@ -1528,6 +1563,12 @@ static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
 		}
 	}
 
+	err = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
+				 &synaptics_attr_group);
+	if (err)
+		psmouse_warn(psmouse,
+			    "Failed to create sysfs attributes (%d)", err);
+
 	return 0;
 
  init_fail:
-- 
1.7.7.3

