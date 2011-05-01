Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab1EABhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1EABhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kHKv/BB/jvThb2mwehWN8NZBEK+b5ACZBeBagG/D8OjJm1Byu5Qe3Sg2mxmoQVWJfQ
         4+N23h9Dr3eqX7r+FjHTlepTB56WVb4YHm5AeroMgEkK9S7peV0+x2yLOh7yN0v+Qdvp
         5muouUFNBHPTRM8bafZykKRzLp29C/RNmMhHs=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 03/69] sysctl: remove .child from dev/parport/PORT/devices/DEVICE
Date: Sun,  1 May 2011 03:35:33 +0200
Message-Id: <1304213799-10257-4-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAINTAINERS says parport is "Orphan" and I don't have a parallel
port => I cannot test that this patch works.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/parport/procfs.c |   56 ++++++++++------------------------------------
 1 files changed, 12 insertions(+), 44 deletions(-)

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index edeb012..350233e 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -370,17 +370,11 @@ struct parport_device_sysctl_table
 {
 	struct ctl_table_header *sysctl_header;
 	ctl_table vars[2];
-	ctl_table device_dir[2];
-	ctl_table devices_root_dir[2];
-	ctl_table port_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
 };
 
 static const struct parport_device_sysctl_table
 parport_device_sysctl_template = {
-	.sysctl_header = NULL,
-	{
+	.vars = {
 		{
 			.procname 	= "timeslice",
 			.data		= NULL,
@@ -391,32 +385,6 @@ parport_device_sysctl_template = {
 			.extra2		= (void*) &parport_max_timeslice_value
 		},
 	},
-	{
-		{
-			.procname	= NULL,
-			.data		= NULL,
-			.maxlen		= 0,
-			.mode		= 0555,
-			.child		= NULL
-		},
-		{}
-	},
-	{
-		PARPORT_DEVICES_ROOT_DIR,
-		{}
-	},
-	{
-		PARPORT_PORT_DIR(NULL),
-		{}
-	},
-	{
-		PARPORT_PARPORT_DIR(NULL),
-		{}
-	},
-	{
-		PARPORT_DEV_DIR(NULL),
-		{}
-	}
 };
 
 
@@ -473,24 +441,24 @@ int parport_device_proc_register(struct pardevice *device)
 {
 	struct parport_device_sysctl_table *t;
 	struct parport * port = device->port;
-	
+	struct ctl_path parport_devices_port_path[] = {
+		{ .procname = "dev" },
+		{ .procname = "parport" },
+		{ .procname = port->name },
+		{ .procname = "devices" },
+		{ .procname = device->name },
+		{  },
+	};
+
 	t = kmalloc(sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
 	memcpy(t, &parport_device_sysctl_template, sizeof(*t));
 
-	t->port_dir[0].procname = port->name;
-	t->device_dir[0].procname = device->name;
-
-	t->dev_dir[0].child = t->parport_dir;
-	t->parport_dir[0].child = t->port_dir;
-	t->port_dir[0].child = t->devices_root_dir;
-	t->devices_root_dir[0].child = t->device_dir;
-	t->device_dir[0].child = t->vars;
-
 	t->vars[0].data = &device->timeslice;
 
-	t->sysctl_header = register_sysctl_table(t->dev_dir);
+	t->sysctl_header = register_sysctl_paths(parport_devices_port_path,
+						 t->vars);
 	if (t->sysctl_header == NULL) {
 		kfree(t);
 		t = NULL;
-- 
1.7.5.134.g1c08b

