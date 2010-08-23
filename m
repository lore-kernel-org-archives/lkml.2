Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0HWLLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:11:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52992 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0HWLLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DT2G2ts2GdCLQ+oFZPfJt9x1mLgi6NiwJbarGCp1cnVwV0TcQiLVzeM29Xx6NrXXS1
         /P0bv0JpPZPEvicUawpdUHDH9zdapWZByhAXqewDxGDDe9pyY9ftvCzExpozyPo/c64c
         icH/WUDvYrm8JPUb+I2HZh1NVI29EMzs7FzrY=
MIME-Version: 1.0
In-Reply-To: <4C724D13.6000807@redhat.com>
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
	<4C724BDB.8020604@redhat.com>
	<4C724D13.6000807@redhat.com>
Date: Mon, 23 Aug 2010 19:11:11 +0800
Message-ID: <AANLkTi=7HdLqm-g1F+ezhDN4n+vPo2jAo2cgn-M6_wMJ@mail.gmail.com>
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
From: Xiaotian Feng <xtfeng@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 6:27 PM, Avi Kivity <avi@redhat.com> wrote:
>  On 08/23/2010 01:22 PM, Avi Kivity wrote:
>>
>>
>> I see a lot of soft lockups with this patchset:
>
> This is running the emulator.flat test case, with shadow paging.  This test
> triggers a lot (millions) of mmu mode switches.
>

Does following patch fix your issue?

Latest kvm mmu_shrink code rework makes kernel changes
kvm->arch.n_used_mmu_pages/
kvm->arch.n_max_mmu_pages at kvm_mmu_free_page/kvm_mmu_alloc_page,
which is called
by kvm_mmu_commit_zap_page. So the kvm->arch.n_used_mmu_pages or
kvm_mmu_available_pages(vcpu->kvm) is unchanged after kvm_mmu_commit_zap_page(),
This caused kvm_mmu_change_mmu_pages/__kvm_mmu_free_some_pages looping forever.
Moving kvm_mmu_commit_zap_page would make the while loop performs as normal.

---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f52a965..7e09a21 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1726,8 +1726,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm,
unsigned int goal_nr_mmu_pages)
                                            struct kvm_mmu_page, link);
                        kvm_mmu_prepare_zap_page(kvm, page,
                                                               &invalid_list);
+                       kvm_mmu_commit_zap_page(kvm, &invalid_list);
                }
-               kvm_mmu_commit_zap_page(kvm, &invalid_list);
                goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
        }

@@ -2976,9 +2976,9 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
                sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
                                  struct kvm_mmu_page, link);
                kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+               kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
                ++vcpu->kvm->stat.mmu_recycled;
        }
-       kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 }

 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)


> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
