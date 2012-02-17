Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2BQATj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:19:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab2BQATh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:19:37 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3D5B35.4000606@redhat.com>
Date: Fri, 17 Feb 2012 01:19:35 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <8A20A1D8-9CB7-4256-A9BD-03D972C5292A@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de> <4F3D5B35.4000606@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.02.2012, at 20:38, Avi Kivity wrote:

> On 02/16/2012 09:34 PM, Alexander Graf wrote:
>> On 16.02.2012, at 20:24, Avi Kivity wrote:
>> 
>>> On 02/15/2012 04:08 PM, Alexander Graf wrote:
>>>>> 
>>>>> Well, the scatter/gather registers I proposed will give you just one
>>>>> register or all of them.
>>>> 
>>>> One register is hardly any use. We either need all ways of a respective address to do a full fledged lookup or all of them. 
>>> 
>>> I should have said, just one register, or all of them, or anything in
>>> between.
>>> 
>>>> By sharing the same data structures between qemu and kvm, we actually managed to reuse all of the tcg code for lookups, just like you do for x86.
>>> 
>>> Sharing the data structures is not need.  Simply synchronize them before
>>> lookup, like we do for ordinary registers.
>> 
>> Ordinary registers are a few bytes. We're talking of dozens of kbytes here.
> 
> A TLB way is a few dozen bytes, no?
> 
>>> 
>>>> On x86 you also have shared memory for page tables, it's just guest visible, hence in guest memory. The concept is the same.
>>> 
>>> But cr3 isn't, and if we put it in shared memory, we'd have to VMREAD it
>>> on every exit.  And you're risking the same thing if your hardware gets
>>> cleverer.
>> 
>> Yes, we do. When that day comes, we forget the CAP and do it another way. Which way we will find out by the time that day of more clever hardware comes :).
> 
> Or we try to be less clever unless we have a really compelling reason. 
> qemu monitor and gdb support aren't compelling reasons to optimize.

The goal here was simplicity with a grain of performance concerns.

So what would you be envisioning? Should we make all of the MMU walker code in target-ppc KVM aware so it fetches that single way it actually cares about on demand from the kernel? That is pretty intrusive and goes against the general nicely fitting in principle of how KVM integrates today.

Also, we need to store the guest TLB somewhere. With this model, we can just store it in user space memory, so we keep only a single copy around, reducing memory footprint. If we had to copy it, we would need more than a single copy.

> 
>>> 
>>> It's too magical, fitting a random version of a random userspace
>>> component.  Now you can't change this tcg code (and still keep the magic).
>>> 
>>> Some complexity is part of keeping software as separate components.
>> 
>> Why? If another user space wants to use this, they can
>> 
>> a) do the slow copy path
>> or
>> b) simply use our struct definitions
>> 
>> The whole copy thing really only makes sense when you have existing code in user space that you don't want to touch, but easily add on KVM to it. If KVM is part of your whole design, then integrating things makes a lot more sense.
> 
> Yeah, I guess.
> 
>> 
>>> 
>>>> There are essentially no if(kvm_enabled)'s in our MMU walking code, because the tables are just there. Makes everything a lot easier (without dragging down performance).
>>> 
>>> We have the same issue with registers.  There we call
>>> cpu_synchronize_state() before every access.  No magic, but we get to
>>> reuse the code just the same.
>> 
>> Yes, and for those few bytes it's ok to do so - most of the time. On s390, even those get shared by now. And it makes sense to do so - if we synchronize it every time anyways, why not do so implicitly?
>> 
> 
> At least on x86, we synchronize only rarely.

Yeah, on s390 we only know which registers actually contain the information we need for traps / hypercalls when in user space, since that's where the decoding happens. So we better have all GPRs available to read from and write to.


Alex

