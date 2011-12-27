Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1L0LU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 06:20:59 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42968 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1L0LU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 06:20:56 -0500
Message-ID: <4EF9AA59.7050003@oss.ntt.co.jp>
Date: Tue, 27 Dec 2011 20:22:01 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1324975139-8836-1-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/27 17:38), Liu Ping Fan wrote:
> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> 
> Currently, vcpu can be destructed only when kvm instance destroyed.
> Change this to vcpu's destruction before kvm instance, so vcpu MUST
> and CAN be destroyed before kvm's destroy.

I really don't understand why this big change can be justified by only
3 lines.

> 
> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> ---
>   arch/x86/kvm/i8254.c     |   10 +++--
>   arch/x86/kvm/i8259.c     |   17 +++++--
>   arch/x86/kvm/x86.c       |   53 +++++++++++-----------
>   include/linux/kvm_host.h |   20 +++-----
>   virt/kvm/irq_comm.c      |    6 ++-
>   virt/kvm/kvm_main.c      |  110 +++++++++++++++++++++++++++++++++++-----------
>   6 files changed, 140 insertions(+), 76 deletions(-)
> 

You are introducing kvm_arch_vcpu_zap().

Then, apart from the "zap" naming issue I mentioned last time,
what about other architectures than x86?


> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 900c763..b88d418d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -117,6 +117,7 @@ enum {
> 
>   struct kvm_vcpu {
>   	struct kvm *kvm;
> +	struct list_head list;
>   #ifdef CONFIG_PREEMPT_NOTIFIERS
>   	struct preempt_notifier preempt_notifier;
>   #endif
> @@ -251,12 +252,14 @@ struct kvm {
>   	struct mm_struct *mm; /* userspace tied to this vm */
>   	struct kvm_memslots *memslots;
>   	struct srcu_struct srcu;
> +	struct srcu_struct srcu_vcpus;
> +

Another srcu.  This alone is worth explaining in the changelog IMO.

	Takuya

>   #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>   	u32 bsp_vcpu_id;
>   #endif
> -	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> +	struct list_head vcpus;
>   	atomic_t online_vcpus;
> -	int last_boosted_vcpu;
> +	int last_boosted_vcpu_id;
>   	struct list_head vm_list;
>   	struct mutex lock;
>   	struct kvm_io_bus *buses[KVM_NR_BUSES];
