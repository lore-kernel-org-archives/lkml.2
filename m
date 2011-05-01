Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab1EABhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1EABhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gsskXhoHm9G2+9/WkftzERLfhk72jUS3L6JspOPSpYXBz10zjUKAbgnAsRQ7dXVoPF
         X75BwlrOMFMp1FkN+sUVs9++fllw5uOtQ54yY6TdvH1J4JeeGdlk8VkGPRtS14RmTshK
         wnahHivoOftQUGqRWKp8pyPvkPk8PneYVp0nQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 05/69] sysctl: remove .child from dev/parport/PORT/devices/
Date: Sun,  1 May 2011 03:35:35 +0200
Message-Id: <1304213799-10257-6-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/parport/procfs.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index e55b9b6..3bb5bed 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -248,6 +248,7 @@ PARPORT_MAX_SPINTIME_VALUE;
 
 struct parport_sysctl_table {
 	struct ctl_table_header *sysctl_header;
+	struct ctl_table_header *devices_sysctl_header;
 	ctl_table vars[12];
 	ctl_table device_dir[2];
 };
@@ -291,11 +292,6 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 			.mode		= 0444,
 			.proc_handler	= do_hardware_modes
 		},
-		{
-			.procname = "devices",
-			.mode = 0555,
-			.child = NULL, /* child will point to .device_dir */
-		},
 #ifdef CONFIG_PARPORT_1284
 		{
 			.procname	= "autoprobe",
@@ -378,6 +374,14 @@ int parport_proc_register(struct parport *port)
 		{ .procname = port->name },
 		{  },
 	};
+	struct ctl_path parport_port_devices_path[] = {
+		{ .procname = "dev" },
+		{ .procname = "parport" },
+		{ .procname = port->name },
+		{ .procname = "devices" },
+		{  },
+	};
+
 	struct parport_sysctl_table *t;
 	int i;
 
@@ -392,20 +396,29 @@ int parport_proc_register(struct parport *port)
 		t->vars[i].extra1 = port;
 
 	t->vars[0].data = &port->spintime;
-	
-	for (i = 0; i < 5; i++)
-		t->vars[6 + i].extra2 = &port->probe_info[i];
 
-	t->vars[5].child = t->device_dir;
-	/* vars[5].procname is the 'devices' dir entry */
+#ifdef CONFIG_PARPORT_1284
+	for (i = 0; i < 5; i++)
+		t->vars[5 + i].extra2 = &port->probe_info[i];
+#endif /* CONFIG_PARPORT_1284 */
 
 	t->sysctl_header = register_sysctl_paths(parport_port_path, t->vars);
-	if (t->sysctl_header == NULL) {
-		kfree(t);
-		t = NULL;
-	}
+	if (t->sysctl_header == NULL)
+		goto fail_register_port;
+
+	t->devices_sysctl_header = register_sysctl_paths(parport_port_devices_path,
+							 t->device_dir);
+	if (t->devices_sysctl_header == NULL)
+		goto fail_register_devices;
 	port->sysctl_table = t;
 	return 0;
+
+fail_register_devices:
+	unregister_sysctl_table(t->sysctl_header);
+fail_register_port:
+	kfree(t);
+
+	return -ENOMEM;
 }
 
 int parport_proc_unregister(struct parport *port)
@@ -413,6 +426,7 @@ int parport_proc_unregister(struct parport *port)
 	if (port->sysctl_table) {
 		struct parport_sysctl_table *t = port->sysctl_table;
 		port->sysctl_table = NULL;
+		unregister_sysctl_table(t->devices_sysctl_header);
 		unregister_sysctl_table(t->sysctl_header);
 		kfree(t);
 	}
-- 
1.7.5.134.g1c08b

