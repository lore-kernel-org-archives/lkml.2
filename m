Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1H3Cfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:35:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1H3Cfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:35:37 -0400
Message-ID: <4E5C4CFE.20307@cn.fujitsu.com>
Date: Tue, 30 Aug 2011 10:37:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 10/11] KVM: MMU: fix detecting misaligned accessed
References: <4E5C4C20.3000403@cn.fujitsu.com>
In-Reply-To: <4E5C4C20.3000403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:34:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:34:38,
	Serialize complete at 2011-08-30 10:34:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, we only modify the last one byte of a pte to update status bit,
for example, clear_bit is used to clear r/w bit in linux kernel and 'andb'
instruction is used in this function, in this case, kvm_mmu_pte_write will
treat it as misaligned access, and the shadow page table is zapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cfe24fe..adaa160 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3601,6 +3601,14 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 
 	offset = offset_in_page(gpa);
 	pte_size = sp->role.cr4_pae ? 8 : 4;
+
+	/*
+	 * Sometimes, the OS only writes the last one bytes to update status
+	 * bits, for example, in linux, andb instruction is used in clear_bit().
+	 */
+	if (!(offset & (pte_size - 1)) && bytes == 1)
+		return false;
+
 	misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 	misaligned |= bytes < 4;
 
-- 
1.7.5.4

