Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3ADL5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:57:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3ADL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:57:52 -0500
Date: Fri, 4 Jan 2013 03:57:48 -0800
From: Michel Lespinasse <walken@google.com>
To: Roman Dubtsov <dubtsov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
Message-ID: <20130104115748.GA8830@google.com>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
 <CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
 <1357232977.1886.17.camel@mesosphere.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357232977.1886.17.camel@mesosphere.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 12:09:37AM +0700, Roman Dubtsov wrote:
> On Wed, 2013-01-02 at 16:09 -0800, Michel Lespinasse wrote:
> > > Is there an interest in fixing this or concurrent mmaps() from the same
> > > process are too much of a corner case to worry about it?
> > 
> > Funny this comes up again. I actually have a patch series that is
> > supposed to do that:
> > [PATCH 0/9] Avoid populating unbounded num of ptes with mmap_sem held
> > 
> > However, the patches are still pending, didn't get much review
> > (probably not enough for Andrew to take them at this point), and I
> > think everyone forgot about them during the winter break.
> > 
> > Care to have a look at that thread and see if it works for you ?
> > 
> > (caveat: you will possibly also need "[PATCH 10/9] mm: make
> > do_mmap_pgoff return populate as a size in bytes, not as a bool" to
> > make the series actually work for you)
> 
> I applied the patches on top of 3.7.1. Here're the results for 4 threads
> concurrently mmap()-ing 10 64MB buffers in a loop without munmap()-s.
> The data is from a Nehalem i7-920 single-socket 4-core CPU. I've also
> added the older data I have for the 3.6.11 (patched and not) for
> reference.
> 
> 3.6.11 vanilla, do not populate: 0.001 seconds
> 3.6.11 vanilla, populate via a loop: 0.216 seconds
> 3.6.11 vanilla, populate via MAP_POPULATE: 0.358 seconds 
> 
> 3.6.11 + crude patch, do not populate: 0.002 seconds
> 3.6.11 + crude patch, populate via loop: 0.215 seconds
> 3.6.11 + crude patch, populate via MAP_POPULATE: 0.217 seconds
> 
> 3.7.1 vanilla, do not populate: 0.001 seconds
> 3.7.1 vanilla, populate via a loop: 0.216 seconds
> 3.7.1 vanilla, populate via MAP_POPULATE: 0.411 seconds
> 
> 3.7.1 + patch series, do not populate: 0.001 seconds
> 3.7.1 + patch series, populate via loop: 0.216 seconds
> 3.7.1 + patch series, populate via MAP_POPULATE: 0.273 seconds
> 
> So, the patch series mentioned above do improve performance but as far
> as I can read the benchmarking data there's still some performance left
> on the table.

Interesting. I expect you are using anon memory, so it's likely that
mm_populate() holds the mmap_sem read side for the entire duration of
the 64MB populate.

Just curious, does the following help ?

diff --git a/mm/memory.c b/mm/memory.c
index e4ab66b94bb8..f65a4b3b2141 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1627,6 +1627,12 @@ static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long add
 	       stack_guard_page_end(vma, addr+PAGE_SIZE);
 }
 
+/* not upstreamable as is, just for the sake of testing */
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	return (sem->count < 0);
+}
+
 /**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
@@ -1854,6 +1860,11 @@ next_page:
 			i++;
 			start += PAGE_SIZE;
 			nr_pages--;
+			if (nonblocking && rwsem_is_contended(&mm->mmap_sem)) {
+				up_read(&mm->mmap_sem);
+				*nonblocking = 0;
+				return i;
+			}
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;

Linus didn't like rwsem_is_contended() when I implemented the mlock
side of this a couple years ago, but maybe we can change his mind now.

If this doesn't help, could you please send me your test case ? I
think you described enough of it that I would be able to reproduce it
given some time, but it's just easier if you send me a short C file :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
