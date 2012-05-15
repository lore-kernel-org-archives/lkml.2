Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab2EOL5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:57:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54409 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2EOL5Q convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 15 May 2012 07:57:16 -0400
Message-Id: <4FB260D80200007800083C91@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 12:57:44 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] xfrm: make xfrm_algo.c a module
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By making this a standalone config option (auto-selected as needed),
selecting CRYPTO from here rather than from XFRM (which is boolean)
allows the core crypto code to become a module again even when XFRM=y.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
v2: Drop an unrelated change.
---
 net/ipv4/Kconfig     |    4 ++--
 net/ipv6/Kconfig     |    4 ++--
 net/xfrm/Kconfig     |   13 +++++++++----
 net/xfrm/Makefile    |    3 ++-
 net/xfrm/xfrm_algo.c |    2 ++
 5 files changed, 17 insertions(+), 9 deletions(-)

--- 3.4-rc7/net/ipv4/Kconfig
+++ 3.4-rc7-xfrm-algo-module/net/ipv4/Kconfig
@@ -312,7 +312,7 @@ config SYN_COOKIES
 
 config INET_AH
 	tristate "IP: AH transformation"
-	select XFRM
+	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
@@ -324,7 +324,7 @@ config INET_AH
 
 config INET_ESP
 	tristate "IP: ESP transformation"
-	select XFRM
+	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_AUTHENC
 	select CRYPTO_HMAC
--- 3.4-rc7/net/ipv6/Kconfig
+++ 3.4-rc7-xfrm-algo-module/net/ipv6/Kconfig
@@ -69,7 +69,7 @@ config IPV6_OPTIMISTIC_DAD
 
 config INET6_AH
 	tristate "IPv6: AH transformation"
-	select XFRM
+	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
@@ -81,7 +81,7 @@ config INET6_AH
 
 config INET6_ESP
 	tristate "IPv6: ESP transformation"
-	select XFRM
+	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_AUTHENC
 	select CRYPTO_HMAC
--- 3.4-rc7/net/xfrm/Kconfig
+++ 3.4-rc7-xfrm-algo-module/net/xfrm/Kconfig
@@ -3,12 +3,17 @@
 #
 config XFRM
        bool
-       select CRYPTO
        depends on NET
 
+config XFRM_ALGO
+	tristate
+	select XFRM
+	select CRYPTO
+
 config XFRM_USER
 	tristate "Transformation user configuration interface"
-	depends on INET && XFRM
+	depends on INET
+	select XFRM_ALGO
 	---help---
 	  Support for Transformation(XFRM) user configuration interface
 	  like IPsec used by native Linux tools.
@@ -48,13 +53,13 @@ config XFRM_STATISTICS
 
 config XFRM_IPCOMP
 	tristate
-	select XFRM
+	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_DEFLATE
 
 config NET_KEY
 	tristate "PF_KEY sockets"
-	select XFRM
+	select XFRM_ALGO
 	---help---
 	  PF_KEYv2 socket family, compatible to KAME ones.
 	  They are required if you are going to use IPsec tools ported
--- 3.4-rc7/net/xfrm/Makefile
+++ 3.4-rc7-xfrm-algo-module/net/xfrm/Makefile
@@ -3,8 +3,9 @@
 #
 
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
-		      xfrm_input.o xfrm_output.o xfrm_algo.o \
+		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o
 obj-$(CONFIG_XFRM_STATISTICS) += xfrm_proc.o
+obj-$(CONFIG_XFRM_ALGO) += xfrm_algo.o
 obj-$(CONFIG_XFRM_USER) += xfrm_user.o
 obj-$(CONFIG_XFRM_IPCOMP) += xfrm_ipcomp.o
--- 3.4-rc7/net/xfrm/xfrm_algo.c
+++ 3.4-rc7-xfrm-algo-module/net/xfrm/xfrm_algo.c
@@ -752,3 +752,5 @@ void *pskb_put(struct sk_buff *skb, stru
 }
 EXPORT_SYMBOL_GPL(pskb_put);
 #endif
+
+MODULE_LICENSE("GPL");



