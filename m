Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab1EABqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:46:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab1EABh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ha/StKrUnjl6L+2kYAVx3FBoiGuAMJNLziGh/59n9Oaj3gN3ApwJFFua9WBc/kpSAR
         Mtox42hjxTjWtuADUH4EDfYgPoKljus26vz8Fc2Vdf44/Hqb029xzinHUd45zkSxwitG
         dd4RLz8EFYbxW8P4X28TvUVxIE4XuXA8Beon4=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 54/69] sysctl: remove .child from net/llc tables
Date: Sun,  1 May 2011 03:36:24 +0200
Message-Id: <1304213799-10257-55-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/llc/sysctl_net_llc.c |   55 +++++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/net/llc/sysctl_net_llc.c b/net/llc/sysctl_net_llc.c
index e2ebe35..8977307 100644
--- a/net/llc/sysctl_net_llc.c
+++ b/net/llc/sysctl_net_llc.c
@@ -56,48 +56,49 @@ static struct ctl_table llc_station_table[] = {
 	{ },
 };
 
-static struct ctl_table llc2_dir_timeout_table[] = {
-	{
-		.procname	= "timeout",
-		.mode		= 0555,
-		.child		= llc2_timeout_table,
-	},
-	{ },
-};
 
-static struct ctl_table llc_table[] = {
-	{
-		.procname	= "llc2",
-		.mode		= 0555,
-		.child		= llc2_dir_timeout_table,
-	},
-	{
-		.procname       = "station",
-		.mode           = 0555,
-		.child          = llc_station_table,
-	},
-	{ },
+static const __initdata struct ctl_path llc2_timeout_path[] = {
+	{ .procname = "net", },
+	{ .procname = "llc", },
+	{ .procname = "llc2", },
+	{ .procname = "timeout", },
+	{ }
 };
 
-static struct ctl_path llc_path[] = {
+static const __initdata struct ctl_path llc_station_path[] = {
 	{ .procname = "net", },
 	{ .procname = "llc", },
+	{ .procname = "station", },
 	{ }
 };
 
-static struct ctl_table_header *llc_table_header;
+static struct ctl_table_header *llc_station_hdr;
+static struct ctl_table_header *llc2_timeout_hdr;
 
 int __init llc_sysctl_init(void)
 {
-	llc_table_header = register_sysctl_paths(llc_path, llc_table);
+	llc_station_hdr = register_sysctl_paths(llc_station_path, llc_station_table);
+	if (!llc_station_hdr)
+		return -ENOMEM;
 
-	return llc_table_header ? 0 : -ENOMEM;
+	llc2_timeout_hdr = register_sysctl_paths(llc2_timeout_path, llc2_timeout_table);
+	if (!llc2_timeout_hdr) {
+		unregister_sysctl_table(llc_station_hdr);
+		llc_station_hdr = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 void llc_sysctl_exit(void)
 {
-	if (llc_table_header) {
-		unregister_sysctl_table(llc_table_header);
-		llc_table_header = NULL;
+	if (llc2_timeout_hdr) {
+		unregister_sysctl_table(llc2_timeout_hdr);
+		llc2_timeout_hdr = NULL;
+	}
+	if (llc_station_hdr) {
+		unregister_sysctl_table(llc_station_hdr);
+		llc_station_hdr = NULL;
 	}
 }
-- 
1.7.5.134.g1c08b

