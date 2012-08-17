Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab2HQA3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:29:22 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41866
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932614Ab2HQA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:28:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/14] Tools: hv: Gather DHCP information
Date: Thu, 16 Aug 2012 17:45:20 -0700
Message-Id: <1345164325-5198-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345164325-5198-1-git-send-email-kys@microsoft.com>
References: <1345164300-5146-1-git-send-email-kys@microsoft.com>
 <1345164325-5198-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/hv/hv_kvp_daemon.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 2f8e0b9..8a18819 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -525,6 +525,9 @@ static void kvp_get_ipconfig_info(char *if_name,
 				 struct hv_kvp_ipaddr_value *buffer)
 {
 	char cmd[512];
+	char dhcp_info[128];
+	char *p;
+	FILE *file;
 
 	/*
 	 * Get the address of default gateway (ipv4).
@@ -573,6 +576,34 @@ static void kvp_get_ipconfig_info(char *if_name,
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

