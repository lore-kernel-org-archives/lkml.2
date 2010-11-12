Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0KLGmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:42:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0KLGms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:42:48 -0500
Message-ID: <4CDCE2E5.6000401@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 14:47:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/5] KVM: MMU: clear apfs if page state is changed
References: <4CDCE2B0.7000601@cn.fujitsu.com>
In-Reply-To: <4CDCE2B0.7000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 14:43:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 14:43:13,
	Serialize complete at 2010-11-12 14:43:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CR0.PG is changed, the page fault cann't be avoid when the prefault address
is accessed later

And it also fix a bug: it can retry a page enabled #PF in page disabled context
if mmu is shadow page

This idear is from Gleb Natapov

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc29223..c071d73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -525,6 +525,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 
+	if ((cr0 ^ old_cr0) & X86_CR0_PG)
+		kvm_clear_async_pf_completion_queue(vcpu);
+
 	if ((cr0 ^ old_cr0) & update_bits)
 		kvm_mmu_reset_context(vcpu);
 	return 0;
-- 
1.7.0.4

