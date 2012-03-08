Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2CHJpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:45:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2CHJpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:45:31 -0500
Message-ID: <4F587FB6.1070803@redhat.com>
Date: Thu, 08 Mar 2012 11:45:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add paging gcc optimization
References: <1331150569.25969.1.camel@offbook>
In-Reply-To: <1331150569.25969.1.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 10:02 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> Since most guests will have paging enabled for memory management, add likely() and unlikely()
> optimizations around is_paging() checks.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kvm/mmu.c |    6 +++---
>  arch/x86/kvm/svm.c |    6 +++---
>  arch/x86/kvm/vmx.c |   16 ++++++++--------
>  arch/x86/kvm/x86.c |    8 ++++----
>  4 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4cb1642..84f1e95 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3320,7 +3320,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  
> -	if (!is_paging(vcpu)) {
> +	if (unlikely(!is_paging(vcpu))) {
>

Just change is_paging itself():

 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-    return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
+    return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
  }

-- 
error compiling committee.c: too many arguments to function

