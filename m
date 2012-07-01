Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2GAS1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:27:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab2GASQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:25 -0400
Message-Id: <20120701172006.992250192@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Olaf Hering <olaf@aepfle.de>,
        Marcus Meissner <meissner@suse.de>,
        Sebastian Krahmer <krahmer@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 02/48] Tools: hv: verify origin of netlink connector message
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit bcc2c9c3fff859e0eb019fe6fec26f9b8eba795c upstream.

The SuSE security team suggested to use recvfrom instead of recv to be
certain that the connector message is originated from kernel.

CVE-2012-2669

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Marcus Meissner <meissner@suse.de>
Signed-off-by: Sebastian Krahmer <krahmer@suse.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/hv/hv_kvp_daemon.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 146fd61..d9834b3 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
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


