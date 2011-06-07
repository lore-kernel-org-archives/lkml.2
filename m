Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1FGM54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:57:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab1FGM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:57:54 -0400
Message-ID: <4DEE20CA.90206@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 20:59:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 03/15] KVM: x86: avoid unnecessarily guest page table walking
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:57:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:57:36,
	Serialize complete at 2011-06-07 20:57:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already get the guest physical address, so use it to read guest data
directly to avoid walking guest page table again

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 694538a..8be9ff6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3930,8 +3930,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto mmio;
 
-	if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
-	    == X86EMUL_CONTINUE)
+	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
 mmio:
-- 
1.7.4.4

