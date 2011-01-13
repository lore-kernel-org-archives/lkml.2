Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1AMPoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1AMPoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:44:16 -0500
Message-ID: <4D2F1D49.8070807@redhat.com>
Date: Thu, 13 Jan 2011 17:42:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com> <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 05:22 PM, Joerg Roedel wrote:
> The vmexit path on SVM needs to restore the KERNEL_GS_BASE
> MSR in order to savely execute the NMI handler. Otherwise a
> pending NMI can occur after the STGI instruction and crash
> the machine.
> This makes it impossible to run perf and kvm in parallel on
> an AMD machine in a stable way.
>
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 25bd1bc..8b9bc72 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3637,6 +3637,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>
>   #ifdef CONFIG_X86_64
>   	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> +	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
>   #else
>   	loadsegment(fs, svm->host.fs);
>   #endif

Why would an NMI crash if MSR_KERNEL_GS_BASE is bad?

I see save_paranoid depends on MSR_GS_BASE (specifically its sign, which 
is bad for the new instructions that allow userspace to write gsbase), 
but not on MSR_KERNEL_GS_BASE.

-- 
error compiling committee.c: too many arguments to function

