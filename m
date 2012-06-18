Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2FRPCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2FRPCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:02:13 -0400
Message-ID: <4FDF42E7.8050902@redhat.com>
Date: Mon, 18 Jun 2012 18:01:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 3/8] kvm_para: guest side for eoi avoidance
References: <cover.1339681762.git.mst@redhat.com> <4c5bedc5cb55dcea1676b913a0f6da3f04b03145.1339681762.git.mst@redhat.com> <4FDF3874.2050208@redhat.com> <20120618145041.GE26540@redhat.com>
In-Reply-To: <20120618145041.GE26540@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:50 PM, Michael S. Tsirkin wrote:
> 
>> >  
>> > +/* size alignment is implied but just to make it explicit. */
>> > +static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) __aligned(2) =
>> > +	KVM_PV_EOI_DISABLED;
>> 
>> You're actually breaking the alignment.  ulong has 8 byte alignment
>> sometimes and you can make it cross cache boundary this way.
> 
> No, if you look at the definition of __aligned
> you will see that it limits the alignment from below.
> Compiler still applies the natural size alignment.
> You are not the first to get confused. So I wonder: is it better
> to add a comment or simply remove __aligned here.

Both.

>> >  
>> > +	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
>> > +		__get_cpu_var(kvm_apic_eoi) = 0;
>> > +		wrmsrl(MSR_KVM_PV_EOI_EN, __pa(&__get_cpu_var(kvm_apic_eoi)) |
>> > +		       KVM_MSR_ENABLED);
>> 
>> Bad formatting.
> 
> I guess temporary will make it prettier.
> 	unsigned long pa;
> 	__get_cpu_var(kvm_apic_eoi) = 0;
> 	pa = __pa(&__get_cpu_var(kvm_apic_eoi)) | KVM_MSR_ENABLED;
> 	wrmsrl(MSR_KVM_PV_EOI_EN, pa);

That, or

+		wrmsrl(MSR_KVM_PV_EOI_EN,
+                      __pa(&__get_cpu_var(kvm_apic_eoi)) | _ENABLED);

You have an argument split over two lines with no helpful indentation to
show this.

>> 
>> 
>> Please check that the kexec path also disables pveoi.
> 
> The chunk in kvm_pv_guest_cpu_reboot does this, doesn't it?

Dunno, does it?



-- 
error compiling committee.c: too many arguments to function


