Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab2HGWco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:32:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030389Ab2HGWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesper Juhl <jj@chaosbits.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 100/122] net: Fix references to out-of-scope variables in put_cmsg_compat()
Date: Tue,  7 Aug 2012 15:26:28 -0700
Message-Id: <20120807221958.533537902@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jesper Juhl <jj@chaosbits.net>

[ Upstream commit 818810472b129004c16fc51bf0a570b60776bfb7 ]

In net/compat.c::put_cmsg_compat() we may assign 'data' the address of
either the 'ctv' or 'cts' local variables inside the 'if
(!COMPAT_USE_64BIT_TIME)' branch.

Those variables go out of scope at the end of the 'if' statement, so
when we use 'data' further down in 'copy_to_user(CMSG_COMPAT_DATA(cm),
data, cmlen - sizeof(struct compat_cmsghdr))' there's no telling what
it may be refering to - not good.

Fix the problem by simply giving 'ctv' and 'cts' function scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/compat.c
+++ b/net/compat.c
@@ -221,6 +221,8 @@ int put_cmsg_compat(struct msghdr *kmsg,
 {
 	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
 	struct compat_cmsghdr cmhdr;
+	struct compat_timeval ctv;
+	struct compat_timespec cts[3];
 	int cmlen;
 
 	if (cm == NULL || kmsg->msg_controllen < sizeof(*cm)) {
@@ -229,8 +231,6 @@ int put_cmsg_compat(struct msghdr *kmsg,
 	}
 
 	if (!COMPAT_USE_64BIT_TIME) {
-		struct compat_timeval ctv;
-		struct compat_timespec cts[3];
 		if (level == SOL_SOCKET && type == SCM_TIMESTAMP) {
 			struct timeval *tv = (struct timeval *)data;
 			ctv.tv_sec = tv->tv_sec;


