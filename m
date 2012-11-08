Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2KHJya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:54:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2KHJy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:54:29 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH] tools: hv: Netlink source address validation allows DoS
Date: Thu,  8 Nov 2012 10:53:29 +0100
Message-Id: <1352368409-18809-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source code without this patch caused hypervkvpd to exit when it processed
a spoofed Netlink packet which has been sent from an untrusted local user.
Now Netlink messages with a non-zero nl_pid source address are ignored
and a warning is printed into the syslog.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 13c2a14..c1d9102 100755
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1486,13 +1486,19 @@ int main(void)
 		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
 				addr_p, &addr_l);
 
-		if (len < 0 || addr.nl_pid) {
+		if (len < 0) {
 			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
 					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}
 
+		if (addr.nl_pid) {
+			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
+					addr.nl_pid);
+			continue;
+		}
+
 		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
 		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
 		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
-- 
1.7.11.7

