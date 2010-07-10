Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0GJRZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 13:25:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab0GJRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 13:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100710070650.GA16248@elte.hu>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
	<Hc02ROPrUsG.A.vs.ls7NMB@chimera>
	<20100710014504.GC5269@nowhere>
	<20100710070650.GA16248@elte.hu>
Date: Sat, 10 Jul 2010 10:24:28 -0700
Message-ID: <AANLkTimvtvrQuIPCZwzPNgVqGWTecay5RktRzBgcf4fu@mail.gmail.com>
Subject: Re: [Bug #15805] reiserfs locking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 12:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Since it's a reproducible deadlock maybe the fix should go upstream faster
> than v2.6.36?

As far as I know, it's only a lockdep warning, not an actual deadlock.
And it's in a class of lockdep warnings that we've had for a long
time, and has never actually triggered as a read deadlock afaik.

I also don't think it's a new warning - or at least I don't see why it
would have started triggering after 2.6.34.

My preferred fix in many ways would be to make the locking in the VM
layer less incestuous. For example, we could fairly easily move the
final

  if (vma->vm_file)
    fput(vma->vm_file);

outside the actual mmap_sem lock (well, "fairly easily" here means
keeping the list of free'd vmas around for longer, probably in the
task_struct thing, and then replacing all the
"up_write(&mm->mmap_sem)" things with a "unlock_mm(mm)" looking
something like

  static void unlock_mm(struct mm_struct *mm)
  {
    struct vm_area_struct *vma_list = current->vma_to_free;
    if (vma_list)
      current->vma_to_free = NULL;
    up_write(&mm->mmap_sem);
    while (vma_list) {
      struct vm_area_struct *vma = vma_list;
      vma_list = vma_list->next;
      fput(vma_list->vm_file);
      kmem_cache_free(vm_area_cachep, vma);
    }
  }

which would fairly trivially delay the actual 'fput()' to after we
hold no locks.

I dunno if it's really worth it, but it doesn't look all that
complicated, and it would avoid at least _some_ lock dependencies.

                     Linus

                     Linus
