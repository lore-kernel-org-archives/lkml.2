Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2DOJdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 05:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2DOJdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 05:33:06 -0400
Message-ID: <4F8A95CB.9070104@redhat.com>
Date: Sun, 15 Apr 2012 12:32:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com> <20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com> <4F857B61.9080602@linux.vnet.ibm.com> <20120411231441.9d0984672dd252b806f99128@gmail.com> <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com>
In-Reply-To: <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 05:25 PM, Takuya Yoshikawa wrote:
> I forgot to say one important thing -- I might give you wrong impression.
>
> I am perfectly fine with your lock-less work.  It is really nice!
>
> The reason I say much about O(1) is that O(1) and rmap based
> GET_DIRTY_LOG have fundamentally different characteristics.
>
> I am thinking really seriously how to make dirty page tracking work
> well with QEMU in the future.
>
> For example, I am thinking about multi-threaded and fine-grained
> GET_DIRTY_LOG.
>
> If we use rmap based GET_DIRTY_LOG, we can restrict write protection to
> only a selected area of one guest memory slot.
>
> So we may be able to make each thread process dirty pages independently
> from other threads by calling GET_DIRTY_LOG for its own area.
>
> But I know that O(1) has its own good point.
> So please wait a bit.  I will write up what I am thinking or send patches.
>
> Anyway, I am looking forward to your lock-less work!
> It will improve the current GET_DIRTY_LOG performance.
>
>

Just to throw another idea into the mix - we can have write-protect-less
dirty logging, too.  Instead of write protection, drop the dirty bit,
and check it again when reading the dirty log.  It might look like we're
accessing the spte twice here, but it's actually just once - when we
check it to report for GET_DIRTY_LOG call N, we also prepare it for call
N+1.

This doesn't work for EPT, which lacks a dirty bit.  But we can emulate
it: take a free bit and call it spte.NOTDIRTY, when it is set, we also
clear spte.WRITE, and teach the mmu that if it sees spte.NOTDIRTY and
can just set spte.WRITE and clear spte.NOTDIRTY.  Now that looks exactly
like Xiao's lockless write enabling.

Another note: O(1) write protection is not mutually exclusive with rmap
based write protection.  In GET_DIRTY_LOG, you write protect everything,
and proceed to write enable on faults.  When you reach the page table
level, you perform the rmap check to see if you should write protect or
not.  With role.direct=1 the check is very cheap (and sometimes you can
drop the entire page table and replace it with a large spte).

-- 
error compiling committee.c: too many arguments to function

