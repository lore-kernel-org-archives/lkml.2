Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab2EaOkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:40:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:46119 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2EaOkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:40:12 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV7aQ=
X-RZG-CLASS-ID: mo00
Date: Thu, 31 May 2012 16:40:06 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Tools: hv: verify origin of netlink connector message
Message-ID: <20120531144006.GA24592@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SuSE security team suggested to use recvfrom instead of recv to be
certain that the connector message is originated from kernel.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 tools/hv/hv_kvp_daemon.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-3.4/tools/hv/hv_kvp_daemon.c
===================================================================
--- linux-3.4.orig/tools/hv/hv_kvp_daemon.c
+++ linux-3.4/tools/hv/hv_kvp_daemon.c
@@ -701,14 +701,18 @@ int main(void)
 	pfd.fd = fd;
 
 	while (1) {
+		struct sockaddr *addr_p = (struct sockaddr *) &addr;
+		socklen_t addr_l = sizeof(addr);
 		pfd.events = POLLIN;
 		pfd.revents = 0;
 		poll(&pfd, 1, -1);
 
-		len = recv(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0);
+		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
+				addr_p, &addr_l);
 
-		if (len < 0) {
-			syslog(LOG_ERR, "recv failed; error:%d", len);
+		if (len < 0 || addr.nl_pid) {
+			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
+					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}
