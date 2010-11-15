Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0KOJaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0KOJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:30:45 -0500
Message-ID: <4CE0FDBC.20505@redhat.com>
Date: Mon, 15 Nov 2010 11:30:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com> <4CDCE3C2.9030107@cn.fujitsu.com> <4CDFBE00.2000802@redhat.com> <4CE0C45C.809@cn.fujitsu.com>
In-Reply-To: <4CE0C45C.809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 07:25 AM, Xiao Guangrong wrote:
> On 11/14/2010 06:46 PM, Avi Kivity wrote:
> >  On 11/12/2010 08:50 AM, Xiao Guangrong wrote:
> >>  Retry #PF for softmmu only when the current vcpu has the same
> >>  root shadow page as the time when #PF occurs. it means they
> >>  have same paging environment
> >>
> >
>
> Hi Avi,
>
> Thanks for your review.
>
> >  The process could have been killed and replaced by another using the
> >  same cr3.
>
> Yeah, this 'retry' is unnecessary if the process is killed, but this
> case is infrequent, the most case is the process keeps running and try
> to access the fault address later.

The problem is that if we retry in this case, we install an incorrect spte?

> And, we can get few advantages even if the process have been killed,
> since we can fix the page mapping for the other processes which have
> the same CR3, if other process accessed the fault address, the #PF
> can be avoid. (of course we can't speculate other process can access
> the fault address later)
>
> After all, this is a speculate path, i thinks it can work well in most
> case. :-)
>
> >  Or we may be running a guest that uses the same cr3 for all
> >  processes.
>
> We can allow to retry #PF in the same CR3 even if there are the different
> processes, since these processes have the same page mapping, the later #PF
> can avoid if the page mapping have been fixed.

The guest may have changed page directories or other levels.

> >  Or another thread may have mmap()ed something else over the
> >  same address.
>
> The mmap virtual address is also visible for other threads since the threads
> have the same page table, so i think this case is the same as above?

Again, don't we install the wrong spte in this case?

-- 
error compiling committee.c: too many arguments to function

