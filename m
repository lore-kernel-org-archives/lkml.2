Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0JBLYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:24:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51897 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0JBLYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:24:24 -0400
Message-Id: <20101002112419.248437367@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Sat, 02 Oct 2010 06:24:06 -0500
From: Robin Holt <holt@sgi.com>
To: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.
References: <20101002112405.951704198@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=sysctl_tcp_udp_mem_max_overflows
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [Patch] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.

On a 16TB x86_64 machine, sysctl_tcp_mem[2], sysctl_udp_mem[2], and
sysctl_sctp_mem[2] can integer overflow.  Set limit such that they are
maximized without overflowing.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>

---

 net/ipv4/tcp.c |    4 +++-
 net/ipv4/udp.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: pv1010932/net/ipv4/tcp.c
===================================================================
--- pv1010932.orig/net/ipv4/tcp.c	2010-10-02 06:11:59.737449853 -0500
+++ pv1010932/net/ipv4/tcp.c	2010-10-02 06:12:35.445454593 -0500
@@ -3271,12 +3271,14 @@ void __init tcp_init(void)
 
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
-	 * memory, with a floor of 128 pages.
+	 * memory, with a floor of 128 pages, and a ceiling that prevents an
+	 * integer overflow.
 	 */
 	nr_pages = totalram_pages - totalhigh_pages;
 	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_tcp_mem[0] = limit / 4 * 3;
 	sysctl_tcp_mem[1] = limit;
 	sysctl_tcp_mem[2] = sysctl_tcp_mem[0] * 2;
Index: pv1010932/net/ipv4/udp.c
===================================================================
--- pv1010932.orig/net/ipv4/udp.c	2010-10-02 06:11:59.737449853 -0500
+++ pv1010932/net/ipv4/udp.c	2010-10-02 06:12:35.453453784 -0500
@@ -2167,12 +2167,14 @@ void __init udp_init(void)
 	udp_table_init(&udp_table, "UDP");
 	/* Set the pressure threshold up by the same strategy of TCP. It is a
 	 * fraction of global memory that is up to 1/2 at 256 MB, decreasing
-	 * toward zero with the amount of memory, with a floor of 128 pages.
+	 * toward zero with the amount of memory, with a floor of 128 pages,
+	 * and a ceiling that prevents an integer overflow.
 	 */
 	nr_pages = totalram_pages - totalhigh_pages;
 	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_udp_mem[0] = limit / 4 * 3;
 	sysctl_udp_mem[1] = limit;
 	sysctl_udp_mem[2] = sysctl_udp_mem[0] * 2;

