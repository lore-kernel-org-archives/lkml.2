Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1F2IYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1F2IYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:24:14 -0400
Message-ID: <4E0AE129.1070200@redhat.com>
Date: Wed, 29 Jun 2011 11:24:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/22] KVM: x86: introduce vcpu_gva_to_gpa to cleanup
 the code
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC5B.9040809@cn.fujitsu.com>
In-Reply-To: <4E01FC5B.9040809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:29 PM, Xiao Guangrong wrote:
> Introduce vcpu_gva_to_gpa to translate the gva to gpa, we can use it
> to cleanup the code between read emulation and write emulation
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/x86.c |   38 +++++++++++++++++++++++++++++---------
>   1 files changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb27be4..c29ef96 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3944,6 +3944,27 @@ out:
>   }
>   EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>
> +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
> +			   gpa_t *gpa, struct x86_exception *exception,
> +			   bool write)
> +{
> +	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +
> +	if (write)
> +		access |= PFERR_WRITE_MASK;

Needs fetch as well so NX/SMEP can work.

> +
> +	*gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);

-- 
error compiling committee.c: too many arguments to function

