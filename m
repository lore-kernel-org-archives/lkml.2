Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab2BOOIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:08:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2BOOIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:08:51 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3BB9DC.6040102@redhat.com>
Date: Wed, 15 Feb 2012 15:08:48 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15.02.2012, at 14:57, Avi Kivity wrote:

> On 02/15/2012 03:37 PM, Alexander Graf wrote:
>> On 15.02.2012, at 14:29, Avi Kivity wrote:
>> 
>>> On 02/15/2012 01:57 PM, Alexander Graf wrote:
>>>>> 
>>>>> Is an extra syscall for copying TLB entries to user space prohibitively
>>>>> expensive?
>>>> 
>>>> The copying can be very expensive, yes. We want to have the possibility of exposing a very large TLB to the guest, in the order of multiple kentries. Every entry is a struct of 24 bytes.
>>> 
>>> You don't need to copy the entire TLB, just the way that maps the
>>> address you're interested in.
>> 
>> Yeah, unless we do migration in which case we need to introduce another special case to fetch the whole thing :(.
> 
> Well, the scatter/gather registers I proposed will give you just one
> register or all of them.

One register is hardly any use. We either need all ways of a respective address to do a full fledged lookup or all of them. By sharing the same data structures between qemu and kvm, we actually managed to reuse all of the tcg code for lookups, just like you do for x86. On x86 you also have shared memory for page tables, it's just guest visible, hence in guest memory. The concept is the same.

> 
>>> btw, why are you interested in virtual addresses in userspace at all?
>> 
>> We need them for gdb and monitor introspection.
> 
> Hardly fast paths that justify shared memory.  I should be much harder
> on you.

It was a tradeoff on speed and complexity. This way we have the least amount of complexity IMHO. All KVM code paths just magically fit in with the TCG code. There are essentially no if(kvm_enabled)'s in our MMU walking code, because the tables are just there. Makes everything a lot easier (without dragging down performance).

> 
>>>> 
>>>> Right. It's an optional performance accelerator. If anything doesn't align, don't use it. But if you happen to have a system where everything's cool, you're faster. Sounds like a good deal to me ;).
>>> 
>>> Depends on how much the alignment relies on guest knowledge.  I guess
>>> with a simple device like HPET, it's simple, but with a complex device,
>>> different guests (or different versions of the same guest) could drive
>>> it very differently.
>> 
>> Right. But accelerating simple devices > not accelerating any devices. No? :)
> 
> Yes.  But introducing bugs and vulns < not introducing them.  It's a
> tradeoff.  Even an unexploited vulnerability can be a lot more pain,
> just because you need to update your entire cluster, than a simple
> device that is accelerated for a guest which has maybe 3% utilization. 
> Performance is just one parameter we optimize for.  It's easy to overdo
> it because it's an easily measurable and sexy parameter, but it's a mistake.

Yeah, I agree. That's why I was trying to get AHCI to the default storage adapter for a while, because I think the same. However, Anthony believes that XP/w2k3 is still a major chunk of the guests running on QEMU, so we can't do that :(.

I'm mostly trying to think of ways to accelerate the obvious low hanging fruits, without overengineering any interfaces.

> 
>>> 
>>> One thing that's different is that virtio offloads itself to a thread
>>> very quickly, while IDE does a lot of work in vcpu thread context.
>> 
>> So it's all about latencies again, which could be reduced at least a fair bit with the scheme I described above. But really, this needs to be prototyped and benchmarked to actually give us data on how fast it would get us.
> 
> Simply making qemu issue the request from a thread would be way better. 
> Something like socketpair mmio, configured for not waiting for the
> writes to be seen (posted writes) will also help by buffering writes in
> the socket buffer.

Yup, nice idea. That only works when all parts of a device are actually implemented through the same socket though. Otherwise you could run out of order. So if you have a PCI device with a PIO and an MMIO BAR region, they would both have to be handled through the same socket.

> 
>>> 
>>> The all-knowing management tool can provide a virtio driver disk, or
>>> even slip-stream the driver into the installation CD.
>> 
>> One management tool might do that, another one might now. We can't assume that all management tools are all-knowing. Some times you also want to run guest OSs that the management tool doesn't know (yet).
> 
> That is true, but we have to leave some work for the management guys.

The easier the management stack is, the happier I am ;).

> 
>> 
>>>> So for MMIO reads, I can assume that this is an MMIO because I would never write a non-readable entry. For writes, I'm overloading the bit that also means "guest entry is not readable" so there I'd have to walk the guest PTEs/TLBs and check if I find a read-only entry. Right now I can just forward write faults to the guest. Since COW is probably a hotter path for the guest than MMIO, this might end up being ineffective.
>>> 
>>> COWs usually happen from guest userspace, while mmio is usually from the
>>> guest kernel, so you can switch on that, maybe.
>> 
>> Hrm, nice idea. That might fall apart with user space drivers that we might eventually have once vfio turns out to work well, but for the time being it's a nice hack :).
> 
> Or nested virt...

Nested virt on ppc with device assignment? And here I thought I was the crazy one of the two of us :)


Alex

