Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0E0OKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:10:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:41038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0E0OKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:10:13 -0400
Date: Thu, 27 May 2010 07:12:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 11/11] Use down_read_critical() for /proc/<pid>/exe and
 /proc/<pid>/maps files
Message-ID: <20100527071205.7095a541@infradead.org>
In-Reply-To: <1274733081-4623-12-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-12-git-send-email-walken@google.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 13:31:21 -0700
Michel Lespinasse <walken@google.com> wrote:

> This helps in the following situation:
> - Thread A takes a page fault while reading or writing memory.
>   do_page_fault() acquires the mmap_sem for read and blocks on disk
>   (either reading the page from file, or hitting swap) for a long
> time.
> - Thread B does an mmap call and blocks trying to acquire the mmap_sem
>   for write
> - Thread C is a monitoring process trying to read every /proc/pid/maps
>   in the system. This requires acquiring the mmap_sem for read.
> Thread C blocks behind B, waiting for A to release the rwsem.  If
> thread C could be allowed to run in parallel with A, it would
> probably get done long before thread A's disk access completes, thus
> not actually slowing down thread B.
> 
> Test results with down_read_critical_test (10 seconds):


this is a really bad idea btw

we've had many issues in the past, when this was an unfair lock, that
"top" or other similar things, caused basically a DoS......
now any process that can get to /proc/<pid>/exe or maps, can do this in
a tight enough loop so that the actual process will never get the lock
for write. BAD IDEA ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
