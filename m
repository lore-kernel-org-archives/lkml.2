Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1AEJiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:38:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1AEJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:38:10 -0500
Message-ID: <4D243C05.7060307@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 17:38:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: send IPI to vcpu only when it's in guest mode
References: <4D243B95.3070203@cn.fujitsu.com>
In-Reply-To: <4D243B95.3070203@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 17:37:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 17:37:50,
	Serialize complete at 2011-01-05 17:37:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can interrupt the vcpu only when it's running in guest mode
to reduce IPI.

It looks like only ia64 and x86 need to send IPI to other vcpus, so
i only add the implementation of 'vcpu->guest_mode' in ia64, but i
don't know ia64 well, please point out the right way for me if the
implementation is incorrect

And ia64 is not tested since i don't have ia64 box

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 ++
 virt/kvm/kvm_main.c      |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 70d224d..15c11b2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -662,6 +662,7 @@ again:
 		goto vcpu_run_fail;
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	atomic_set(&vcpu->guest_mode, 1);
 	kvm_guest_enter();
 
 	/*
@@ -683,6 +684,7 @@ again:
 	 */
 	barrier();
 	kvm_guest_exit();
+	atomic_set(&vcpu->guest_mode, 0);
 	preempt_enable();
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1b6cbb..6648c6e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -153,7 +153,8 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		if (kvm_make_check_request(req, vcpu))
 			continue;
 		cpu = vcpu->cpu;
-		if (cpus != NULL && cpu != -1 && cpu != me)
+		if (cpus != NULL && cpu != -1 && cpu != me &&
+		      atomic_read(&vcpu->guest_mode))
 			cpumask_set_cpu(cpu, cpus);
 	}
 	if (unlikely(cpus == NULL))
-- 
1.7.3.4

