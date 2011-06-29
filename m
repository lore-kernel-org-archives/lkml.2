Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1F2Ihz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1F2Ihu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:37:50 -0400
Message-ID: <4E0AE457.7010507@redhat.com>
Date: Wed, 29 Jun 2011 11:37:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/22] KVM: x86: abstract the operation for read/write
 emulation
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC78.6060000@cn.fujitsu.com>
In-Reply-To: <4E01FC78.6060000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:30 PM, Xiao Guangrong wrote:
> The operations of read emulation and write emulation are very similar, so we
> can abstract the operation of them, in larter patch, it is used to cleanup the
> same code
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/x86.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 72 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c29ef96..887714f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4056,6 +4056,78 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	return 1;
>   }
>
> +struct read_write_emulator_ops {
> +	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
> +				  int bytes);
> +	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
> +				  void *val, int bytes);
> +	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
> +			       int bytes, void *val);
> +	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
> +				    void *val, int bytes);
> +	bool write;
> +};


Interesting!

This structure combines two unrelated operations, though.  One is the 
internals of the iteration on a virtual address that is split to various 
physical addresses.  The other is the interaction with userspace on mmio 
exits.  They should be split, but I think it's fine to do it in a later 
patch.  This series is long enough already.

I was also annoyed by the duplication.  They way I thought of fixing it 
is having gva_to_gpa() return two gpas, and having the access function 
accept gpa vectors.  The reason was so that we can implemented locked 
cross-page operations (which we now emulate as unlocked writes).

But I think we can do without it, and instead emulated locked cross-page 
ops by stalling all other vcpus while we write, or by unmapping the 
pages involved.  It isn't pretty but it doesn't need to be fast since 
it's a very rare operation.  So I think we can go with your approach.

-- 
error compiling committee.c: too many arguments to function

