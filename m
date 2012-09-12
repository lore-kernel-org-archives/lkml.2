Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2ILXg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:36:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2ILXgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 103/108] xen/p2m: Fix one-off error in checking the P2M tree directory.
Date: Wed, 12 Sep 2012 16:29:41 -0700
Message-Id: <20120912232501.303947548@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 50e900417b8096939d12a46848f965e27a905e36 upstream.

We would traverse the full P2M top directory (from 0->MAX_DOMAIN_PAGES
inclusive) when trying to figure out whether we can re-use some of the
P2M middle leafs.

Which meant that if the kernel was compiled with MAX_DOMAIN_PAGES=512
we would try to use the 512th entry. Fortunately for us the p2m_top_index
has a check for this:

 BUG_ON(pfn >= MAX_P2M_PFN);

which we hit and saw this:

(XEN) domain_crash_sync called from entry.S
(XEN) Domain 0 (vcpu#0) crashed on cpu#0:
(XEN) ----[ Xen-4.1.2-OVM  x86_64  debug=n  Tainted:    C ]----
(XEN) CPU:    0
(XEN) RIP:    e033:[<ffffffff819cadeb>]
(XEN) RFLAGS: 0000000000000212   EM: 1   CONTEXT: pv guest
(XEN) rax: ffffffff81db5000   rbx: ffffffff81db4000   rcx: 0000000000000000
(XEN) rdx: 0000000000480211   rsi: 0000000000000000   rdi: ffffffff81db4000
(XEN) rbp: ffffffff81793db8   rsp: ffffffff81793d38   r8:  0000000008000000
(XEN) r9:  4000000000000000   r10: 0000000000000000   r11: ffffffff81db7000
(XEN) r12: 0000000000000ff8   r13: ffffffff81df1ff8   r14: ffffffff81db6000
(XEN) r15: 0000000000000ff8   cr0: 000000008005003b   cr4: 00000000000026f0
(XEN) cr3: 0000000661795000   cr2: 0000000000000000

Fixes-Oracle-Bug: 14570662
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -599,7 +599,7 @@ bool __init early_can_reuse_p2m_middle(u
 	if (p2m_index(set_pfn))
 		return false;
 
-	for (pfn = 0; pfn <= MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
+	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
 		topidx = p2m_top_index(pfn);
 
 		if (!p2m_top[topidx])


