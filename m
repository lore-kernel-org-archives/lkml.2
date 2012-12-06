Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2LFOj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:39:29 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:53217 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2LFOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:39:26 -0500
From: Nicolas Schichan <nschichan@freebox.fr>
To: mgherzan@gmail.com, rmk+kernel@arm.linux.org.uk
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: net: bpf_jit_32: fix sp-relative load/stores offsets.
Date: Thu,  6 Dec 2012 15:38:32 +0100
Message-Id: <1354804718-1662-2-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset must be multiplied by 4 to be sure to access the correct
32bit word in the stack scratch space.

For instance, a store at scratch memory cell #1 was generating the
following:

st	r4, [sp, #1]

While the correct code for this is:

st	r4, [sp, #4]

To reproduce the bug (assuming your system has a NIC with the mac
address 52:54:00:12:34:56):

echo 0 > /proc/sys/net/core/bpf_jit_enable
tcpdump -ni eth0 "ether[1] + ether[2] - ether[3] * ether[4] - ether[5] \
	== -0x3AA" # this will capture packets as expected

echo 1 > /proc/sys/net/core/bpf_jit_enable
tcpdump -ni eth0 "ether[1] + ether[2] - ether[3] * ether[4] - ether[5] \
	== -0x3AA" # this will not.

This bug was present since the original inclusion of bpf_jit for ARM
(ddecdfce: ARM: 7259/3: net: JIT compiler for packet filters).

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/arm/net/bpf_jit_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index a64d349..b6f305e 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -42,7 +42,7 @@
 #define r_skb_hl	ARM_R8
 
 #define SCRATCH_SP_OFFSET	0
-#define SCRATCH_OFF(k)		(SCRATCH_SP_OFFSET + (k))
+#define SCRATCH_OFF(k)		(SCRATCH_SP_OFFSET + 4 * (k))
 
 #define SEEN_MEM		((1 << BPF_MEMWORDS) - 1)
 #define SEEN_MEM_WORD(k)	(1 << (k))
-- 
1.7.5.4

