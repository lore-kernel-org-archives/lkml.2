Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1ELPNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:13:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab1ELPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:13:20 -0400
Message-ID: <4DCBF904.6040104@redhat.com>
Date: Thu, 12 May 2011 18:13:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dhaval Giani <dhaval.giani@gmail.com>
CC: kvm@vger.kernel.org, joro@8bytes.org, agraf@suse.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: log directly from the guest to the host kvm buffer
References: <1305207413.18715.3.camel@gondor.retis>
In-Reply-To: <1305207413.18715.3.camel@gondor.retis>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 04:36 PM, Dhaval Giani wrote:
> Hi,
>
> As part of some of the work for my project, I have been looking at
> tracing some of the events in the guest from inside the host. In
> my usecase, I have been looking to co-relate the time of a network
> packet arrival with that in the host. ftrace makes such arbitrary
> use quite simple, so I went ahead an extended this functionality
> in terms of a hypercall. There are still a few issues with this patch.
>
> 1. For some reason, the first time the hypercall is called, it works
> just fine, but the second invocation refuses to happen. I am still
> clueless about it. (and am looking for hints :-) )
> 2. I am not very sure if I got the demarcation between the guest and
> the host code fine or not. Someone more experienced than me should take
> a look at the code as well :-)
> 3. This adds a new paravirt call.
> 4. This has been implemented just for x86 as of now. If there is enough
> interest, I will look to make it more generic to be used across other
> architectures. However, it is quite easy to do the same.
> 5. It still does not have all the fancy ftrace features, but again,
> depending on the interest, I can add all those in.
> 6. Create a config option for this feature.
>
> I think such a feature is useful for debugging purposes and might make
> sense to carry upstream.

I guess it could help things like virtio/vhost development and profiling.


I think that one hypercall per trace is too expensive.  Tracing is meant 
to be lightweight!  I think the guest can log to a buffer, which is 
flushed on overflow or when a vmexit occurs.  That gives us automatic 
serialization between a vcpu and the cpu it runs on, but not between a 
vcpu and a different host cpu.

>
> +int kvm_pv_ftrace(struct kvm_vcpu *vcpu, unsigned long ip, gpa_t addr)
> +{
> +	int ret;
> +	char *fmt = (char *) kzalloc(PAGE_SIZE, GFP_KERNEL);
> +
> +	ret = kvm_read_guest(vcpu->kvm, addr, fmt, PAGE_SIZE);
> +
> +	trace_printk("KVM instance %p: VCPU %d, IP %lu: %s",
> +				vcpu->kvm, vcpu->vcpu_id, ip, fmt);
> +
> +	kfree(fmt);
> +
> +	return 0;
> +}

A kmalloc and printf seem expensive here.  I'd prefer to log the 
arguments and format descriptor instead.  Similarly the guest should 
pass unformatted parameters.+int kvm_ftrace_printk(unsigned long ip, 
const char *fmt, ...)
> +{
> +	char *buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	int ret;
> +	unsigned long a1, a2;
> +	va_list args;
> +	int i;
> +
> +	va_start(args, fmt);
> +	i = vsnprintf(buffer, PAGE_SIZE, fmt, args);
> +	va_end(args);
> +
> +	a1 = __pa(buffer);
> +	a2 = 0;
> +
> +	ret = kvm_hypercall3(KVM_HC_FTRACE, ip, a1, a2);
> +
> +	kfree(buffer);
> +	return ret;
> +}
> +EXPORT_SYMBOL(kvm_ftrace_printk);
> +
>   static void mmu_queue_flush(struct kvm_para_state *state)
>   {

-- 
error compiling committee.c: too many arguments to function

