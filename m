Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2I0H1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:27:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:47935 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab2I0H1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:27:39 -0400
Date: Thu, 27 Sep 2012 00:17:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Borislav Petkov <bp@alien8.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
In-Reply-To: <20120926213723.GA27692@liondog.tnic>
Message-ID: <alpine.DEB.2.02.1209270013270.5162@asgard.lang.hm>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com> <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net> <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com> <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com> <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com> <20120926163233.GA5339@x1.osrc.amd.com> <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, Borislav Petkov wrote:

>> It always selected target_cpu, but the fact is, that doesn't really
>> sound very sane. The target cpu is either the previous cpu or the
>> current cpu, depending on whether they should be balanced or not. But
>> that still doesn't make any *sense*.
>>
>> In fact, the whole select_idle_sibling() logic makes no sense
>> what-so-ever to me. It seems to be total garbage.
>>
>> For example, it starts with the maximum target scheduling domain, and
>> works its way in over the scheduling groups within that domain. What
>> the f*ck is the logic of that kind of crazy thing? It never makes
>> sense to look at a biggest domain first. If you want to be close to
>> something, you want to look at the *smallest* domain first. But
>> because it looks at things in the wrong order, it then needs to have
>> that inner loop saying "does this group actually cover the cpu I am
>> interested in?"
>>
>> Please tell me I am mis-reading this?
>
> First of all, I'm so *not* a scheduler guy so take this with a great
> pinch of salt.
>
> The way I understand it is, you either want to share L2 with a process,
> because, for example, both working sets fit in the L2 and/or there's
> some sharing which saves you moving everything over the L3. This is
> where selecting a core on the same L2 is actually a good thing.
>
> Or, they're too big to fit into the L2 and they start kicking each-other
> out. Then you want to spread them out to different L2s - i.e., different
> HT groups in Intel-speak.

an observation from an outsider here.

if you do overload a L2 cache, then the core will be busy all the time and 
you will end up migrating a task away from that core.

It seems to me that trying to figure out if you are going to overload the 
L2 is an impossible task, so just assume that it will all fit, and the 
worst case is you have one balancing cycle where you can't do as much work 
and then the normal balancing will kick in and move something anyway.

over the long term, the work lost due to not moving optimally right away 
is probably much less than the work lost due to trying to figure out the 
perfect thing to do.

and since the perfect thing to do is going to be both workload and chip 
specific, trying to model that in your decision making is a lost cause.

David Lang
