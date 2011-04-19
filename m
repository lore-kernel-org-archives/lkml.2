Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1DSUVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:21:38 -0400
Received: from kroah.org ([198.145.64.141]:35705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab1DSURj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.290532779@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [57/70] powerpc: Fix oops if scan_dispatch_log is called too early
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 84ffae55af79d7b8834fd0c08d0d1ebf2c77f91e upstream.

We currently enable interrupts before the dispatch log for the boot
cpu is setup. If a timer interrupt comes in early enough we oops in
scan_dispatch_log:

Unable to handle kernel paging request for data at address 0x00000010

...

.scan_dispatch_log+0xb0/0x170
.account_system_vtime+0xa0/0x220
.irq_enter+0x88/0xc0
.do_IRQ+0x48/0x230

The patch below adds a check to scan_dispatch_log to ensure the
dispatch log has been allocated.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/time.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -229,6 +229,9 @@ static u64 scan_dispatch_log(u64 stop_tb
 	u64 stolen = 0;
 	u64 dtb;
 
+	if (!dtl)
+		return 0;
+
 	if (i == vpa->dtl_idx)
 		return 0;
 	while (i < vpa->dtl_idx) {


