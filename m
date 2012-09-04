Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2IDVhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:37:04 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60282
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757920Ab2IDVg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:36:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 06/10] Tools: hv: Gather DHCP information
Date: Tue,  4 Sep 2012 14:46:38 -0700
Message-Id: <1346795202-25655-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346795202-25655-1-git-send-email-kys@microsoft.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect information on dhcp setting for the specified interface.
We invoke an external (Distro specific)  script to get this information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index cfa23a1..6fb2c1c 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -524,6 +524,9 @@ static void kvp_get_ipconfig_info(char *if_name,
 				 struct hv_kvp_ipaddr_value *buffer)
 {
 	char cmd[512];
+	char dhcp_info[128];
+	char *p;
+	FILE *file;
 
 	/*
 	 * Get the address of default gateway (ipv4).
@@ -572,6 +575,34 @@ static void kvp_get_ipconfig_info(char *if_name,
 	 */
 	kvp_process_ipconfig_file(cmd, (char *)buffer->dns_addr,
 				(MAX_IP_ADDR_SIZE * 2), INET_ADDRSTRLEN, 0);
+
+	/*
+	 * Gather the DHCP state.
+	 * We will gather this state by invoking an external script.
+	 * The parameter to the script is the interface name.
+	 * Here is the expected output:
+	 *
+	 * Enabled: DHCP enabled.
+	 */
+
+	sprintf(cmd, "%s %s", "hv_get_dhcp_info", if_name);
+
+	file = popen(cmd, "r");
+	if (file == NULL)
+		return;
+
+	p = fgets(dhcp_info, sizeof(dhcp_info), file);
+	if (p == NULL) {
+		pclose(file);
+		return;
+	}
+
+	if (!strncmp(p, "Enabled", 7))
+		buffer->dhcp_enabled = 1;
+	else
+		buffer->dhcp_enabled = 0;
+
+	pclose(file);
 }
 
 
-- 
1.7.4.1

