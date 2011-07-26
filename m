Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1GZNyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:54:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1GZNxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:53:48 -0400
Message-ID: <4E2EC6E5.2090404@redhat.com>
Date: Tue, 26 Jul 2011 16:53:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write instructions
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA476.9070607@cn.fujitsu.com> <20110726122710.GM4404@redhat.com>
In-Reply-To: <20110726122710.GM4404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 03:27 PM, Gleb Natapov wrote:
> On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
> >  We usually use repeat string instructions to clear the page, for example,
> By "we" do you mean Linux guest?
>
> >  we call memset to clear a page table, stosb is used in this function, and
> >  repeated for 1024 times, that means we should occupy mmu lock for 1024 times
> >  and walking shadow page cache for 1024 times, it is terrible
> >
> >  In fact, if it is the repeat string instructions emulated and it is not a
> >  IO/MMIO access, we can zap all the corresponding shadow pages and return to the
> >  guest, then the mapping can became writable and directly write the page
> >
> So this patch does two independent things as far as I can see. First it
> stops reentering guest if rep instruction is done on memory and second
> it drops shadow pages if access to shadowed page table is rep. Why not
> separate those in different patches?  BTW not entering guest periodically
> increases interrupt latencies. Why not zap shadow, make page writable
> and reenter the guest instead of emulation, it should be much faster (do we
> care to optimize for old cpus by complicating the code anyway?).
>

The second thing is mentioned on the TODO list in a more general way: 
tag instructions that are typically used to modify the page tables, and 
drop shadow if any other instruction is used.  Since MOVS is typically 
not used to update pagetables, it would not be tagged.

The list would include, I'd guess, and, or, bts, btc, mov, xchg, 
cmpxchg, and cmpxchg8b.  Anything else?

-- 
error compiling committee.c: too many arguments to function

