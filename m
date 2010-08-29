Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0H2JQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:16:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab0H2JQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:16:34 -0400
Message-ID: <4C7A256E.3090307@redhat.com>
Date: Sun, 29 Aug 2010 12:16:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: support disable/enable mmu audit dynamicly
References: <4C78FA00.8090606@cn.fujitsu.com> <4C78FA5B.8070008@cn.fujitsu.com>
In-Reply-To: <4C78FA5B.8070008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/28/2010 03:00 PM, Xiao Guangrong wrote:
> Add the debugfs file named 'mmu-debug', we can disable/enable mmu audit by
> this file:
>
> enable:
> echo 1>  debugfs/kvm/mmu-debug
>
> disable:
> echo 0>  debugfs/kvm/mmu-debug


Better as a runtime rw module parameter perhaps?  At least it avoids the 
large debugfs callbacks.

Also, call it audit to preserve the name.


> This patch not change the logic
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/Kconfig       |    6 +
>   arch/x86/kvm/mmu.c         |  250 ++--------------------------------
>   arch/x86/kvm/mmu_debug.c   |  329 ++++++++++++++++++++++++++++++++++++++++++++

Please put the move to mmu_debug in a separate patch.

> +
> +static void mmu_debug_enable(void)
> +{
> +	int ret;
> +
> +	if (mmu_debug)
> +		return;
> +
> +	ret = register_trace_kvm_mmu_audit(kvm_mmu_audit, NULL);
> +	WARN_ON(ret);
> +
> +	mmu_debug = true;
> +}

Really neat use of tracepoints.

> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> index 3aab0f0..28a0e1f 100644
> --- a/arch/x86/kvm/mmutrace.h
> +++ b/arch/x86/kvm/mmutrace.h
> @@ -195,6 +195,25 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
>
>   	TP_ARGS(sp)
>   );
> +
> +TRACE_EVENT(
> +	kvm_mmu_audit,
> +	TP_PROTO(struct kvm_vcpu *vcpu, const char *msg),
> +	TP_ARGS(vcpu, msg),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm_vcpu *, vcpu)
> +		__field(const char *, msg)
> +	),

enum instead of char *, maybe something in userspace can make use of this.

> +
> +	TP_fast_assign(
> +		__entry->vcpu = vcpu;
> +		__entry->msg = msg;
> +	),
> +
> +	TP_printk("%s", __entry->msg)

Here, of course, you can use print_symbolic() to preserve readability.


-- 
error compiling committee.c: too many arguments to function

