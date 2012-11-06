Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2KFTy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:54:57 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:53114 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2KFTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:54:55 -0500
Date: Tue, 6 Nov 2012 14:54:45 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com
Message-ID: <1002964725.7541965.1352231685241.JavaMail.root@redhat.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930DFBAFA@SN2PRD0310MB382.namprd03.prod.outlook.com>
Subject: Re: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
 validation allows DoS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.4.62]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6199072f8131056efce208f04e6985d1f9968d8e Mon Sep 17 00:00:00 2001
From: Tomas Hozza <thozza@redhat.com>
Date: Mon, 5 Nov 2012 10:08:16 +0100
Subject: [PATCH] Netlink source address validation allows DoS

The source code without this patch caused hypervkvpd to exit when it processed
a spoofed Netlink packet which has been sent from an untrusted local user.
Netlink messages with a non-zero nl_pid source address should just be ignored.
---
 tools/hv/hv_kvp_daemon.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 3ea3af2..7d74497 100755
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1478,13 +1478,19 @@ int main(void)
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

----- Original Message -----
> 
> 
> > -----Original Message-----
> > From: Tomas Hozza [mailto:thozza@redhat.com]
> > Sent: Tuesday, November 06, 2012 10:21 AM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; apw@canonical.com;
> > jasowang@redhat.com
> > Cc: Olaf Hering; KY Srinivasan
> > Subject: [PATCH] tools/hv/hv_kvp_daemon.c: Netlink source address
> > validation
> > allows DoS
> > 
> > Hi.
> > 
> > After discussion with KY Srinivasan and Olaf Hering I'm sending you
> > a patch for the HyperV KVP daemon distributed in linux kernel
> > "tools/hv/hv_kvp_daemon.c".
> > 
> > There is an issue in the current daemon source causing hyperv kvp
> > daemon
> > to exit when it processes a spoofed Netlink packet which has been
> > sent
> > from an untrusted local user.
> > 
> > This patch is fixing this, so now the Netlink messages with a
> > non-zero
> > nl_pid source address are just ignored.
> 
> You don't want to send the patch as an attachment.  Please send the
> patch
> as part of the mail.
> 
> Regards,
> 
> K. Y
> > 
> > 
> > Regards,
> > 
> > Tomas Hozza
> > Associate Software Engineer
> > BaseOS - Brno, CZ
> 
