Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1C3CNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:13:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1C3CNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:13:21 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XdyGaWegCa8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=C2oOpmTikdHkmFHgcv4A:9 a=BMehiCjh4hFjR-vg7Q9rG_rLFvUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] netfilter: Fix build failure when ipv6 but xt_tproxy is
 built in
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        KOVACS Krisztian <hidden@balabit.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 22:13:19 -0400
Message-ID: <1301451199.14261.327.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running ktest.pl doing ranconfigs, the following build error
occurred:

net/built-in.o: In function `tproxy_tg6_v1':
/home/rostedt/work/autotest/nobackup/linux-test.git/net/netfilter/xt_TPROXY.c:288: undefined reference to `ipv6_find_hdr'

This happened because the xt_TPROXY code was compiled into the kernel
proper, but the ipv6 netfilter was compiled as a module. The fix is to
only enter the code that calls ipv6_find_hdr if ipv6 netfilter is
compiled into the kernel, or if it is a module, so is the xt_TPROXY
code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index dcfd57e..5915f94 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -22,7 +22,13 @@
 
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+/*
+ * Only include the following if ip6 tables is compiled in
+ * the kernel, or it is a module and this code is also a module.
+ */
+#if defined(CONFIG_IP6_NF_IPTABLES) || \
+	(defined(CONFIG_IP6_NF_IPTABLES_MODULE) && \
+	 defined(CONFIG_NETFILTER_XT_TARGET_TPROXY_MODULE))
 #define XT_TPROXY_HAVE_IPV6 1
 #include <net/if_inet6.h>
 #include <net/addrconf.h>


