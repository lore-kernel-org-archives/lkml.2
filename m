Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3AEGkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 01:40:40 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:40134 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3AEGkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 01:40:37 -0500
Message-ID: <1357368032.1927.5.camel@mesosphere.localdomain>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
From: Roman Dubtsov <dubtsov@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Date: Sat, 05 Jan 2013 13:40:32 +0700
In-Reply-To: <20130104115748.GA8830@google.com>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
	 <CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
	 <1357232977.1886.17.camel@mesosphere.localdomain>
	 <20130104115748.GA8830@google.com>
Content-Type: multipart/mixed; boundary="=-mJcNsJAVGBaMINeGlaY/"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mJcNsJAVGBaMINeGlaY/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2013-01-04 at 03:57 -0800, Michel Lespinasse wrote:
> On Fri, Jan 04, 2013 at 12:09:37AM +0700, Roman Dubtsov wrote:
> > On Wed, 2013-01-02 at 16:09 -0800, Michel Lespinasse wrote:
> > > > Is there an interest in fixing this or concurrent mmaps() from the same
> > > > process are too much of a corner case to worry about it?
> > > 
> > > Funny this comes up again. I actually have a patch series that is
> > > supposed to do that:
> > > [PATCH 0/9] Avoid populating unbounded num of ptes with mmap_sem held
> > > 
> > > However, the patches are still pending, didn't get much review
> > > (probably not enough for Andrew to take them at this point), and I
> > > think everyone forgot about them during the winter break.
> > > 
> > > Care to have a look at that thread and see if it works for you ?
> > > 
> > > (caveat: you will possibly also need "[PATCH 10/9] mm: make
> > > do_mmap_pgoff return populate as a size in bytes, not as a bool" to
> > > make the series actually work for you)
> > 
> > I applied the patches on top of 3.7.1. Here're the results for 4 threads
> > concurrently mmap()-ing 10 64MB buffers in a loop without munmap()-s.
> > The data is from a Nehalem i7-920 single-socket 4-core CPU. I've also
> > added the older data I have for the 3.6.11 (patched and not) for
> > reference.
> > 
> > 3.6.11 vanilla, do not populate: 0.001 seconds
> > 3.6.11 vanilla, populate via a loop: 0.216 seconds
> > 3.6.11 vanilla, populate via MAP_POPULATE: 0.358 seconds 
> > 
> > 3.6.11 + crude patch, do not populate: 0.002 seconds
> > 3.6.11 + crude patch, populate via loop: 0.215 seconds
> > 3.6.11 + crude patch, populate via MAP_POPULATE: 0.217 seconds
> > 
> > 3.7.1 vanilla, do not populate: 0.001 seconds
> > 3.7.1 vanilla, populate via a loop: 0.216 seconds
> > 3.7.1 vanilla, populate via MAP_POPULATE: 0.411 seconds
> > 
> > 3.7.1 + patch series, do not populate: 0.001 seconds
> > 3.7.1 + patch series, populate via loop: 0.216 seconds
> > 3.7.1 + patch series, populate via MAP_POPULATE: 0.273 seconds
> > 
> > So, the patch series mentioned above do improve performance but as far
> > as I can read the benchmarking data there's still some performance left
> > on the table.
> 
> Interesting. I expect you are using anon memory, so it's likely that
> mm_populate() holds the mmap_sem read side for the entire duration of
> the 64MB populate.
> 
> Just curious, does the following help ?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e4ab66b94bb8..f65a4b3b2141 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1627,6 +1627,12 @@ static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long add
>  	       stack_guard_page_end(vma, addr+PAGE_SIZE);
>  }
>  
> +/* not upstreamable as is, just for the sake of testing */
> +static inline int rwsem_is_contended(struct rw_semaphore *sem)
> +{
> +	return (sem->count < 0);
> +}
> +
>  /**
>   * __get_user_pages() - pin user pages in memory
>   * @tsk:	task_struct of target task
> @@ -1854,6 +1860,11 @@ next_page:
>  			i++;
>  			start += PAGE_SIZE;
>  			nr_pages--;
> +			if (nonblocking && rwsem_is_contended(&mm->mmap_sem)) {
> +				up_read(&mm->mmap_sem);
> +				*nonblocking = 0;
> +				return i;
> +			}
>  		} while (nr_pages && start < vma->vm_end);
>  	} while (nr_pages);
>  	return i;
> 
> Linus didn't like rwsem_is_contended() when I implemented the mlock
> side of this a couple years ago, but maybe we can change his mind now.
> 
> If this doesn't help, could you please send me your test case ? I
> think you described enough of it that I would be able to reproduce it
> given some time, but it's just easier if you send me a short C file :)
> 

It does not, the results are more or less the same. I've attached my
testcase. It does map anonymous memory. It also uses OpenMP for
threading because I'm lazy, so it requires passing -fopenmp to gcc and
the number of threads it runs is defined via OMP_NUM_THREADS environment
variable. There are also two macros that influence test's behavior:

- POPULATE_VIA_LOOP -- makes the test populate memory using a loop
- POPULATE_VIA_MMAP -- makes the test populate memory via MAP_POPULATE

If none of the macros are defined, the test does not populate memory.


--=-mJcNsJAVGBaMINeGlaY/
Content-Disposition: attachment; filename="t.c"
Content-Type: text/x-csrc; name="t.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

#include "omp.h"

#ifndef BUF_SIZE
#define BUF_SIZE (64 * 1024 * 1024)
#endif

#ifndef PAGE_SIZE
#define PAGE_SIZE (4 * 1024)
#endif

#ifdef POPULATE_VIA_MMAP
#define MMAP_FLAGS (MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE)
#else
#define MMAP_FLAGS (MAP_ANONYMOUS | MAP_PRIVATE)
#endif

int main(int argc, char **argv)
{
#pragma omp parallel
	{
	}

	double t0 = omp_get_wtime();
#pragma omp parallel
	{
		int i;
		for (i = 0; i < 10; i++) {
			char *p = mmap(NULL, BUF_SIZE,
				PROT_READ | PROT_WRITE, MMAP_FLAGS, -1, 0);
#ifdef POPULATE_VIA_LOOP
			size_t j;
			for (j = 0; j < BUF_SIZE; j += PAGE_SIZE)
				p[j] = 0;
#endif
		}
	}
	double t1 = omp_get_wtime();
	printf("%d\t%f\n", omp_get_max_threads(), t1 - t0);

	return 0;
}

--=-mJcNsJAVGBaMINeGlaY/--

