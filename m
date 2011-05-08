Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1EHXHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:07:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1EHWka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LAIE9wzLNVQMvxVk1SRWuWlnI6SFGwoF4uZhyXBXs0dRjMBwnhcdezVO3zeZgQYZdC
         PtoVGhJqQqYhfqVAayISPRgfpCrBftCBSy5G0H27jqkM7pbqiGpaIpy7aMdZhlWRPbLk
         hn4oP0+Sj1rd4bdwTwNnxMltg94Fa3h093aYk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 002/115] sysctl: parport: reorder .child assignments to simplify review
Date: Mon,  9 May 2011 00:38:14 +0200
Message-Id: <1304894407-32201-3-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

