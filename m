Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0JEO5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab0JEO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:57:14 -0400
Message-ID: <4CAB3C76.7040005@redhat.com>
Date: Tue, 05 Oct 2010 10:55:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/3] V2: Reduce mmap_sem hold times during file backed
 page faults
References: <1286265215-9025-1-git-send-email-walken@google.com>
In-Reply-To: <1286265215-9025-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:53 AM, Michel Lespinasse wrote:
> This is the second iteration of our change dropping mmap_sem when a disk
> access occurs during a page fault to a file backed VMA.
>
> Changes since V1:
> - Cleaned up 'Retry page fault when blocking on disk transfer' applying
>    linus's suggestions
> - Added 'access_error API cleanup'
>
> Tests:
>
> - microbenchmark: thread A mmaps a large file and does random read accesses
>    to the mmaped area - achieves about 55 iterations/s. Thread B does
>    mmap/munmap in a loop at a separate location - achieves 55 iterations/s
>    before, 15000 iterations/s after.
> - We are seeing related effects in some applications in house, which show
>    significant performance regressions when running without this change.
> - I am looking for a microbenchmark to expose the worst case overhead of
>    the page fault retry. Would FIO be a good match for that use ?

I imagine MySQL could show the problem, on a system with
so much memory pressure that part of MySQL itself gets
swapped out (a slightly too large innodb buffer?).

Without your patches, a new database thread can only be
created in-between page faults.  With your patches, a
new thread can be started even while other threads are
waiting on page faults.

More importantly, multiple threads can start pagein
IO simultaneously after memory pressure has let up.
This should allow the system to go back to normal
performance much faster after a load spike has passed.
