Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2KIMsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:48:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2KIMsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:48:18 -0500
From: Tomas Hozza <thozza@redhat.com>
To: olaf@aepfle.de, kys@microsoft.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        Tomas Hozza <thozza@redhat.com>
Subject: [PATCH] Tools: hv: Fix for long file names from readdir
Date: Fri,  9 Nov 2012 13:47:21 +0100
Message-Id: <1352465241-31001-1-git-send-email-thozza@redhat.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E0242D@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E0242D@CH1PRD0310MB381.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
sized buffers which could be too small to store really long names.

Buffer sizes have been changed to PATH_MAX, include "limits.h" where
PATH_MAX is defined was added and length checks ware added via snprintf.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 13c2a14..54ecb95 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -44,6 +44,7 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <net/if.h>
+#include <limits.h>
 
 /*
  * KVP protocol: The user mode component first registers with the
@@ -592,26 +593,22 @@ static char *kvp_get_if_name(char *guid)
 	DIR *dir;
 	struct dirent *entry;
 	FILE    *file;
-	char    *p, *q, *x;
+	char    *p, *x;
 	char    *if_name = NULL;
 	char    buf[256];
 	char *kvp_net_dir = "/sys/class/net/";
-	char dev_id[256];
+	char dev_id[PATH_MAX];
 
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
@@ -684,28 +681,23 @@ static char *kvp_mac_to_if_name(char *mac)
 	DIR *dir;
 	struct dirent *entry;
 	FILE    *file;
-	char    *p, *q, *x;
+	char    *p, *x;
 	char    *if_name = NULL;
 	char    buf[256];
 	char *kvp_net_dir = "/sys/class/net/";
-	char dev_id[256];
+	char dev_id[PATH_MAX];
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

