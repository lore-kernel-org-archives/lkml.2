Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2IGGOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:14:30 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55779 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab2IGGO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:14:27 -0400
Message-ID: <504990BC.3010703@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 14:14:20 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: fix release error page
References: <5049908A.7070501@linux.vnet.ibm.com>
In-Reply-To: <5049908A.7070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090706-6102-0000-0000-000002311254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was triggered:
[ 4220.198458] BUG: unable to handle kernel paging request at fffffffffffffffe
[ 4220.203907] IP: [<ffffffff81104d85>] put_page+0xf/0x34
......
[ 4220.237326] Call Trace:
[ 4220.237361]  [<ffffffffa03830d0>] kvm_arch_destroy_vm+0xf9/0x101 [kvm]
[ 4220.237382]  [<ffffffffa036fe53>] kvm_put_kvm+0xcc/0x127 [kvm]
[ 4220.237401]  [<ffffffffa03702bc>] kvm_vcpu_release+0x18/0x1c [kvm]
[ 4220.237407]  [<ffffffff81145425>] __fput+0x111/0x1ed
[ 4220.237411]  [<ffffffff8114550f>] ____fput+0xe/0x10
[ 4220.237418]  [<ffffffff81063511>] task_work_run+0x5d/0x88
[ 4220.237424]  [<ffffffff8104c3f7>] do_exit+0x2bf/0x7ca

The test case:

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <fcntl.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#include <linux/kvm.h>

#define die(fmt, args...)	do {	\
	printf(fmt, ##args);		\
	exit(-1);} while (0)

static int create_vm(void)
{
	int sys_fd, vm_fd;

	sys_fd = open("/dev/kvm", O_RDWR);
	if (sys_fd < 0)
		die("open /dev/kvm fail.\n");

	vm_fd = ioctl(sys_fd, KVM_CREATE_VM, 0);
	if (vm_fd < 0)
		die("KVM_CREATE_VM fail.\n");

	return vm_fd;
}

static int create_vcpu(int vm_fd)
{
	int vcpu_fd;

	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
	if (vcpu_fd < 0)
		die("KVM_CREATE_VCPU ioctl.\n");
	printf("Create vcpu.\n");
	return vcpu_fd;
}

static void *vcpu_thread(void *arg)
{
	int vm_fd = (int)(long)arg;

	create_vcpu(vm_fd);
	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t thread;
	int vm_fd;

	(void)argc;
	(void)argv;

	vm_fd = create_vm();
	pthread_create(&thread, NULL, vcpu_thread, (void *)(long)vm_fd);
	printf("Exit.\n");
	return 0;
}

It caused by release kvm->arch.ept_identity_map_addr which is the
error page.

The parent thread can send KILL signal to the vcpu thread when it was
exiting which stops faulting pages and potentially allocating memory.
So gfn_to_pfn/gfn_to_page may fail at this time

Fixed by checking the page before it is used

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |   19 ++++++++++++++++---
 arch/x86/kvm/x86.c |   13 ++++++++++---
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 248c2b4..ccea20a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3590,6 +3590,7 @@ static void seg_setup(int seg)

 static int alloc_apic_access_page(struct kvm *kvm)
 {
+	struct page *page;
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;

@@ -3604,7 +3605,13 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;

-	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
+	page = gfn_to_page(kvm, 0xfee00);
+	if (is_error_page(page)) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	kvm->arch.apic_access_page = page;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
@@ -3612,6 +3619,7 @@ out:

 static int alloc_identity_pagetable(struct kvm *kvm)
 {
+	struct page *page;
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;

@@ -3627,8 +3635,13 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	if (r)
 		goto out;

-	kvm->arch.ept_identity_pagetable = gfn_to_page(kvm,
-			kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
+	page = gfn_to_page(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
+	if (is_error_page(page)) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	kvm->arch.ept_identity_pagetable = page;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8fba22..d44edaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5101,17 +5101,20 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 			!kvm_event_needs_reinjection(vcpu);
 }

-static void vapic_enter(struct kvm_vcpu *vcpu)
+static int vapic_enter(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct page *page;

 	if (!apic || !apic->vapic_addr)
-		return;
+		return 0;

 	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
+	if (is_error_page(page))
+		return -EFAULT;

 	vcpu->arch.apic->vapic_page = page;
+	return 0;
 }

 static void vapic_exit(struct kvm_vcpu *vcpu)
@@ -5418,7 +5421,11 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	}

 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	vapic_enter(vcpu);
+	r = vapic_enter(vcpu);
+	if (r) {
+		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+		return r;
+	}

 	r = 1;
 	while (r > 0) {
-- 
1.7.7.6

