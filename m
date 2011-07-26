Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1GZSM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:12:29 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:40113
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751443Ab1GZSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:12:24 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: util: kvp: Cleanup kvp_get_domain_name()
Date: Tue, 26 Jul 2011 11:03:10 -0700
Message-Id: <1311703390-6451-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kvp_get_domain_name(). If getaddrinfo() fails, deal with it properly
(this can happen if no IP address has been assigned). Also, don't specify
a specific service in the call to getaddrinfo() to make this code as generic
as possible. Lastly, move the call to gethostname() after the local variables.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/tools/hv_kvp_daemon.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/tools/hv_kvp_daemon.c b/drivers/staging/hv/tools/hv_kvp_daemon.c
index 6f3e5c2..57789f9 100644
--- a/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ b/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -274,22 +274,20 @@ static int
 kvp_get_domain_name(char *buffer, int length)
 {
 	struct addrinfo	hints, *info ;
-	gethostname(buffer, length);
 	int error = 0;
 
+	gethostname(buffer, length);
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_INET; /*Get only ipv4 addrinfo. */
 	hints.ai_socktype = SOCK_STREAM;
 	hints.ai_flags = AI_CANONNAME;
 
-	error = getaddrinfo(buffer, "http", &hints, &info);
+	error = getaddrinfo(buffer, NULL, &hints, &info);
 	if (error != 0) {
 		strcpy(buffer, "getaddrinfo failed\n");
-		error = 1;
-		goto get_domain_done;
+		return error;
 	}
 	strcpy(buffer, info->ai_canonname);
-get_domain_done:
 	freeaddrinfo(info);
 	return error;
 }
-- 
1.7.4.1

