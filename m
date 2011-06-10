Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab1FJED0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:03:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1FJEDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:03:23 -0400
Message-ID: <4DF19803.9040407@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 12:05:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com> <4DF0789B.2050401@redhat.com>
In-Reply-To: <4DF0789B.2050401@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 12:03:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 12:03:09,
	Serialize complete at 2011-06-10 12:03:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 03:39 PM, Avi Kivity wrote:

> First, I think we should consider dropping bypass_guest_pf completely, just so we have less things to think about.
> 

I agree.

> I'm also not sure RCU is enough protection - we can unlink a page in the middle of a hierarchy,

I think it is ok, it just likes the page structure cache of real CPU, we can use
the old mapping or new mapping here, if we missed, page fault path is called, it can 
fix the problem for us.

> and on i386 this causes an invalid pointer to appear when we fetch the two halves.  But I guess, if the cpu can do it, so can we.
> 

Ah, maybe the cpu can not do it, we need a light way to get spte for i386 host...

> Maybe we can do something like
> 
> again:
>   fetch pointer to last level spte using RCU
>   if failed:
>        take lock
>        build spte hierarchy
>        drop lock
>        goto again
>   if sync:
>       if mmio:
>           do mmio
>           return
>       return
>   walk guest table
>   install spte
>   if mmio:
>      do mmio
> 
> (sync is always false for tdp)
> 

It seams it is more complex, the origin way is:

fetch last level spte
if failed or it is not a mmio spte:
	call page fault
do mmio

and it has little heavy sine we need to walk guest page table,
and build spte under mmu-lock.

Maybe i missed your meaning, could you please tell me the advantage? :-(

