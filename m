Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab2DPQCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DPQCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:02:18 -0400
Message-ID: <4F8C4284.9080201@redhat.com>
Date: Mon, 16 Apr 2012 19:02:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: kvm-ppc@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com> <20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com> <4F857B61.9080602@linux.vnet.ibm.com> <20120411231441.9d0984672dd252b806f99128@gmail.com> <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com> <4F8A95CB.9070104@redhat.com> <20120417004935.a9a39d951b3c24588e29edd2@gmail.com>
In-Reply-To: <20120417004935.a9a39d951b3c24588e29edd2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 06:49 PM, Takuya Yoshikawa wrote:
> > This doesn't work for EPT, which lacks a dirty bit.  But we can emulate
> > it: take a free bit and call it spte.NOTDIRTY, when it is set, we also
> > clear spte.WRITE, and teach the mmu that if it sees spte.NOTDIRTY and
> > can just set spte.WRITE and clear spte.NOTDIRTY.  Now that looks exactly
> > like Xiao's lockless write enabling.
>
> How do we sync with dirty_bitmap?

In Xiao's patch we call mark_page_dirty() at fault time.  With the
write-protect-less approach, we look at spte.DIRTY (or spte.NOTDIRTY)
during GET_DIRTY_LOG, or when the spte is torn down.

> > Another note: O(1) write protection is not mutually exclusive with rmap
> > based write protection.  In GET_DIRTY_LOG, you write protect everything,
> > and proceed to write enable on faults.  When you reach the page table
> > level, you perform the rmap check to see if you should write protect or
> > not.  With role.direct=1 the check is very cheap (and sometimes you can
> > drop the entire page table and replace it with a large spte).
>
> I understand that there are many possible combinations.
>
> But the question is whether the complexity is really worth it.

We don't know yet.  I'm just throwing ideas around.

> Once, when we were searching a way to find atomic bitmap switch, you said
> to me that we should do our best not to add overheads to VCPU threads.
>
> From then, I tried my best to mitigate the latency problem without adding
> code to VCPU thread paths: if we add cond_resched patch, we will get a simple
> solution to the current known problem -- probably 64GB guests will work well
> without big latencies, once QEMU gets improved.

Sure, I'm not advocating doing the most nifty idea.  After all I'm the
one that suffers most from it.  Everything should be proven to improve,
and the improvement should be material, not just a random measurement
that doesn't matter to anyone.

>
> 	I also surveyed other known hypervisors internally.  We can easily see
> 	hundreds of ms latency during migration.  But people rarely complain
> 	about that if they are stable and usable in most situations.

There is also the unavoidable latency during the final stop-and-copy
phase, at least without post-copy.  And the migration thread (when we
have one) is hardly latency sensitive.

> Although O(1) is actually O(1) for GET_DIRTY_LOG thread, it adds some
> overheads to page fault handling.  We may need to hold mmu_lock for properly
> handling O(1)'s write protection and ~500 write protections will not be so
> cheap.  And there is no answer to the question how to achive slot-wise write
> protection.
>
> Of course, we may need such a tree-wide write protection when we want to
> support guests with hundreds of GB, or TB, of memory.  Sadly it's not now.
>
>
> Well, if you need the best answer now, we should discuss the whole design:
> KVM Forum may be a good place for that.

We don't need the best answer now, I'm satisfied with incremental
improvements.  But it's good to have the ideas out in the open, maybe
some of them will be adopted, or maybe they'll trigger a better idea.

(btw O(1) write protection is equally applicable to ordinary fork())

-- 
error compiling committee.c: too many arguments to function

