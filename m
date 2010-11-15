Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0KOQCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:02:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54527 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KOQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:02:10 -0500
From: Andy Whitcroft <apw@canonical.com>
To: "David S. Miller\"" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 1/1] net: rtnetlink.h -- only include linux/netdevice.h when used by the kernel
Date: Mon, 15 Nov 2010 16:01:59 +0000
Message-Id: <1289836919-19153-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289836919-19153-1-git-send-email-apw@canonical.com>
References: <1289836919-19153-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below added a new helper dev_ingress_queue to cleanly obtain the
ingress queue pointer.  This necessitated including 'linux/netdevice.h':

  commit 24824a09e35402b8d58dcc5be803a5ad3937bdba
  Author: Eric Dumazet <eric.dumazet@gmail.com>
  Date:   Sat Oct 2 06:11:55 2010 +0000

    net: dynamic ingress_queue allocation

However this include triggers issues for applications in userspace
which use the rtnetlink interfaces.  Commonly this requires they include
'net/if.h' and 'linux/rtnetlink.h' leading to a compiler error as below:

  In file included from /usr/include/linux/netdevice.h:28:0,
                   from /usr/include/linux/rtnetlink.h:9,
                   from t.c:2:
  /usr/include/linux/if.h:135:8: error: redefinition of ‘struct ifmap’
  /usr/include/net/if.h:112:8: note: originally defined here
  /usr/include/linux/if.h:169:8: error: redefinition of ‘struct ifreq’
  /usr/include/net/if.h:127:8: note: originally defined here
  /usr/include/linux/if.h:218:8: error: redefinition of ‘struct ifconf’
  /usr/include/net/if.h:177:8: note: originally defined here

The new helper is only defined for the kernel and protected by __KERNEL__
therefore we can simply pull the include down into the same protected
section.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 include/linux/rtnetlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index d42f274..bbad657 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -6,7 +6,6 @@
 #include <linux/if_link.h>
 #include <linux/if_addr.h>
 #include <linux/neighbour.h>
-#include <linux/netdevice.h>
 
 /* rtnetlink families. Values up to 127 are reserved for real address
  * families, values above 128 may be used arbitrarily.
@@ -606,6 +605,7 @@ struct tcamsg {
 #ifdef __KERNEL__
 
 #include <linux/mutex.h>
+#include <linux/netdevice.h>
 
 static __inline__ int rtattr_strcmp(const struct rtattr *rta, const char *str)
 {
-- 
1.7.0.4

