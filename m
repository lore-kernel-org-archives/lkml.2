Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab2GLWX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:23:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2GLWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:23:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>, Marcus Meissner <meissner@suse.de>,
        Sebastian Krahmer <krahmer@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 001/187] Tools: hv: verify origin of netlink connector message
Date: Thu, 12 Jul 2012 15:23:29 -0700
Message-Id: <20120712191522.378465973@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712192421.GA28926@kroah.com>
References: <20120712192421.GA28926@kroah.com>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 tools/hv/hv_kvp_daemon.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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


