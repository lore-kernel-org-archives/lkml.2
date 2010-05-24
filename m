Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0EXVMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:12:36 -0400
Received: from fifo99.com ([67.223.236.141]:55424 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703Ab0EXVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:12:35 -0400
Subject: Re: [PATCH 11/11] Use down_read_critical() for /proc/<pid>/exe and
 /proc/<pid>/maps files
From: Daniel Walker <dwalker@fifo99.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <1274733081-4623-12-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	 <1274733081-4623-12-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 14:12:21 -0700
Message-ID: <1274735541.11372.54.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 13:31 -0700, Michel Lespinasse wrote:
> This helps in the following situation:
> - Thread A takes a page fault while reading or writing memory.
>   do_page_fault() acquires the mmap_sem for read and blocks on disk
>   (either reading the page from file, or hitting swap) for a long time.
> - Thread B does an mmap call and blocks trying to acquire the mmap_sem
>   for write
> - Thread C is a monitoring process trying to read every /proc/pid/maps
>   in the system. This requires acquiring the mmap_sem for read. Thread C
>   blocks behind B, waiting for A to release the rwsem.  If thread C
>   could be allowed to run in parallel with A, it would probably get done
>   long before thread A's disk access completes, thus not actually slowing
>   down thread B.
> 
> Test results with down_read_critical_test (10 seconds):

Did you try using queuing on scheduling priorities in some way to do
this? It seems like your setting it up so Thread C is more important
than Thread B, but your using code to dictate that instead of scheduling
priorities. It would make more sense to me if the threads had priorities
to dictate what's "critical" and what's not.

Daniel

