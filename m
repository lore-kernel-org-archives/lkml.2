Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1FMEoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:44:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1FMEoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:44:17 -0400
Message-ID: <4DF5961A.6050006@cn.fujitsu.com>
Date: Mon, 13 Jun 2011 12:46:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com> <4DF0789B.2050401@redhat.com> <4DF19803.9040407@cn.fujitsu.com> <4DF47D0A.9060604@redhat.com>
In-Reply-To: <4DF47D0A.9060604@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 12:43:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 12:44:00,
	Serialize complete at 2011-06-13 12:44:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 04:47 PM, Avi Kivity wrote:
> On 06/10/2011 07:05 AM, Xiao Guangrong wrote:
>> On 06/09/2011 03:39 PM, Avi Kivity wrote:
>>
>> >  First, I think we should consider dropping bypass_guest_pf completely, just so we have less things to think about.
>> >
>>
>> I agree.
> 
> Great, please post a patch.

OK.

>> Ah, maybe the cpu can not do it, we need a light way to get spte for i386 host...
> 
> Look at the comments in arch/x86/mm/gup.c - it does the same thing.
> 

Yeah, it is a good study case for me.

>> the origin way is:
>>
>> fetch last level spte
>> if failed or it is not a mmio spte:
>>     call page fault
>> do mmio
>>
>> and it has little heavy sine we need to walk guest page table,
>> and build spte under mmu-lock.
> 
> For shadow, yes, this is a good optimization.  But with nested paging it slow things down.  We already have the gpa, so all we need to do is follow the mmio path.  There's no need to walk the spte hierarchy.
> 

Yes, it is, i just want to detect BUG for KVM, it helps us to know if "ept misconfig" is the
real MMIO or the BUG. I noticed some "ept misconfig" BUGs is reported before, so i think doing
this is necessary, and i think it is not too bad, since walking spte hierarchy is lockless,
it really fast.

>> Maybe i missed your meaning, could you please tell me the advantage? :-(
> 
> I wanted to also service RAM faults without the lock, if the only thing missing was the spte (and the rest of the hierarchy was fine).  But it can't be made to work without an overhaul of all of the locking.
> 

Great, i have the same thought, anyway, it is a good start :-)

