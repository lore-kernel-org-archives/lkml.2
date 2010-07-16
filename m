Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab0GPMAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:00:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32864 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab0GPMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fWCABvZjYUKbMzX/zPQ+3KXrivPM/YyEFbPKmUeYA0QigUUrRdisxgCmxKvO/SzY2q
         F8lr6B7NtEwuaL/LnJfOuuPR1vMfuyFpGsznCb9Dy1M3/+K3zeNUDW0cGPSlnY9WoIjs
         sDOEjv1Qjbjfx9C+BC3W0LYv/tMEp8XuPtLWU=
Date: Fri, 16 Jul 2010 14:00:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100716120012.GC5377@nowhere>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com> <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal> <20100714223116.GB14533@nowhere> <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com> <20100715141118.GA6417@nowhere> <AANLkTing-_-Oyq5EBT4miTPJf4zDuwIqLi6pT7CaE6EP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTing-_-Oyq5EBT4miTPJf4zDuwIqLi6pT7CaE6EP@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 07:51:55AM -0700, Linus Torvalds wrote:
> On Thu, Jul 15, 2010 at 7:11 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Jul 14, 2010 at 03:56:43PM -0700, Linus Torvalds wrote:
> >> You can:
> >>
> >>  - make sure that you only ever use _one_ single top-level entry for
> >> all vmalloc issues, and can make sure that all processes are created
> >> with that static entry filled in. This is optimal, but it just doesn't
> >> work on all architectures (eg on 32-bit x86, it would limit the
> >> vmalloc space to 4MB in non-PAE, whatever)
> >
> > But then, even if you ensure that, don't we need to also fill lower level
> > entries for the new mapping.
> 
> Yes, but now they are all mapped by the one *shared* top-level entry.
> 
> Think about it.
> 
> [ Time passes ]
> 
> End result: if you can map the whole vmalloc area with a single
> top-level entry that is shared by all processes, and can then just
> fill in the lower levels when doing actual allocations, it means that
> all processes will automatically get the entries added, and do not
> need any fixups.
> 
> In other words, the page tables will be automatically correct and
> filled in for everybody - without having to traverse any lists,
> without any extra locking, and without any races. So this is efficient
> and simple, and never needs any faulting to fill in page tables later
> on.
> 
> (Side note: "single top-level entry" could equally well be "multiple
> preallocated entries covering the whole region": the important part is
> not really the "single entry", but the "preallocated and filled into
> every page directory from the start" part)



Right, I got it. Thanks for these explanations.



> 
> > Also, why is this a worry for vmalloc but not for kmalloc? Don't we also
> > risk to add a new memory mapping for new memory allocated with kmalloc?
> 
> No. The kmalloc space is all in the 1:1 kernel mapping, and is always
> mapped. Even with PAGEALLOC_DEBUG, it's always mapped at the top
> level, and even if a particular page is unmapped/remapped for
> debugging, it is done so in the shared kernel page tables (which ends
> up being the above trivial case - there is just a single set of page
> directory entries that are shared by everybody).



Ok.



> >>  - at vmalloc time, when adding a new page directory entry, walk all
> >> the tens of thousands of existing page tables under a lock that
> >> guarantees that we don't add any new ones (ie it will lock out fork())
> >> and add the required pgd entry to them.
> >>
> >>  - or just take the fault and do the "fill the page tables" on demand.
> >>
> >> Quite frankly, most of the time it's probably better to make that last
> >> choice (unless your hardware makes it easy to make the first choice,
> >> which is obviously simplest for everybody). It makes it _much_ cheaper
> >> to do vmalloc. It also avoids that nasty latency issue. And it's just
> >> simpler too, and has no interesting locking issues with how/when you
> >> expose the page tables in fork() etc.
> >>
> >> So the only downside is that you do end up taking a fault in the
> >> (rare) case where you have a newly created task that didn't get an
> >> even newer vmalloc entry.
> >
> > But then how did the previous tasks get this new mapping? You said
> > we don't walk through every process page tables for vmalloc.
> 
> We always add the mapping to the "init_mm" page tables when it is
> created (just a single mm), and when fork creates a new page table, it
> will always copy the kernel mapping parts from the old one. So the
> _common_ case is that all normal mappings are already set up in page
> tables, including newly created page tables.
> 
> The uncommon case is when there is a new page table created _and_ a
> new vmalloc mapping, and the race that happens between those events.
> Whent hat new page table is then later used (and it can be _much_
> later, of course: we're now talking process scheduling, so IO delays
> etc are relevant), it won't necessarily have the page table entries
> for vmalloc stuff that was created since the page tables were created.
> So we fill _those_ in dynamically.



Such new page table created that might race is only about top level page
right? Otherwise it wouldn't race since the top level entries are shared
and then updates inside lower level pages are naturally propagated, if
I understood you well.

So, if only top level pages that gets added can generate such lazily
mapping update, I wonder why I experienced this fault everytime with
my patches.

I allocated 8192 bytes per cpu in a x86-32 system that has only 2 GB.
I doubt there is a top level page table update there at this time with
such a small amount of available memory. But still it faults once on
access.

I have troubles to visualize the race and the problem here.



> 
> But vmalloc mappings should be reasonably rare, and the actual "fill
> them in" cases are much rarer still (since we fill them in page
> directory entries at a time: so even if you make a lot of vmalloc()
> calls, we only _fill_ at most once per page directory entry, which is
> usually a pretty big chunk). On 32-bit x86, for example, we'd fill
> once every 4MB (or 2MB if PAE), and you cannot have a lot of vmalloc
> mappings that large (since the VM space is limited).
> 
> So the cost of filling things in is basically zero, because it happens
> so seldom. And by _allowing_ things to be done lazily, we avoid all
> the locking costs, and all the costs of traversing every single
> possible mm (and there can be many many thousands of those).



