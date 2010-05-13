Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0EMJlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:41:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0EMJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:41:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
Cc: kosaki.motohiro@jp.fujitsu.com, Changli Gao <xiaosuo@gmail.com>,
       akpm@linux-foundation.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <4BEBC43F.6070407@suse.cz>
References: <20100513174512.2179.A69D9226@jp.fujitsu.com> <4BEBC43F.6070407@suse.cz>
Message-Id: <20100513182403.217C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 18:40:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/13/2010 11:05 AM, KOSAKI Motohiro wrote:
> >>>> void *kvmalloc(size_t size)
> >>>> {
> >>>> 	void *ptr;
> >>>>
> >>>> 	if (size < PAGE_SIZE)
> >>>> 		return kmalloc(PAGE_SIZE, GFP_KERNEL);
> >>>> 	ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
> >>>
> >>> low order GFP_KERNEL allocation never fail. then, this doesn't works
> >>> as you expected.
> >>
> >> Hi, I suppose you mean the kmalloc allocation -- so kmalloc should fail
> >> iff alloc_pages_exact (unless somebody frees a heap of memory indeed)?
> > 
> > I mean, if size of alloc_pages_exact() argument is less than 8 pages,
> > alloc_pages_exact() never fail. see __alloc_pages_slowpath().
> 
> Sorry, I don't see what's the problem with that. I can see only that
> alloc_pages_exact is superfluous there as kmalloc "won't fail" earlier.

I don't talk about kmalloc. it's ok to never fail.  but low order alloc_pages_exact() never fail too.
Is this ok? Why?


> >>>> 	if (ptr != NULL)
> >>>> 		return ptr;
> >>>>
> >>>> 	return vmalloc(size);
> >>>
> >>> On x86, vmalloc area is only 128MB address space. it is very rare 
> >>> resource than physical ram. vmalloc fallback is not good idea.
> >>
> >> These functions are a replacement for explicit
> >> if (!(x = kmalloc()))
> >>    x = vmalloc();
> >> ...
> >> if (is_vmalloc(x))
> >>   vfree(x);
> >> else
> >>   kfree(x);
> >> in the code (like fdtable does this).
> >>
> >> The 128M limit on x86_32 for vmalloc is configurable so if drivers in
> >> sum need more on some specific hardware, it can be increased on the
> >> command line (I had to do this on one machine in the past).
> > 
> > Right, but 99% end user don't do this. I don't think this is effective advise.
> 
> Indeed. I didn't mean that as the users should change that. They should
> only if there is some weird hardware with weird drivers.
> 
> >> Anyway as this is a replacement for explicit tests, it shouldn't change
> >> the behaviour in any way. Obviously when a user doesn't need virtually
> >> contiguous space, he shouldn't use this interface at all.
> > 
> > Why can't we make fdtable virtually contiguous free?
> 
> This is possible, but the question is why to make the code more complex?

because  it's broken. Or Am I missing something?


> > Anyway, alloc_fdmem() also don't works as author expected.
> 
> Pardon my ignorance, why? (There are more similar users:
> init_section_page_cgroup, sys_add_key, ext4_fill_flex_info and many others.)

I think init_section_page_cgroup is ok. it's called at boot time. we don't enter forever page reclaim.

but other case, I don't know the reason. I guess they also have specific assumption.
I only said, generically it isn't right.



