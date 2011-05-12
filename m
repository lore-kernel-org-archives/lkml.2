Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1ELPjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:39:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37293 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1ELPjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tbqe++Qv1ASY4x0czcX972/XFrC6D6QGxaWDbiqsq30cnYpxuk9t27VcKaADvd618f
         eKW05blh52mfi7Z8kv7pkd64x+OYBuPealZu6bpLAesrRHWoVLsG/eqHaE2zbp2dUD1j
         BiSiZS/fqbFG5BoCieOfgKMP1fdp4DqCe1/s8=
MIME-Version: 1.0
In-Reply-To: <4DCBF904.6040104@redhat.com>
References: <1305207413.18715.3.camel@gondor.retis>
	<4DCBF904.6040104@redhat.com>
Date: Thu, 12 May 2011 17:39:47 +0200
Message-ID: <BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
Subject: Re: [PATCH] kvm: log directly from the guest to the host kvm buffer
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, joro@8bytes.org, agraf@suse.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 5:13 PM, Avi Kivity <avi@redhat.com> wrote:
> On 05/12/2011 04:36 PM, Dhaval Giani wrote:
>>
>> Hi,
>>
>> As part of some of the work for my project, I have been looking at
>> tracing some of the events in the guest from inside the host. In
>> my usecase, I have been looking to co-relate the time of a network
>> packet arrival with that in the host. ftrace makes such arbitrary
>> use quite simple, so I went ahead an extended this functionality
>> in terms of a hypercall. There are still a few issues with this patch.
>>
>> 1. For some reason, the first time the hypercall is called, it works
>> just fine, but the second invocation refuses to happen. I am still
>> clueless about it. (and am looking for hints :-) )
>> 2. I am not very sure if I got the demarcation between the guest and
>> the host code fine or not. Someone more experienced than me should take
>> a look at the code as well :-)
>> 3. This adds a new paravirt call.
>> 4. This has been implemented just for x86 as of now. If there is enough
>> interest, I will look to make it more generic to be used across other
>> architectures. However, it is quite easy to do the same.
>> 5. It still does not have all the fancy ftrace features, but again,
>> depending on the interest, I can add all those in.
>> 6. Create a config option for this feature.
>>
>> I think such a feature is useful for debugging purposes and might make
>> sense to carry upstream.
>
> I guess it could help things like virtio/vhost development and profiling.
>

Exactly what i am using it for.

>
> I think that one hypercall per trace is too expensive.  Tracing is meant to
> be lightweight!  I think the guest can log to a buffer, which is flushed on
> overflow or when a vmexit occurs.  That gives us automatic serialization
> between a vcpu and the cpu it runs on, but not between a vcpu and a
> different host cpu.
>

hmm. So, basically, log all of these events, and then send them to the
host either on an exit, or when your buffer fills up. There is one
problem with approach though. One of the reasons I wanted this
approach was beacuse i wanted to co-relate the guest and the host
times. (which is why I kept is synchronous). I lose out that
information with what you say. However I see your point about the
overhead. I will think about this a bit more.

>>
>> +int kvm_pv_ftrace(struct kvm_vcpu *vcpu, unsigned long ip, gpa_t addr)
>> +{
>> +       int ret;
>> +       char *fmt = (char *) kzalloc(PAGE_SIZE, GFP_KERNEL);
>> +
>> +       ret = kvm_read_guest(vcpu->kvm, addr, fmt, PAGE_SIZE);
>> +
>> +       trace_printk("KVM instance %p: VCPU %d, IP %lu: %s",
>> +                               vcpu->kvm, vcpu->vcpu_id, ip, fmt);
>> +
>> +       kfree(fmt);
>> +
>> +       return 0;
>> +}
>
> A kmalloc and printf seem expensive here.  I'd prefer to log the arguments
> and format descriptor instead.  Similarly the guest should pass unformatted
> parameters.+int kvm_ftrace_printk(unsigned long ip, const char *fmt, ...)
>>

the trace_printk is actually quite cheap (IIRC), but I guess Steve is
the best person to let us know about that. We can avoid the kzalloc
overhead though.

Dhaval
