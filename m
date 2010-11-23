Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0KWUln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:41:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51056 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0KWUlm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 23 Nov 2010 15:41:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [RFC PATCH] fix 32-bit PAE bootup of Xen PV guests.
Date: Tue, 23 Nov 2010 15:41:35 -0500
Message-Id: <1290544896-20754-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if you could help me out. The git commit
b40827fa7268fda8a62490728a61c2856f33830b ("x86-32, mm: Add an initial
page table for core bootstrapping") crashes 32-bit PAE Xen PV guests.

I am attaching an RFC patch that works around your patch, but honestly
I was wondering if there is a better way to make this work for 2.6.37?
Any recommendations?

Without this patch, a PV 32-bit PAE guest crashes during early bootup as
so:

mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
(XEN) d0:v0: unhandled page fault (ec=0003)
(XEN) Pagetable walk from c158901c:
(XEN)  L3[0x003] = 0000000025645001 00001645
(XEN)  L2[0x00a] = 00000000258ae067 00019086 
(XEN)  L1[0x189] = 0000000025589061 00001589
(XEN) domain_crash_sync called from entry.S (ff1d10d5)
(XEN) Domain 0 (vcpu#0) crashed on cpu#0:
(XEN) ----[ Xen-4.1-101123  x86_32p  debug=y  Not tainted ]----
(XEN) CPU:    0
(XEN) EIP:    e019:[<c151d371>]
(XEN) EFLAGS: 00000286   EM: 1   CONTEXT: pv guest
(XEN) eax: 01586001   ebx: 00000000   ecx: 00000000   edx: 00000000
(XEN) esi: c150cdc0   edi: c1511840   ebp: c14d5fa4   esp: c14d5f20
(XEN) cr0: 8005003b   cr4: 000026f0   cr3: 0028aca0   cr2: c158901c
(XEN) ds: e021   es: e021   fs: 00d8   gs: 0000   ss: e021   cs: e019
(XEN) Guest stack trace from esp=c14d5f20:
(XEN)    00000003 c151d371 0001e019 00010086 c14e09a4 c103b02d 00000000 0000000f
(XEN)    00000035 00000000 00000000 c14d5f65 00000000 205b0000 30202020 3030302e
(XEN)    c14d5fb4 c11a0020 c14df334 c14d5f78 c10073aa 00000000 00000000 c14df334
(XEN)    c14d5f94 c100651a 00000000 c154d230 c14df334 c14d5fa4 00000000 c154d230
(XEN)    c14df334 c14d5fbc c1518646 c143996d c139a010 c15180ab 18f8a000 c14d5fd4
(XEN)    c15180df 017b2000 00000000 017b2000 c154d230 c14d5ffc c151afd5 1fc98375
(XEN)    80000481 00040800 00000f62 00000001 00000000 d9076000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
(XEN)    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

