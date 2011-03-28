Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1C1C3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:29:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1C1C3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:29:50 -0400
Message-ID: <4D8FF2D2.9070109@cn.fujitsu.com>
Date: Mon, 28 Mar 2011 10:30:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4D8FF287.1040300@cn.fujitsu.com>
In-Reply-To: <4D8FF287.1040300@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:28:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:28:18,
	Serialize complete at 2011-03-28 10:28:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplely return from kvm_mmu_pte_write path if no shadow page is
write-protected, than we can avoid to walk all shadow pages and hold
mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2841805..ccac6c4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3219,6 +3219,11 @@ static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 		set_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
 }
 
+static bool need_track_pte_changed(struct kvm_vcpu *vcpu)
+{
+	return !tdp_enabled || mmu_is_nested(vcpu);
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
 		       bool guest_initiated)
@@ -3233,6 +3238,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int level, npte, invlpg_counter, r, flooded = 0;
 	bool remote_flush, local_flush, zap_page;
 
+	if (!need_track_pte_changed(vcpu))
+		return;
+
 	zap_page = remote_flush = local_flush = false;
 	offset = offset_in_page(gpa);
 
-- 
1.7.4

