Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0KSI52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:57:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49870 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0KSI51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:57:27 -0500
Message-ID: <4CE63CF4.80502@cn.fujitsu.com>
Date: Fri, 19 Nov 2010 17:01:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/6] KVM: MMU: fix forgot flush tlbs on sync_page path
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 16:57:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 16:57:46,
	Serialize complete at 2010-11-19 16:57:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should flush all tlbs after drop spte on sync_page path since:

Quote from Avi:
| sync_page
| drop_spte
| kvm_mmu_notifier_invalidate_page
| kvm_unmap_rmapp
| spte doesn't exist -> no flush
| page is freed
| guest can write into freed page? 

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 590bf12..ca0e5e8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -786,6 +786,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
 			drop_spte(vcpu->kvm, &sp->spt[i], nonpresent);
+			kvm_flush_remote_tlbs(vcpu->kvm);
 			continue;
 		}
 
-- 
1.7.0.4
