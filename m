Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab2FGJID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:08:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab2FGJIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:08:01 -0400
From: Marcus Meissner <meissner@suse.de>
To: gregkh@linuxfoundation.org, kys@microsoft.com, dan.carpenter@oracle.com,
        haiyangz@microsoft.com, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        stable@kernel.org
Cc: Marcus Meissner <meissner@suse.de>, Sebastian Krahmer <krahmer@suse.de>,
        Olaf Hering <ohering@suse.de>
Subject: [PATCH] tools/hv: Check the source of netlink messages to be the kernel
Date: Thu,  7 Jun 2012 11:07:48 +0200
Message-Id: <1339060068-19951-1-git-send-email-meissner@suse.de>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The hyper-v userspace helper daemon receives and handles netlink
messages. It assumes them to be from the kernel, but does not check
that.

This patch adds this checking (nl_pid == 0).

CVE-2012-2669

Ciao, Marcus

Signed-off-by: Marcus Meissner <meissner@suse.de>
Signed-off-by: Sebastian Krahmer <krahmer@suse.de>
Signed-off-by: Olaf Hering <ohering@suse.de>
---
 tools/hv/hv_kvp_daemon.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 146fd61..f0566c8 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -701,14 +701,16 @@ int main(void)
 	pfd.fd = fd;
 
 	while (1) {
+		struct sockaddr *addr_p = (struct sockaddr *) &addr;
+		socklen_t addr_l = sizeof(addr);
 		pfd.events = POLLIN;
 		pfd.revents = 0;
 		poll(&pfd, 1, -1);
 
-		len = recv(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0);
+		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0, addr_p, &addr_l);
 
-		if (len < 0) {
-			syslog(LOG_ERR, "recv failed; error:%d", len);
+		if (len < 0 || addr.nl_pid) {
+			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s", addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}
-- 
1.7.9.2

