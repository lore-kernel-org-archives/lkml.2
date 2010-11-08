Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0KHCKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:10:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51604 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab0KHCKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:10:14 -0500
Message-ID: <4CD75D0B.1000305@cn.fujitsu.com>
Date: Mon, 08 Nov 2010 10:14:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
References: <4CD28B5F.1040205@cn.fujitsu.com> <4CD28BCA.1060907@cn.fujitsu.com> <20101104103548.GE6018@redhat.com> <4CD39886.4050909@cn.fujitsu.com> <20101105074533.GC14910@redhat.com> <4CD3BA50.1000002@cn.fujitsu.com> <20101105103124.GD14910@redhat.com>
In-Reply-To: <20101105103124.GD14910@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 10:10:40,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 10:10:41,
	Serialize complete at 2010-11-08 10:10:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 06:31 PM, Gleb Natapov wrote:
> On Fri, Nov 05, 2010 at 04:03:28PM +0800, Xiao Guangrong wrote:
>> On 11/05/2010 03:45 PM, Gleb Natapov wrote:
>>
>>>>
>>>> It looks like something broken: apfs can generated in L2 guest (nested ntp guest)
>>>> and be retried in L1 guest.
>>>>
>>> Why is this a problem? apf will be generate on direct map even when L2
>>> guest is running so it should be OK to prefault it into direct map on
>>> completion.
>>>
>>
>> The nested_cr3 is different between L2 and L1, fix L2's page fault in L1's page table
>> is useless.
> But we are fixing L0 page faults in L0 page table. We do not start apf
> because of L1 faulted in its page table.
> 

Hi Gleb,

For example, NPT Guest L1 runs on Host, and Nested NPT Guest L2 runs on Guest L1.
Now, Guest L2 is running, has below sequences:

a: NPF/PF occurs in L2 Guest, and generates a apf(named A-apf), then
   L2 Guest is blocked

b: a external event wakes up L2 Guest, and let it run again.

c: L2 Guest VMEXIT to L1 Guest because L2 Guest's action is intercepted by Guest L1

d: When cpu enter L1 Guest, A-apf is completed, then it will retry A-apf in
   L1 Guest's mmu context, and this 'retry' is useless.

Could you please point it out for me if i missed something. :-)


