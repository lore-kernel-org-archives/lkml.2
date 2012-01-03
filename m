Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2ACWhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:37:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2ACWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:35 2012
Message-Id: <20120103223035.624344514@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Markus=20K=F6tter?= <nepenthesdev@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [51/67] net: bpf_jit: fix an off-one bug in x86_64 cond jump target
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Markus Kötter <nepenthesdev@gmail.com>

[ Upstream commit a03ffcf873fe0f2565386ca8ef832144c42e67fa ]

x86 jump instruction size is 2 or 5 bytes (near/long jump), not 2 or 6
bytes.

In case a conditional jump is followed by a long jump, conditional jump
target is one byte past the start of target instruction.

Signed-off-by: Markus Kötter <nepenthesdev@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/net/bpf_jit_comp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -568,8 +568,8 @@ cond_branch:			f_offset = addrs[i + filt
 					break;
 				}
 				if (filter[i].jt != 0) {
-					if (filter[i].jf)
-						t_offset += is_near(f_offset) ? 2 : 6;
+					if (filter[i].jf && f_offset)
+						t_offset += is_near(f_offset) ? 2 : 5;
 					EMIT_COND_JMP(t_op, t_offset);
 					if (filter[i].jf)
 						EMIT_JMP(f_offset);