Ok.



> > I would understand this race if we were to walk on every processes page
> > tables and add the new mapping on them, but we missed one new task that
> > forked or so, because we didn't lock (or just rcu).
> 
> .. and how do you keep track of which tasks you missed? And no, it's
> not just the new tasks - you have old tasks that have their page
> tables built up too, but need to be updated. They may never need the
> mapping since they may be sleeping and never using the driver or data
> structures that created it (in fact, that's a common case), so filling
> them would be pointless. But if we don't do the lazy fill, we'd have
> to fill them all, because WE DO NOT KNOW.



Right.



> 
> > So the parts of the problem I don't understand are:
> >
> > - why don't we have this problem with kmalloc() ?
> 
> Hopefully clarified.


Indeed.



> > - did I understand well the race that makes the fault necessary,
> >  ie: we walk the tasklist lockless, add the new mapping if
> >  not present, but we might miss a task lately forked, but
> >  the fault will fix that.
> 
> But the _fundamental_ issue is that we do not want to walk the
> tasklist (or the mm_list) AT ALL. It's a f*cking waste of time. It's a
> long list, and nobody cares. In many cases it won't be needed.
> 
> The lazy algorithm is _better_. It's way simpler (we take nested
> faults all the time in the kernel, and it's a particularly _easy_ page
> fault to handle with no IO or no locking needed), and it does less
> work. It really boils down to that.


Yeah, agreed. But I'm still confused about when exactly we need to fault
(doubts I have detailed in my question above).



> So it's not the lazy page table fill that is the problem. Never has
> been. We've been doing the lazy fill for a long time, and it was
> simple and useful way back when.
> 
> The problem has always been NMI, and nothing else. NMI's are nasty,
> and the x86 NMI blocking is insane and crazy.
> 
> Which is why I'm so adamant that this should be fixed in the NMI code,
> and we should _not_ talk about trying to screw up other, totally
> unrelated, code. The lazy fill really was never the problem.


Yeah agreed.

Thanks for your explanations!

