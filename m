Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0DQSze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0DQSzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:55:32 -0400
Message-ID: <4BCA0421.4010106@redhat.com>
Date: Sat, 17 Apr 2010 21:55:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Try using new kvm clock msrs
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <1271356648-5108-3-git-send-email-glommer@redhat.com> <1271356648-5108-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-4-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 09:37 PM, Glauber Costa wrote:
> We now added a new set of clock-related msrs in replacement of the old
> ones. In theory, we could just try to use them and get a return value
> indicating they do not exist, due to our use of kvm_write_msr_save.
>
> However, kvm clock registration happens very early, and if we ever
> try to write to a non-existant MSR, we raise a lethal #GP, since our
> idt handlers are not in place yet.
>
> So this patch tests for a cpuid feature exported by the host to
> decide which set of msrs are supported.
>
>
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 0cffb96..a32710a 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -16,6 +16,10 @@
>   #define KVM_FEATURE_CLOCKSOURCE		0
>   #define KVM_FEATURE_NOP_IO_DELAY	1
>   #define KVM_FEATURE_MMU_OP		2
> +/* We could just try to use new msr values, but they are queried very early,
> + * kernel does not have idt handlers yet, and failures are fatal */
> +#define KVM_FEATURE_CLOCKSOURCE2	3
>    

This comment has no place in a header that's oriented to userspace.  
Instead, it's better to document what this bit exposes.

>
>   static int kvmclock = 1;
> +static int kvm_use_new_msrs = 0;
>    

Instead of this and all those if ()s all over the place, you can define 
variables for the MSR indices.  Set them up on initialization, the rest 
of the code just looks them up.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

