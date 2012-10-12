Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2JLXVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:21:39 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55837
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2JLXVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:21:38 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Tools: hv: Don't return loopback addresses
Date: Fri, 12 Oct 2012 16:41:48 -0700
Message-Id: <1350085308-11152-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return loopback addresses and further don't terminate
the IP address strings with a semicolon. This is the current
behavior of Windows guests.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Claudio Latini <claudio.latini@live.com>
---
 tools/hv/hv_kvp_daemon.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6c7bcb9..13c2a14 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -43,6 +43,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <dirent.h>
+#include <net/if.h>
 
 /*
  * KVP protocol: The user mode component first registers with the
@@ -882,7 +883,7 @@ static int kvp_process_ip_address(void *addrp,
 		addr_length = INET6_ADDRSTRLEN;
 	}
 
-	if ((length - *offset) < addr_length + 1)
+	if ((length - *offset) < addr_length + 2)
 		return HV_E_FAIL;
 	if (str == NULL) {
 		strcpy(buffer, "inet_ntop failed\n");
@@ -890,11 +891,13 @@ static int kvp_process_ip_address(void *addrp,
 	}
 	if (*offset == 0)
 		strcpy(buffer, tmp);
-	else
+	else {
+		strcat(buffer, ";");
 		strcat(buffer, tmp);
-	strcat(buffer, ";");
+	}
 
 	*offset += strlen(str) + 1;
+
 	return 0;
 }
 
@@ -956,7 +959,9 @@ kvp_get_ip_info(int family, char *if_name, int op,
 		 * supported address families; if not we gather info on
 		 * the specified address family.
 		 */
-		if ((family != 0) && (curp->ifa_addr->sa_family != family)) {
+		if ((((family != 0) &&
+			 (curp->ifa_addr->sa_family != family))) ||
+			 (curp->ifa_flags & IFF_LOOPBACK)) {
 			curp = curp->ifa_next;
 			continue;
 		}
-- 
1.7.4.1

