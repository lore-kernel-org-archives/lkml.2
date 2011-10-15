Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1JOS7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:59:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55758 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1JOS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:59:17 -0400
Date: Sat, 15 Oct 2011 22:59:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111015185909.GZ14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014171033.GC4294@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:10:33AM -0700, Tejun Heo wrote:
> Hello,
> 

Hi Tejun, sorry for a bit delayed reply,

> (cc'ing Oleg and Linus, and quoting whole body)
> 
> On Fri, Oct 14, 2011 at 03:04:21PM +0400, Cyrill Gorcunov wrote:
> > This patch add ability to run that named "checkpoint" files by
> > enhancing Elf file format, which includes
> > 
> >  - new Elf file type ET_CKPT
> > 
> >  - three additional program header types PT_CKPT_VMA, PT_CKPT_CORE
> >    and PT_CKPT_PAGES.
> > 
> >      PT_CKPT_VMA -- holds 'vma_entry' structure, which describes the
> >      memory area the kernel should map. It also might contain a file descriptor
> >      so the kernel will be mapping a file povided. Usually such file get
> >      opened by user-space helper tool which prepares 'vma_entry' structure
> >      for the kernel.
> > 
> >      PT_CKPT_CORE -- 'core_entry' structure (registers, tls, tasks specific
> >      settings). The structure is defined as a 16K container which should be
> >      enough for most cases. 8K of it is reserved for arch specific settings.
> > 
> >      PT_CKPT_PAGES -- a set of all pages which contents we should restored.
> > 
> > Apart from Elf extension flush_old_exec() has been splitted to two
> > functions -- the former flush_old_exec() and flush_exec_keep_thread().
> > The later doesn't call for de_thread() allowing to keep threads
> > relationship. Also arch_setup_additional_pages_at() helper added
> > to setup vdso at predefined address.
> > 
> > At moment only pure x86-64 architecture is supported.
> 
> I don't think this is a good idea.  We already have most of interface
> necessary for restoring task state and there's no need to put it into
> the kernel as one piece.  If there's something which can't be done
> from userland using existing interfaces, let's please discuss what
> they are and whether they can be resolved differently first.
> 

One of the problem is restoration of memory areas which are initially
provided by a kernel itself (such as vdso), the mm_struct members
such as start_code/end_code/brk and friends which are formerly set by
elf loader. Strictly speaking most of them (except brk) should not affect
process restored BUT they are exported into /proc which allows user space
to examinate them and hell knows how programs may react on such values
changed when they get restored (and I imagine a program which poll this
settings and exit out once they changed, _yes_ most programs should not
do that I believe but still... I thought if we implement c/r feature
the restored process should see himself exactly as it was before, at
least this is a final goal).

> The exec path is very intricate as it is and it would be very easy to
> introduce security or other bugs by altering its basic behavior.  exec
> presumes destruction of (most of) the current process and all its
> other threads and replacing them w/ fresh states from an executable.
> The scary part - interaction with process hierarchy and zapping of the
> current state - is handled from the core exec code.
>
> I see that you removed zapping to allow restoring multi-threaded
> process, which seems quite scary to me.  It might be okay, I don't
> know, but IMHO it just isn't a very good idea to introduce such
> variation to basic exec behavior for this rather narrow use case.
>
> In addition, leaving it alone doesn't really solve multi-threaded
> restoring, does it?  Who sets the task states for other threads?  The

The user-space tool. Eventually we are dreaming about restart with cgroups.
And the former process hierarchy is supposed to be recreated by user-space
tool as well.

Note I know that not all states are handled and most probably here some
bugs hidden in current patch as well, but it was the main reason to show
it up early, just to gather people opinions.

> current code doesn't seem to be doing anything but if you're gonna add
> it later, how are you gonna synchronize other threads?  If not, what's
> the point of pushing this chunk in when userland task state
> restoration is necessary anyway?
>
> So, at the moment, I'm rather strongly against this approach.
>

On Fri, Oct 14, 2011 at 10:10:33AM -0700, Tejun Heo wrote:
>> I see that you removed zapping to allow restoring multi-threaded
>> process, which seems quite scary to me.  It might be okay, I don't
>> know, but IMHO it just isn't a very good idea to introduce such
>> variation to basic exec behavior for this rather narrow use case.
>
>* It's still calling exec_mmap(), so the exec'ing thread will be on
>  the new mm while other threads would still be on the old one.

Hmm, seems I missed this in first place, thanks (note even having
new mm here the user-space tool will handle shared-memory allocations).

>* There are operations which assume that the calling task is
>  de-threaded and thus has exclusive access to data structures which
>  can be shared among the thread group (e.g. signal struct).  How are
>  accesses to them synchronized?

Seems it;s being not yet implemented, thanks.

>* What about properties which should be reset and then shared by
>  threads by inheriting (credentials, comm, self_exec_id and so on)?
>  e.g. new thread follows exec-time imposed rules but old ones keep
>  their original credentials.
>
>So, no, it really doesn't look good.

Anyway, thanks a HUGE for review, Tejun! I really appreciate!!

	Cyrill
