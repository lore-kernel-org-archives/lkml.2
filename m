Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1HLLxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 07:53:14 -0400
Received: from mx.ctc-g.co.jp ([131.248.58.1]:33784 "EHLO mx.ctc.ctc-g.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab1HLLxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 07:53:12 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Aug 2011 07:53:12 EDT
Date: Fri, 12 Aug 2011 20:20:47 +0900
From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Subject: Request for Redhat
To: linux-kernel@vger.kernel.org
Cc: "omega-g1@ctc-g.co.jp" <omega-g1@ctc-g.co.jp>, notsuki@redhat.com,
        "Kozaki, Motokazu" <motokazu.kozaki@hp.com>,
        Hajime Taira <htaira@redhat.com>
Reply-to: jun.kondo@ctc-g.co.jp
Message-id: <4E450C8F.4030009@ctc-g.co.jp>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
X-post-Received: by post01.ctc-g.co.jp (CTC-GN 2006/10/01) id 82FAE74BC;	Fri,
 12 Aug 2011 20:20:39 +0900 (JST)
X-vs: by localhost.is02.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 5592053E61;
	Fri, 12 Aug 2011 20:20:39 +0900 (JST)
X-vs: by is02.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 46D5A53E5E;	Fri,
 12 Aug 2011 20:20:39 +0900 (JST)
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; ja; rv:1.9.2.12)
 Gecko/20101027 Thunderbird/3.1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CTC had the following demand;

1. to ensure high throughput from the beginning of
tcp connection at normal times by acquiring large
default transmission buffer value

2. to limit the block time of the write in order to
prevent the timeout of upper layer applications
even when the connection has low throughput, such
as low rate streaming


The root of the issue;

2 can not be achieved with the configuration that
satisfies 1.

The current behavior is as follows;

Write is blocked when tcp transmission buffer (wmem)
becomes full.
In order to write again after that, one third of the
transmission buffer (sk_wmem_queued/2) must be freed.

When the throughput is low, timeout occurs by the time
when the free buffer space is created, which affects
streaming service.


The effect of the patch;

By putting xxx into the variable yyy, the portion of
the transmission buffer becomes zzz, thus timeout will
not occur in the low throughput network environment.

xxx → integer(e.g. 4)
yyy → "sysctl_tcp_lowat"
zzz → "sk_wmem_queued >> 4"

Also, we think one third of the transmission buffer
(sk_wmem_queued/2) is too deterministic, and it should
be configurable.

--------------------------------------------------
# diff -urN sock.c sock.c.mod
--- sock.c 2011-04-14 14:58:03.000000000 +0900
+++ sock.c.mod 2011-04-21 15:31:36.000000000 +0900
@@ -205,6 +205,8 @@
__u32 sysctl_wmem_default = SK_WMEM_MAX;
__u32 sysctl_rmem_default = SK_RMEM_MAX;

+int sysctl_tcp_lowat = 1;
+
/* Maximal space eaten by iovec or ancilliary data plus some space */
int sysctl_optmem_max = sizeof(unsigned long)*(2*UIO_MAXIOV + 512);

@@ -1005,6 +1007,8 @@
sysctl_wmem_max = 131071;
sysctl_rmem_max = 131071;
}
+
+ sysctl_tcp_lowat = 1;
}

/*
@@ -2084,4 +2088,5 @@
#ifdef CONFIG_SYSCTL
EXPORT_SYMBOL(sysctl_rmem_max);
EXPORT_SYMBOL(sysctl_wmem_max);
+EXPORT_SYMBOL(sysctl_tcp_lowat);
#endif
#
# diff -urN sock.h sock.h.mod
--- sock.h 2011-04-14 14:58:03.000000000 +0900
+++ sock.h.mod 2011-04-21 15:30:07.000000000 +0900
@@ -434,9 +434,12 @@
/*
* Compute minimal free write space needed to queue new packets.
*/
+
+extern int sysctl_tcp_lowat;
+
static inline int sk_stream_min_wspace(struct sock *sk)
{
- return sk->sk_wmem_queued / 2;
+ return sk->sk_wmem_queued >> sysctl_tcp_lowat;
}

static inline int sk_stream_wspace(struct sock *sk)
#
# diff -urN sysctl_net_core.c sysctl_net_core.c.mod
--- sysctl_net_core.c 2011-04-14 14:57:10.000000000 +0900
+++ sysctl_net_core.c.mod 2011-04-04 21:09:48.000000000 +0900
@@ -30,6 +30,7 @@
extern u32 sysctl_xfrm_aevent_rseqth;
extern int sysctl_xfrm_larval_drop;
extern u32 sysctl_xfrm_acq_expires;
+extern int sysctl_tcp_lowat;
#endif

ctl_table core_table[] = {
@@ -151,6 +152,14 @@
.proc_handler = &proc_dointvec
},
#endif /* CONFIG_XFRM */
+ {
+ .ctl_name = NET_CORE_TCP_LOWAT,
+ .procname = "tcp_lowat",
+ .data = &sysctl_tcp_lowat,
+ .maxlen = sizeof(int),
+ .mode = 0644,
+ .proc_handler = &proc_dointvec
+ },
#endif /* CONFIG_NET */
{
.ctl_name = NET_CORE_SOMAXCONN,
#
--------------------------------------------------

------------------------------------------
Jun.Kondo
ITOCHU TECHNO-SOLUTIONS Corporation(CTC)
tel:+81-3-6238-6607
fax:+81-3-5226-2369
------------------------------------------
