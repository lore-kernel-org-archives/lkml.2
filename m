Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2KHONz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab2KHONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:13:54 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH] Tools: hv: Fix for long file names from readdir
Date: Thu,  8 Nov 2012 15:13:15 +0100
Message-Id: <1352383995-13856-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
sized buffers which could be too small to store really long names.

Buffer sizes have been increased and length checks added via snprintf.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 13c2a14..bbd426c 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -592,26 +592,22 @@ static char *kvp_get_if_name(char *guid)
 	DIR *dir;
 	struct dirent *entry;
 	FILE    *file;
-	char    *p, *q, *x;
+	char    *p, *x;
 	char    *if_name = NULL;
 	char    buf[256];
 	char *kvp_net_dir = "/sys/class/net/";
-	char dev_id[256];
+	char dev_id[512];
 
 	dir = opendir(kvp_net_dir);
 	if (dir == NULL)
 		return NULL;
 
-	snprintf(dev_id, sizeof(dev_id), "%s", kvp_net_dir);
-	q = dev_id + strlen(kvp_net_dir);
-
 	while ((entry = readdir(dir)) != NULL) {
 		/*
 		 * Set the state for the next pass.
 		 */
-		*q = '\0';
-		strcat(dev_id, entry->d_name);
-		strcat(dev_id, "/device/device_id");
+		snprintf(dev_id, sizeof(dev_id), "%s%s/device/device_id", kvp_net_dir,
+				entry->d_name);
 
 		file = fopen(dev_id, "r");
 		if (file == NULL)
@@ -684,28 +680,23 @@ static char *kvp_mac_to_if_name(char *mac)
 	DIR *dir;
 	struct dirent *entry;
 	FILE    *file;
-	char    *p, *q, *x;
+	char    *p, *x;
 	char    *if_name = NULL;
 	char    buf[256];
 	char *kvp_net_dir = "/sys/class/net/";
-	char dev_id[256];
+	char dev_id[512];
 	int i;
 
 	dir = opendir(kvp_net_dir);
 	if (dir == NULL)
 		return NULL;
 
-	snprintf(dev_id, sizeof(dev_id), kvp_net_dir);
-	q = dev_id + strlen(kvp_net_dir);
-
 	while ((entry = readdir(dir)) != NULL) {
 		/*
 		 * Set the state for the next pass.
 		 */
-		*q = '\0';
-
-		strcat(dev_id, entry->d_name);
-		strcat(dev_id, "/address");
+		snprintf(dev_id, sizeof(dev_id), "%s%s/address", kvp_net_dir,
+                entry->d_name);
 
 		file = fopen(dev_id, "r");
 		if (file == NULL)
-- 
1.7.11.7

