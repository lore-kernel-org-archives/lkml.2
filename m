Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab1EOPaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:30:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39366 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1EOPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WBeAxshywQwiSCN5o1QSrpvYjQnO9EeJQEQOzHfGzeZbxRV5SMyeuzS47VABJLNgjs
         wypLIP6ewxars8uSmKH3u2PtGPSW+fy5cKtFToGzCg9EdnnOogZTJNCF7Rco1CVSlb9a
         RK27UZRv4g2ukFJvvDSvXq+nbUZIpSgO0MSSU=
Message-ID: <4DCFF186.1070404@gmail.com>
Date: Sun, 15 May 2011 18:30:14 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rw_semaphore down_write a lot faster if wrapped by mutex ?!
References: <4DCFE467.1070401@gmail.com>
In-Reply-To: <4DCFE467.1070401@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 05:34 PM, Török Edwin wrote:
> Hi semaphore/mutex maintainers,
> 
> Looks like rw_semaphore's down_write is not as efficient as it could be.
> It can have a latency in the miliseconds range, but if I wrap it in yet
> another mutex then it becomes faster (100 us range).
> 
> One difference I noticed betwen the rwsem and mutex, is that the mutex
> code does optimistic spinning. But adding something similar to the
> rw_sem code didn't improve timings (it made things worse).
> My guess is that this has to do something with excessive scheduler
> ping-pong (spurious wakeups, scheduling a task that won't be able to
> take the semaphore, etc.), I'm not sure what are the best tools to
> confirm/infirm this. perf sched/perf lock/ftrace ?

Hmm, with the added mutex the reader side of mmap_sem only sees one
contending locker at a time (the rest of write side contention is hidden
by the mutex), so this might give a better chance for the readers to
run, even in face of heavy write-side contention.
The up_write will see there are no more writers and always wake the
readers, whereas without the mutex it'll wake the other writer.

Perhaps rw_semaphore should have a flag to prefer waking readers over
writers, or take into consideration the number of readers waiting when
waking a reader vs a writer.

Waking a writer will cause additional latency, because more readers will
go to sleep:
 latency = (enqueued_readers / enqueued_writers) * (avg_write_hold_time
+ context_switch_time)

Whereas waking (all) the readers will delay the writer only by:
 latency = avg_reader_hold_time + context_switch_time

If the semaphore code could (approximately) measure these, then maybe it
would be able to better make a choice for future lock requests based on
(recent) lock contention history.

Best regards,
--Edwin
