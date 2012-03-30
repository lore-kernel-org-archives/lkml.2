Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966220Ab2C3Vhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:37:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41961 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966112Ab2C3VcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:21 -0400
X-Sasl-enc: SZ4Y1FQHa2By5u5ymP8wJ4cRdV02k9S+ifNUi6AVtqwr 1333143140
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:58 2012
Message-Id: <20120330194858.415834241@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Evans <matt@ozlabs.org>,
        Indan Zupancic <indan@nul.nu>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 160/175] net: bpf_jit: fix BPF_S_LDX_B_MSH compilation
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit dc72d99dabb870ca5bd6d9fff674be853bb4a88d ]

Matt Evans spotted that x86 bpf_jit was incorrectly handling negative
constant offsets in BPF_S_LDX_B_MSH instruction.

We need to abort JIT compilation like we do in common_load so that
filter uses the interpreter code and can call __load_pointer()

Reference: http://lists.openwall.net/netdev/2011/07/19/11

Thanks to Indan Zupancic to bring back this issue.

Reported-by: Matt Evans <matt@ozlabs.org>
Reported-by: Indan Zupancic <indan@nul.nu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -475,8 +475,10 @@ void bpf_jit_compile(struct sk_filter *f
 			case BPF_S_LD_W_ABS:
 				func = sk_load_word;
 common_load:			seen |= SEEN_DATAREF;
-				if ((int)K < 0)
+				if ((int)K < 0) {
+					/* Abort the JIT because __load_pointer() is needed. */
 					goto out;
+				}
 				t_offset = func - (image + addrs[i]);
 				EMIT1_off32(0xbe, K); /* mov imm32,%esi */
 				EMIT1_off32(0xe8, t_offset); /* call */
@@ -489,14 +491,8 @@ common_load:			seen |= SEEN_DATAREF;
 				goto common_load;
 			case BPF_S_LDX_B_MSH:
 				if ((int)K < 0) {
-					if (pc_ret0 > 0) {
-						/* addrs[pc_ret0 - 1] is the start address */
-						EMIT_JMP(addrs[pc_ret0 - 1] - addrs[i]);
-						break;
-					}
-					CLEAR_A();
-					EMIT_JMP(cleanup_addr - addrs[i]);
-					break;
+					/* Abort the JIT because __load_pointer() is needed. */
+					goto out;
 				}
 				seen |= SEEN_DATAREF | SEEN_XREG;
 				t_offset = sk_load_byte_msh - (image + addrs[i]);


