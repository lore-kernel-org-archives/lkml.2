Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1GNL3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:29:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1GNL3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:29:41 -0400
Message-ID: <4E1ED320.4080600@redhat.com>
Date: Thu, 14 Jul 2011 14:29:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: SVM: Use host_vmcb_pa for vmload and vmsave
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1310571145-28930-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 06:32 PM, Joerg Roedel wrote:
> This saves copying over the vmload/vmsave switched part from
> the host to the guest vmcb later.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |    7 ++++++-
>   1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 3d5990f..dc703ac 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3704,9 +3704,13 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>
>   		/* Enter guest mode */
>   		"push %%"R"ax \n\t"
> -		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
> +		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
>   		__ex(SVM_VMLOAD) "\n\t"
> +		"mov (%%"R"sp), %%"R"ax\n\t"
> +		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
>   		__ex(SVM_VMRUN) "\n\t"
> +		"mov (%%"R"sp), %%"R"ax\n\t"
> +		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
>   		__ex(SVM_VMSAVE) "\n\t"
>   		"pop %%"R"ax \n\t"
>

Okay, so the plan is to split L2 state between ->vmcb and ->host_vmcb?  
In that case my suggestion for patch 1 doesn't apply.  But the name 
still is confusing.  If we don't find a better one, I want a fat comment 
explaining how state is split.

(would be good to have documentation for the overall strategy of nsvm, 
like we have for nvmx and nmmu).

-- 
error compiling committee.c: too many arguments to function

