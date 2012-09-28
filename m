Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031863Ab2I1UGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:06:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2I1Sys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 023/262] net: fix info leak in compat dev_ifconf()
Date: Fri, 28 Sep 2012 11:49:12 -0700
Message-Id: <20120928183000.655396306@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 43da5f2e0d0c69ded3d51907d9552310a6b545e8 ]

The implementation of dev_ifconf() for the compat ioctl interface uses
an intermediate ifc structure allocated in userland for the duration of
the syscall. Though, it fails to initialize the padding bytes inserted
for alignment and that for leaks four bytes of kernel stack. Add an
explicit memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2658,6 +2658,7 @@ static int dev_ifconf(struct net *net, s
 	if (copy_from_user(&ifc32, uifc32, sizeof(struct compat_ifconf)))
 		return -EFAULT;
 
+	memset(&ifc, 0, sizeof(ifc));
 	if (ifc32.ifcbuf == 0) {
 		ifc32.ifc_len = 0;
 		ifc.ifc_len = 0;


