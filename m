Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2IFUXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:23:35 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52998
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932179Ab2IFUXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:23:33 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] tools/hv: Parse /etc/os-release
Date: Thu,  6 Sep 2012 13:32:14 -0700
Message-Id: <1346963534-4886-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

There is a new convention, used by systemd and supported by most
distributions, to put basic OS release information in /etc/os-release.
Added some additional error checking on strdup()

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   59 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 3922abc..5959aff 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -454,6 +454,7 @@ void kvp_get_os_info(void)
 
 	uname(&uts_buf);
 	os_build = uts_buf.release;
+	os_name = uts_buf.sysname;
 	processor_arch = uts_buf.machine;
 
 	/*
@@ -465,20 +466,70 @@ void kvp_get_os_info(void)
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
+			if (!strcmp(buf, "NAME")) {
+				p = strdup(value);
+				if (!p)
+					break;
+				os_name = p;
+			} else if (!strcmp(buf, "VERSION_ID")) {
+				p = strdup(value);
+				if (!p)
+					break;
+				os_major = p;
+			}
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
 	 */
-	os_name = uts_buf.sysname;
 	return;
 
 kvp_osinfo_found:
-- 
1.7.4.1

