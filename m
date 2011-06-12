Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1FLIrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1FLIrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:47:12 -0400
Message-ID: <4DF47D0A.9060604@redhat.com>
Date: Sun, 12 Jun 2011 11:47:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com> <4DF0789B.2050401@redhat.com> <4DF19803.9040407@cn.fujitsu.com>
In-Reply-To: <4DF19803.9040407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 07:05 AM, Xiao Guangrong wrote:
> On 06/09/2011 03:39 PM, Avi Kivity wrote:
>
> >  First, I think we should consider dropping bypass_guest_pf completely, just so we have less things to think about.
> >
>
> I agree.

Great, please post a patch.

> >  I'm also not sure RCU is enough protection - we can unlink a page in the middle of a hierarchy,
>
> I think it is ok, it just likes the page structure cache of real CPU, we can use
> the old mapping or new mapping here, if we missed, page fault path is called, it can
> fix the problem for us.
>
> >  and on i386 this causes an invalid pointer to appear when we fetch the two halves.  But I guess, if the cpu can do it, so can we.
> >
>
> Ah, maybe the cpu can not do it, we need a light way to get spte for i386 host...

Look at the comments in arch/x86/mm/gup.c - it does the same thing.

> >  Maybe we can do something like
> >
> >  again:
> >    fetch pointer to last level spte using RCU
> >    if failed:
> >         take lock
> >         build spte hierarchy
> >         drop lock
> >         goto again
> >    if sync:
> >        if mmio:
> >            do mmio
> >            return
> >        return
> >    walk guest table
> >    install spte
> >    if mmio:
> >       do mmio
> >
> >  (sync is always false for tdp)
> >
>
> It seams it is more complex,

It also doesn't work - we have to set up rmap under lock.

> the origin way is:
>
> fetch last level spte
> if failed or it is not a mmio spte:
> 	call page fault
> do mmio
>
> and it has little heavy sine we need to walk guest page table,
> and build spte under mmu-lock.

For shadow, yes, this is a good optimization.  But with nested paging it 
slow things down.  We already have the gpa, so all we need to do is 
follow the mmio path.  There's no need to walk the spte hierarchy.

> Maybe i missed your meaning, could you please tell me the advantage? :-(

I wanted to also service RAM faults without the lock, if the only thing 
missing was the spte (and the rest of the hierarchy was fine).  But it 
can't be made to work without an overhaul of all of the locking.

-- 
error compiling committee.c: too many arguments to function

