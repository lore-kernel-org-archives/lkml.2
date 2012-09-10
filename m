Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2IJIfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2IJIfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:35:07 -0400
Message-ID: <504DA637.4060307@redhat.com>
Date: Mon, 10 Sep 2012 11:35:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: fix release error page
References: <5049908A.7070501@linux.vnet.ibm.com> <504990BC.3010703@linux.vnet.ibm.com>
In-Reply-To: <504990BC.3010703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 09:14 AM, Xiao Guangrong wrote:
> This bug was triggered:
> [ 4220.198458] BUG: unable to handle kernel paging request at fffffffffffffffe
> [ 4220.203907] IP: [<ffffffff81104d85>] put_page+0xf/0x34
> ......
> [ 4220.237326] Call Trace:
> [ 4220.237361]  [<ffffffffa03830d0>] kvm_arch_destroy_vm+0xf9/0x101 [kvm]
> [ 4220.237382]  [<ffffffffa036fe53>] kvm_put_kvm+0xcc/0x127 [kvm]
> [ 4220.237401]  [<ffffffffa03702bc>] kvm_vcpu_release+0x18/0x1c [kvm]
> [ 4220.237407]  [<ffffffff81145425>] __fput+0x111/0x1ed
> [ 4220.237411]  [<ffffffff8114550f>] ____fput+0xe/0x10
> [ 4220.237418]  [<ffffffff81063511>] task_work_run+0x5d/0x88
> [ 4220.237424]  [<ffffffff8104c3f7>] do_exit+0x2bf/0x7ca
> 
> The test case:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <pthread.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/ioctl.h>
> #include <sys/mman.h>
> 
> #include <linux/kvm.h>
> 
> #define die(fmt, args...)	do {	\
> 	printf(fmt, ##args);		\
> 	exit(-1);} while (0)
> 
> static int create_vm(void)
> {
> 	int sys_fd, vm_fd;
> 
> 	sys_fd = open("/dev/kvm", O_RDWR);
> 	if (sys_fd < 0)
> 		die("open /dev/kvm fail.\n");
> 
> 	vm_fd = ioctl(sys_fd, KVM_CREATE_VM, 0);
> 	if (vm_fd < 0)
> 		die("KVM_CREATE_VM fail.\n");
> 
> 	return vm_fd;
> }
> 
> static int create_vcpu(int vm_fd)
> {
> 	int vcpu_fd;
> 
> 	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> 	if (vcpu_fd < 0)
> 		die("KVM_CREATE_VCPU ioctl.\n");
> 	printf("Create vcpu.\n");
> 	return vcpu_fd;
> }
> 
> static void *vcpu_thread(void *arg)
> {
> 	int vm_fd = (int)(long)arg;
> 
> 	create_vcpu(vm_fd);
> 	return NULL;
> }
> 
> int main(int argc, char *argv[])
> {
> 	pthread_t thread;
> 	int vm_fd;
> 
> 	(void)argc;
> 	(void)argv;
> 
> 	vm_fd = create_vm();
> 	pthread_create(&thread, NULL, vcpu_thread, (void *)(long)vm_fd);
> 	printf("Exit.\n");
> 	return 0;
> }
> 
> It caused by release kvm->arch.ept_identity_map_addr which is the
> error page.
> 
> The parent thread can send KILL signal to the vcpu thread when it was
> exiting which stops faulting pages and potentially allocating memory.
> So gfn_to_pfn/gfn_to_page may fail at this time
> 
> Fixed by checking the page before it is used
> 

Thanks, applied to master for 3.6.


-- 
error compiling committee.c: too many arguments to function
