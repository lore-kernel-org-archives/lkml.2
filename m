Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0KHQ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:58:27 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:45599 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0KHQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=laJPPDcWeau/mZzbQA8ntWg3aAC8HgL8krUUZ4r98fR2OEQzas5CaOtBoVEDRgtaPr
         LvYo9xGVlFzInQ3hKxLgVpAs9fJP0xuPWFV0f6X4udiS7fBLb0jCbXhNpFOgbeT5m4YF
         qjUDguG0bv7EtOKlnKOkX1TPWAaRM2zJNUyIE=
MIME-Version: 1.0
In-Reply-To: <20101108135219.GA9036@redhat.com>
References: <4CD28B5F.1040205@cn.fujitsu.com>
	<4CD28BCA.1060907@cn.fujitsu.com>
	<20101104103548.GE6018@redhat.com>
	<4CD39886.4050909@cn.fujitsu.com>
	<20101105074533.GC14910@redhat.com>
	<4CD3BA50.1000002@cn.fujitsu.com>
	<20101105103124.GD14910@redhat.com>
	<4CD75D0B.1000305@cn.fujitsu.com>
	<20101108135219.GA9036@redhat.com>
Date: Tue, 9 Nov 2010 00:58:24 +0800
Message-ID: <AANLkTim6M11nu2hD=T+F=xGfePyUEo+WO+UDtYDVL+xm@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
To: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mean the second case, the problem is in "d:", now, A-apf is on
L0->L1 mapping, and A-apf.gva is nested fault address(L2's physics
address in L0->L2 mapping), you use this address to retry #pf in
L0->L1 mapping? it is just waste.

On 11/8/10, Gleb Natapov <gleb@redhat.com> wrote:
> On Mon, Nov 08, 2010 at 10:14:35AM +0800, Xiao Guangrong wrote:
>> On 11/05/2010 06:31 PM, Gleb Natapov wrote:
>> > On Fri, Nov 05, 2010 at 04:03:28PM +0800, Xiao Guangrong wrote:
>> >> On 11/05/2010 03:45 PM, Gleb Natapov wrote:
>> >>
>> >>>>
>> >>>> It looks like something broken: apfs can generated in L2 guest
>> >>>> (nested ntp guest)
>> >>>> and be retried in L1 guest.
>> >>>>
>> >>> Why is this a problem? apf will be generate on direct map even when L2
>> >>> guest is running so it should be OK to prefault it into direct map on
>> >>> completion.
>> >>>
>> >>
>> >> The nested_cr3 is different between L2 and L1, fix L2's page fault in
>> >> L1's page table
>> >> is useless.
>> > But we are fixing L0 page faults in L0 page table. We do not start apf
>> > because of L1 faulted in its page table.
>> >
>>
>> Hi Gleb,
>>
>> For example, NPT Guest L1 runs on Host, and Nested NPT Guest L2 runs on
>> Guest L1.
>> Now, Guest L2 is running, has below sequences:
>>
>> a: NPF/PF occurs in L2 Guest, and generates a apf(named A-apf), then
>>    L2 Guest is blocked
>>
> What do you mean by that? Do you mean L2 exits to L1 with NPF because
> L1 swapped out L2 page? In this case apf will be generated and handled
> by L1 just like in L0->L1 non-nested case. Or do you mean L2 exits to L0
> with NPF because L0 swapped out L1 page? Lets assume you mean second
> case since it is interesting one.
>
>> b: a external event wakes up L2 Guest, and let it run again.
>>
>> c: L2 Guest VMEXIT to L1 Guest because L2 Guest's action is intercepted by
>> Guest L1
>>
>> d: When cpu enter L1 Guest, A-apf is completed, then it will retry A-apf
>> in
>>    L1 Guest's mmu context, and this 'retry' is useless.
> Since A-apf was on L0->L1 mapping it is OK to prefault it into direct
> map. Wen L2 will run again and try to access this page it fill fault
> again since the page is not pre-faulted into nntp shadow page. This time
> L0 will find page in memory and will create shadow mapping for it
> without apf.
>
>>
>> Could you please point it out for me if i missed something. :-)
>>
>
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Sent from my mobile device
