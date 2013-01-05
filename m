Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3AEHnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:43:09 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62114 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3AEHnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:43:07 -0500
MIME-Version: 1.0
In-Reply-To: <1357368032.1927.5.camel@mesosphere.localdomain>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
	<CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
	<1357232977.1886.17.camel@mesosphere.localdomain>
	<20130104115748.GA8830@google.com>
	<1357368032.1927.5.camel@mesosphere.localdomain>
Date: Fri, 4 Jan 2013 23:43:05 -0800
Message-ID: <CANN689HUyc4WyM5irQ6ru+80tf=Fk53QH3ynNJFSTg2ig3dk9A@mail.gmail.com>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
From: Michel Lespinasse <walken@google.com>
To: Roman Dubtsov <dubtsov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 10:40 PM, Roman Dubtsov <dubtsov@gmail.com> wrote:
> On Fri, 2013-01-04 at 03:57 -0800, Michel Lespinasse wrote:
>> If this doesn't help, could you please send me your test case ? I
>> think you described enough of it that I would be able to reproduce it
>> given some time, but it's just easier if you send me a short C file :)
>
> It does not, the results are more or less the same. I've attached my
> testcase. It does map anonymous memory. It also uses OpenMP for
> threading because I'm lazy, so it requires passing -fopenmp to gcc and
> the number of threads it runs is defined via OMP_NUM_THREADS environment
> variable. There are also two macros that influence test's behavior:
>
> - POPULATE_VIA_LOOP -- makes the test populate memory using a loop
> - POPULATE_VIA_MMAP -- makes the test populate memory via MAP_POPULATE
>
> If none of the macros are defined, the test does not populate memory.

Heh, very interesting. As it turns out, the problem gets MUCH worse as
the number of threads increase.

We are populating the anon mapping with huge pages. In the
POPULATE_VIA_LOOP case, we are just taking a page fault every 2MB and
filling it up with a zeroed huge page - most of the runtime comes from
clearing the huge page.

In the POPULATE_VIA_MMAP, follow_page() is called at 4KB increment
addresses, and it takes the mm->page_table_lock 511 times out of 512
(that is, every time it falls within a huge page that's just been
populated). So all OMP_NUM_THREADS threads are constantly bouncing
over the mm->page_table_lock, and getting terrible performance as a
result.

Thanks for the report. I don't have a patch just now, but this does
seem very solvable.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
