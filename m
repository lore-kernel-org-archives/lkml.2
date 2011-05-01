Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1EABhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1EABhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xsHG+L2V0NLoRbFRC1x4ZksUgxAw2U2YXtnpt7z79mIH16jlDeHePdUAD945CDW4pr
         ac1nLbGan9kf9tpsyybzmI7FxSyN6aPTaDZ06THXMJpPW6zmvChBiUAo1VDCNCefbYtq
         s7WdDtevMQVxevAFv1V/fNXvXdDZyqJqICAXk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 02/69] sysctl: parport: reorder .child assignments to simplify review
Date: Sun,  1 May 2011 03:35:32 +0200
Message-Id: <1304213799-10257-3-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/parport/procfs.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 89b8b71..edeb012 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -437,16 +437,17 @@ int parport_proc_register(struct parport *port)
 		t->vars[i].extra1 = port;
 
 	t->vars[0].data = &port->spintime;
-	t->vars[5].child = t->device_dir;
 	
 	for (i = 0; i < 5; i++)
 		t->vars[6 + i].extra2 = &port->probe_info[i];
 
 	t->port_dir[0].procname = port->name;
 
-	t->port_dir[0].child = t->vars;
-	t->parport_dir[0].child = t->port_dir;
 	t->dev_dir[0].child = t->parport_dir;
+	t->parport_dir[0].child = t->port_dir;
+	t->port_dir[0].child = t->vars;
+	t->vars[5].child = t->device_dir;
+	/* vars[5] = PARPORT_DEVICES_ROOT_DIR => .procname = 'devices' */
 
 	t->sysctl_header = register_sysctl_table(t->dev_dir);
 	if (t->sysctl_header == NULL) {
@@ -478,14 +479,15 @@ int parport_device_proc_register(struct pardevice *device)
 		return -ENOMEM;
 	memcpy(t, &parport_device_sysctl_template, sizeof(*t));
 
+	t->port_dir[0].procname = port->name;
+	t->device_dir[0].procname = device->name;
+
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
-	t->port_dir[0].procname = port->name;
 	t->port_dir[0].child = t->devices_root_dir;
 	t->devices_root_dir[0].child = t->device_dir;
-
-	t->device_dir[0].procname = device->name;
 	t->device_dir[0].child = t->vars;
+
 	t->vars[0].data = &device->timeslice;
 
 	t->sysctl_header = register_sysctl_table(t->dev_dir);
-- 
1.7.5.134.g1c08b

