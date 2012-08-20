Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2HTD7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:59:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2HTD7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:59:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 07/46] xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.
Date: Sun, 19 Aug 2012 20:58:43 -0700
Message-Id: <20120820035833.292438346@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 5bc6f9888db5739abfa0cae279b4b442e4db8049 upstream.

When we release pages back during bootup:

Freeing  9d-100 pfn range: 99 pages freed
Freeing  9cf36-9d0d2 pfn range: 412 pages freed
Freeing  9f6bd-9f6bf pfn range: 2 pages freed
Freeing  9f714-9f7bf pfn range: 171 pages freed
Freeing  9f7e0-9f7ff pfn range: 31 pages freed
Freeing  9f800-100000 pfn range: 395264 pages freed
Released 395979 pages of unused memory

We then try to populate those pages back. In the P2M tree however
the space for those leafs must be reserved - as such we use extend_brk.
We reserve 8MB of _brk space, which means we can fit over
1048576 PFNs - which is more than we should ever need.

Without this, on certain compilation of the kernel we would hit:

(XEN) domain_crash_sync called from entry.S
(XEN) CPU:    0
(XEN) RIP:    e033:[<ffffffff818aad3b>]
(XEN) RFLAGS: 0000000000000206   EM: 1   CONTEXT: pv guest
(XEN) rax: ffffffff81a7c000   rbx: 000000000000003d   rcx: 0000000000001000
(XEN) rdx: ffffffff81a7b000   rsi: 0000000000001000   rdi: 0000000000001000
(XEN) rbp: ffffffff81801cd8   rsp: ffffffff81801c98   r8:  0000000000100000
(XEN) r9:  ffffffff81a7a000   r10: 0000000000000001   r11: 0000000000000003
(XEN) r12: 0000000000000004   r13: 0000000000000004   r14: 000000000000003d
(XEN) r15: 00000000000001e8   cr0: 000000008005003b   cr4: 00000000000006f0
(XEN) cr3: 0000000125803000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
(XEN) Guest stack trace from rsp=ffffffff81801c98:

.. which is extend_brk hitting a BUG_ON.

Interestingly enough, most of the time we are not going to hit this
b/c the _brk space is quite large (v3.5):
 ffffffff81a25000 B __brk_base
 ffffffff81e43000 B __brk_limit
= ~4MB.

vs earlier kernels (with this back-ported), the space is smaller:
 ffffffff81a25000 B __brk_base
 ffffffff81a7b000 B __brk_limit
= 344 kBytes.

where we would certainly hit this and hit extend_brk.

Note that git commit c3d93f880197953f86ab90d9da4744e926b38e33
(xen: populate correct number of pages when across mem boundary (v2))
exposed this bug).

[v1: Made it 8MB of _brk space instead of 4MB per Jan's suggestion]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -194,6 +194,11 @@ RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MA
  * boundary violation will require three middle nodes. */
 RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
 
+/* When we populate back during bootup, the amount of pages can vary. The
+ * max we have is seen is 395979, but that does not mean it can't be more.
+ * But some machines can have 3GB I/O holes even. So lets reserve enough
+ * for 4GB of I/O and E820 holes. */
+RESERVE_BRK(p2m_populated, PMD_SIZE * 4);
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);


