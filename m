Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0GOOLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:11:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39020 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab0GOOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qFUPvm6YLmX2uIeLHWkBoS23R951OsyrrQmaVM1L69lw1fPfKnMAz2X8ipxhpfFoXg
         7SxEyR7MmAm9Kb7rPSWX1gnQ2cbUoiYNmDvr0F3Kg/A9y7k8M8pzDY/PjXqnq7ssBvnH
         FooxiGjuB5HF/5JrOAQXntEeNicG22TrWHKZI=
Date: Thu, 15 Jul 2010 16:11:22 +0200
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
Message-ID: <20100715141118.GA6417@nowhere>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com> <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal> <20100714223116.GB14533@nowhere> <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 03:56:43PM -0700, Linus Torvalds wrote:
> On Wed, Jul 14, 2010 at 3:31 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > Until now I didn't because I clearly misunderstand the vmalloc internals. I'm
> > not even quite sure why a memory allocated with vmalloc sometimes can be not
> > mapped (and then fault once for this to sync). Some people have tried to explain
> > me but the picture is still vague to me.
> 
> So the issue is that the system can have thousands and thousands of
> page tables (one for each process), and what do you do when you add a
> new kernel virtual mapping?
> 
> You can:
> 
>  - make sure that you only ever use _one_ single top-level entry for
> all vmalloc issues, and can make sure that all processes are created
> with that static entry filled in. This is optimal, but it just doesn't
> work on all architectures (eg on 32-bit x86, it would limit the
> vmalloc space to 4MB in non-PAE, whatever)


But then, even if you ensure that, don't we need to also fill lower level
entries for the new mapping.

Also, why is this a worry for vmalloc but not for kmalloc? Don't we also
risk to add a new memory mapping for new memory allocated with kmalloc?



>  - at vmalloc time, when adding a new page directory entry, walk all
> the tens of thousands of existing page tables under a lock that
> guarantees that we don't add any new ones (ie it will lock out fork())
> and add the required pgd entry to them.
> 
>  - or just take the fault and do the "fill the page tables" on demand.
> 
> Quite frankly, most of the time it's probably better to make that last
> choice (unless your hardware makes it easy to make the first choice,
> which is obviously simplest for everybody). It makes it _much_ cheaper
> to do vmalloc. It also avoids that nasty latency issue. And it's just
> simpler too, and has no interesting locking issues with how/when you
> expose the page tables in fork() etc.
> 
> So the only downside is that you do end up taking a fault in the
> (rare) case where you have a newly created task that didn't get an
> even newer vmalloc entry.


But then how did the previous tasks get this new mapping? You said
we don't walk through every process page tables for vmalloc.

I would understand this race if we were to walk on every processes page
tables and add the new mapping on them, but we missed one new task that
forked or so, because we didn't lock (or just rcu).



> And that fault can sometimes be in an
> interrupt or an NMI. Normally it's trivial to handle that fairly
> simple nested fault. But NMI has that inconvenient "iret unblocks
> NMI's, because there is no dedicated 'nmiret' instruction" problem on
> x86.


Yeah.


So the parts of the problem I don't understand are:

- why don't we have this problem with kmalloc() ?
- did I understand well the race that makes the fault necessary,
  ie: we walk the tasklist lockless, add the new mapping if
  not present, but we might miss a task lately forked, but
  the fault will fix that.

Thanks.

