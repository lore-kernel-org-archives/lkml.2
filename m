Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2IEQpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:45:40 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41370
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758930Ab2IEQoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:44:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 4/4] tools: hv: Parse /etc/os-release
Date: Wed,  5 Sep 2012 10:02:33 -0700
Message-Id: <1346864553-30059-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346864553-30059-1-git-send-email-kys@microsoft.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
 <1346864553-30059-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new convention, used by systemd and supported by most
distributions, to put basic OS release information in /etc/os-release.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 tools/hv/hv_kvp_daemon.c |   50 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 3922abc..77a8413 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -465,15 +465,59 @@ void kvp_get_os_info(void)
 	if (p)
 		*p = '\0';
 
+	/*
+	 * Parse the /etc/os-release file if present:
+	 * http://www.freedesktop.org/software/systemd/man/os-release.html
+	 */
+	file = fopen("/etc/os-release", "r");
+	if (file != NULL) {
+		while (fgets(buf, sizeof(buf), file)) {
+			char *value, *q;
+
+			/* Ignore comments */
+			if (buf[0] == '#')
+				continue;
+
+			/* Split into name=value */
+			p = strchr(buf, '=');
+			if (!p)
+				continue;
+			*p++ = 0;
+
+			/* Remove quotes and newline; un-escape */
+			value = p;
+			q = p;
+			while (*p) {
+				if (*p == '\\') {
+					++p;
+					if (!*p)
+						break;
+					*q++ = *p++;
+				} else if (*p == '\'' || *p == '"' ||
+					   *p == '\n') {
+					++p;
+				} else {
+					*q++ = *p++;
+				}
+			}
+			*q = 0;
+
+			if (!strcmp(buf, "NAME"))
+				os_name = strdup(value);
+			else if (!strcmp(buf, "VERSION_ID"))
+				os_major = strdup(value);
+		}
+		fclose(file);
+		return;
+	}
+
+	/* Fallback for older RH/SUSE releases */
 	file = fopen("/etc/SuSE-release", "r");
 	if (file != NULL)
 		goto kvp_osinfo_found;
 	file  = fopen("/etc/redhat-release", "r");
 	if (file != NULL)
 		goto kvp_osinfo_found;
-	/*
-	 * Add code for other supported platforms.
-	 */
 
 	/*
 	 * We don't have information about the os.
-- 
1.7.4.1

