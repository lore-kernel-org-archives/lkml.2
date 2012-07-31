Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2GaKwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:52:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34068 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab2GaKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:52:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH] extend_brk and fixes to users of extend_brk (v1).
Date: Tue, 31 Jul 2012 06:42:53 -0400
Message-Id: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.5 I've added some patches that during boot-time and add more
entries to the P2M tree: http://lists.xen.org/archives/html/xen-devel/2012-04/msg01152.html
which worked great on all my machines. But there were some folks
who reported that it caused them at bootup to hit this:

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

The failure was that my patches depended on the __brk_base to be large.
On v3.5 due to some other patches (not sure which ones) the space is quite
large (around ~4MB) while in previous kernels its ~344kB. But depending
on the compiler to fix my mistake is not really the best way. So patch:

 [PATCH 2/3] xen/p2m: Reserve 4MB of _brk space for P2M leafs when

fixes this, while 
 [PATCH 1/3] xen/mmu/p2m: Check extend_brk for NULL

gets in line with the DMI code to check extend_brk for NULL, and lastly:

 [PATCH 3/3] x86: Let extend_brk return a NULL pointer instead of

makes extend_brk not do BUG_ON and instead just return NULL. This allows
us to handle the bootup issues more gracefully.

Note, I've also posted another variant of this:
http://lists.xen.org/archives/html/xen-devel/2012-07/msg01401.html
which Ian pointed out is a bit fragile.

Looking forward to your comments.
