Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1FIHjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1FIHjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:39:14 -0400
Message-ID: <4DF0789B.2050401@redhat.com>
Date: Thu, 09 Jun 2011 10:39:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 03:58 PM, Xiao Guangrong wrote:
> The idea of this patchset is from Avi:
> | We could cache the result of a miss in an spte by using a reserved bit, and
> | checking the page fault error code (or seeing if we get an ept violation or
> | ept misconfiguration), so if we get repeated mmio on a page, we don't need to
> | search the slot list/tree.
> | (https://lkml.org/lkml/2011/2/22/221)
>
> The aim of this patchset is to support fast mmio emulate, it reduce searching
> mmio gfn from memslots which is very expensive since we need to walk all slots
> for mmio gfn, and the other advantage is: we can reduce guest page table walking
> for soft mmu.
>
> Lockless walk shadow page table is introduced in this patchset, it is the light
> way to check the page fault is the real mmio page fault or something is running
> out of our mind.
>
> And, if shadow_notrap_nonpresent_pte is enabled(bypass_guest_pf=1), mmio page
> fault and normal page fault is mixed(the reserved is set for all page fault),
> it has little regression, if the box can generate lots of mmio access, for
> example, the network server, it can disable shadow_notrap_nonpresent_pte and
> enable mmio pf, after all, we can enable/disable mmio pf at the runtime.
>

Okay, this is pretty complicated.  And things are already complicated.

First, I think we should consider dropping bypass_guest_pf completely, 
just so we have less things to think about.

Second, I don't like two paths for accessing shadow page tables, it 
makes the code much larger.  I'm also not sure RCU is enough protection 
- we can unlink a page in the middle of a hierarchy, and on i386 this 
causes an invalid pointer to appear when we fetch the two halves.  But I 
guess, if the cpu can do it, so can we.

Maybe we can do something like

again:
   fetch pointer to last level spte using RCU
   if failed:
        take lock
        build spte hierarchy
        drop lock
        goto again
   if sync:
       if mmio:
           do mmio
           return
       return
   walk guest table
   install spte
   if mmio:
      do mmio

(sync is always false for tdp)

-- 
error compiling committee.c: too many arguments to function

