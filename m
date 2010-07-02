Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0GBEm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:42:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60440 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GBEmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:42:24 -0400
Message-ID: <4C2D6D4B.5060309@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 12:38:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: IOAPIC: only access APIC registers one dword at a time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOAPIC spec says:

When accessing these registers, accesses must be done one dword at a time.
For example, software should never access byte 2 from the Data register before
accessing bytes 0 and 1. The hardware will not attempt to recover from a bad
programming model in this case.

So, this patch removes other width access

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 virt/kvm/ioapic.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1149c60..f96816f 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -306,14 +306,10 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 	spin_unlock(&ioapic->lock);
 
 	switch (len) {
-	case 8:
-		*(u64 *) val = result;
-		break;
-	case 1:
-	case 2:
 	case 4:
-		memcpy(val, (char *)&result, len);
+		*(u32 *) val = result;
 		break;
+
 	default:
 		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
 	}
@@ -332,7 +328,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		     (void*)addr, len, val);
 	ASSERT(!(addr & 0xf));	/* check alignment */
 
-	if (len == 4 || len == 8)
+	if (len == 4)
 		data = *(u32 *) val;
 	else {
 		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
-- 
1.6.1.2

