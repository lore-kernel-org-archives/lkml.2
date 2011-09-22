Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1IVIxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:53:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62111 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1IVIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:52:57 -0400
Message-ID: <4E7AF7EE.70604@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:55:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 04/11] KVM: x86: cleanup port-in/port-out emulated
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:51:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:51:36,
	Serialize complete at 2011-09-22 16:51:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the same code between emulator_pio_in_emulated and
emulator_pio_out_emulated

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   59 ++++++++++++++++++++++-----------------------------
 1 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 727a6af..a69a3e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4327,32 +4327,24 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 	return r;
 }
 
-
-static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
-				    int size, unsigned short port, void *val,
-				    unsigned int count)
+static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
+			       unsigned short port, void *val,
+			       unsigned int count, bool in)
 {
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-
-	if (vcpu->arch.pio.count)
-		goto data_avail;
-
-	trace_kvm_pio(0, port, size, count);
+	trace_kvm_pio(!in, port, size, count);
 
 	vcpu->arch.pio.port = port;
-	vcpu->arch.pio.in = 1;
+	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count  = count;
 	vcpu->arch.pio.size = size;
 
 	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
-	data_avail:
-		memcpy(val, vcpu->arch.pio_data, size * count);
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
-	vcpu->run->io.direction = KVM_EXIT_IO_IN;
+	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
 	vcpu->run->io.count = count;
@@ -4361,36 +4353,37 @@ static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
 	return 0;
 }
 
-static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
-				     int size, unsigned short port,
-				     const void *val, unsigned int count)
+static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
+				    int size, unsigned short port, void *val,
+				    unsigned int count)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	int ret;
 
-	trace_kvm_pio(1, port, size, count);
-
-	vcpu->arch.pio.port = port;
-	vcpu->arch.pio.in = 0;
-	vcpu->arch.pio.count = count;
-	vcpu->arch.pio.size = size;
-
-	memcpy(vcpu->arch.pio_data, val, size * count);
+	if (vcpu->arch.pio.count)
+		goto data_avail;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
+	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
+	if (ret) {
+data_avail:
+		memcpy(val, vcpu->arch.pio_data, size * count);
 		vcpu->arch.pio.count = 0;
 		return 1;
 	}
 
-	vcpu->run->exit_reason = KVM_EXIT_IO;
-	vcpu->run->io.direction = KVM_EXIT_IO_OUT;
-	vcpu->run->io.size = size;
-	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
-	vcpu->run->io.count = count;
-	vcpu->run->io.port = port;
-
 	return 0;
 }
 
+static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
+				     int size, unsigned short port,
+				     const void *val, unsigned int count)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	memcpy(vcpu->arch.pio_data, val, size * count);
+	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+}
+
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	return kvm_x86_ops->get_segment_base(vcpu, seg);
-- 
1.7.5.4

