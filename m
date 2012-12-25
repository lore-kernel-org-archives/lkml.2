Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2LYAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 19:55:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:54667 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2LYAzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 19:55:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,349,1355126400"; 
   d="scan'208";a="269555745"
Subject: [PATCH] Bluetooth: fix the oops due to conn->hcon == NULL in
 shutdown case
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: gustavo@padovan.org, marcel@holtmann.org, johan.hedberg@gmail.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Dec 2012 18:04:17 +0800
Message-ID: <1356429857.25456.4.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meet one panic issue as below stack:
<1>[11340.226404] BUG: unable to handle kernel NULL pointer dereference at 00000008
<4>[11340.226619] EIP is at __sco_sock_close+0xe8/0x1a0
<4>[11340.226629] EAX: f063a740 EBX: 00000000 ECX: f58f4544 EDX: 00000000
<4>[11340.226640] ESI: dec83e00 EDI: 5f9a081f EBP: e0fdff38 ESP: e0fdff1c
<0>[11340.226674] Stack:
<4>[11340.226682]  c184db87 c1251028 dec83e00 e0fdff38 c1754aef dec83e00 00000000 e0fdff5c
<4>[11340.226718]  c184f587 e0fdff64 e0fdff68 5f9a081f e0fdff5c c1751852 d7813800 62262f10
<4>[11340.226752]  e0fdff70 c1753c00 00000000 00000001 0000000d e0fdffac c175425c 00000041
<0>[11340.226793] Call Trace:
<4>[11340.226813]  [<c184db87>] ? sco_sock_clear_timer+0x27/0x60
<4>[11340.226831]  [<c1251028>] ? local_bh_enable+0x68/0xd0
<4>[11340.226846]  [<c1754aef>] ? lock_sock_nested+0x4f/0x60
<4>[11340.226862]  [<c184f587>] sco_sock_shutdown+0x67/0xb0
<4>[11340.226879]  [<c1751852>] ? sockfd_lookup_light+0x22/0x80
<4>[11340.226897]  [<c1753c00>] sys_shutdown+0x30/0x60
<4>[11340.226912]  [<c175425c>] sys_socketcall+0x1dc/0x2a0
<4>[11340.226929]  [<c149ba78>] ? trace_hardirqs_on_thunk+0xc/0x10
<4>[11340.226944]  [<c18860f1>] syscall_call+0x7/0xb
<4>[11340.226960]  [<c1880000>] ? restore_cur+0x5e/0xd7
<0>[11340.226969] Code: <f0> ff 4b 08 0f 94 c0 84 c0 74 20 80 7b 19 01 74 2f b8 0a 00 00

Disassemble the code:
base address of __sco_sock_close is 0xc184f410
0xc184f4f8 <+232>:   lock decl 0x8(%ebx) < == crash here, ebx is 0x0,

the related source code is:
(gdb) l *0xc184f4f8
0xc184f4f8 is in __sco_sock_close (arch/x86/include/asm/atomic.h:123)
119     static inline int atomic_dec_and_test(atomic_t *v)
123             asm volatile(LOCK_PREFIX "decl %0; sete %1"

The whole call stack is:
sys_shutdown()
  sco_sock_shutdown()
    __sco_sock_close()
      hci_conn_put()
        atomic_dec_and_test()

Due to the conn->hcon is NULL, and the member hcon->refcnt is at offset 0x8,
so "BUG: unable to handle kernel NULL pointer dereference at 00000008"
appears.

Here fix it that adding the condition if conn->hcon is NULL, just like
in sco_chan_del().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 net/bluetooth/sco.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 531a93d..190f70c 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -355,8 +355,10 @@ static void __sco_sock_close(struct sock *sk)
 		if (sco_pi(sk)->conn) {
 			sk->sk_state = BT_DISCONN;
 			sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
-			hci_conn_put(sco_pi(sk)->conn->hcon);
-			sco_pi(sk)->conn->hcon = NULL;
+			if (sco_pi(sk)->conn->hcon) {
+				hci_conn_put(sco_pi(sk)->conn->hcon);
+				sco_pi(sk)->conn->hcon = NULL;
+			}
 		} else
 			sco_chan_del(sk, ECONNRESET);
 		break;
-- 
1.7.0.4



