Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3ACRJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:09:43 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:63723 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3ACRJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:09:42 -0500
Message-ID: <1357232977.1886.17.camel@mesosphere.localdomain>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
From: Roman Dubtsov <dubtsov@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Date: Fri, 04 Jan 2013 00:09:37 +0700
In-Reply-To: <CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
	 <CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 16:09 -0800, Michel Lespinasse wrote:
> > Is there an interest in fixing this or concurrent mmaps() from the same
> > process are too much of a corner case to worry about it?
> 
> Funny this comes up again. I actually have a patch series that is
> supposed to do that:
> [PATCH 0/9] Avoid populating unbounded num of ptes with mmap_sem held
> 
> However, the patches are still pending, didn't get much review
> (probably not enough for Andrew to take them at this point), and I
> think everyone forgot about them during the winter break.
> 
> Care to have a look at that thread and see if it works for you ?
> 
> (caveat: you will possibly also need "[PATCH 10/9] mm: make
> do_mmap_pgoff return populate as a size in bytes, not as a bool" to
> make the series actually work for you)

I applied the patches on top of 3.7.1. Here're the results for 4 threads
concurrently mmap()-ing 10 64MB buffers in a loop without munmap()-s.
The data is from a Nehalem i7-920 single-socket 4-core CPU. I've also
added the older data I have for the 3.6.11 (patched and not) for
reference.

3.6.11 vanilla, do not populate: 0.001 seconds
3.6.11 vanilla, populate via a loop: 0.216 seconds
3.6.11 vanilla, populate via MAP_POPULATE: 0.358 seconds 

3.6.11 + crude patch, do not populate: 0.002 seconds
3.6.11 + crude patch, populate via loop: 0.215 seconds
3.6.11 + crude patch, populate via MAP_POPULATE: 0.217 seconds

3.7.1 vanilla, do not populate: 0.001 seconds
3.7.1 vanilla, populate via a loop: 0.216 seconds
3.7.1 vanilla, populate via MAP_POPULATE: 0.411 seconds

3.7.1 + patch series, do not populate: 0.001 seconds
3.7.1 + patch series, populate via loop: 0.216 seconds
3.7.1 + patch series, populate via MAP_POPULATE: 0.273 seconds

So, the patch series mentioned above do improve performance but as far
as I can read the benchmarking data there's still some performance left
on the table.

Regards,
Roma

