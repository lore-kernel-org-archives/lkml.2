Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2EUWAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:00:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59635 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2EUWAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120521143701.74ab2d0b.akpm@linux-foundation.org>
References: <20120209092642.GE16600@linux.vnet.ibm.com> <tip-2b144498350860b6ee9dc57ff27a93ad488de5dc@git.kernel.org>
 <20120521143701.74ab2d0b.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 15:00:28 -0700
X-Google-Sender-Auth: gN8XNI3tGvt5IEFB_AVi-3VjQi4
Message-ID: <CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
Subject: Re: [tip:perf/uprobes] uprobes, mm, x86: Add the ability to install
 and remove uprobes breakpoints
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        anton@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        oleg@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jkenisto@us.ibm.com, andi@firstfloor.org,
        hch@infradead.org, ananth@in.ibm.com, vda.linux@googlemail.com,
        masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com, sfr@canb.auug.org.au, roland@hack.frob.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 2:37 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> hm, we seem to have conflicting commits between mainline and linux-next.
> During the merge window.  Again.  Nobody knows why this happens.

I didn't have my trivial cleanup branches in linux-next, I'm afraid.
Usually my pending cleanups are just small patches that I carry along
without even committing them, this time around I had slightly more
than that.

>
> static void unmap_single_vma(struct mmu_gather *tlb,
>                struct vm_area_struct *vma, unsigned long start_addr,
>                unsigned long end_addr,
>                struct zap_details *details)
> {
>        unsigned long start = max(vma->vm_start, start_addr);
>        unsigned long end;
>
>        if (start >= vma->vm_end)
>                return;
>        end = min(vma->vm_end, end_addr);
>        if (end <= vma->vm_start)
>                return;
>
> <<<<<<< HEAD
> =======
>        if (vma->vm_file)
>                uprobe_munmap(vma, start, end);
>
>        if (vma->vm_flags & VM_ACCOUNT)
>                *nr_accounted += (end - start) >> PAGE_SHIFT;
>
>>>>>>>> linux-next/akpm-base

Just remove the VM_ACCOUNT and *nr_accounted lines - they're done in
the caller now. They always should have been, I'm not sure why it was
in the "walk the page tables" path, which has nothing to do with it.

That said, I think that's true of uprobes too. Why the f*ck would
uprobes do it's "munmap" operation when we walk the page tables? This
function was called by more than just the actual unmapping, it was
called by stuff that wants to zap the pages but leave the mapping
around.

So that uprobe_munmap() could probably also be better moved into the
caller - where we actually remove the vma. Maybe.

                    Linus
