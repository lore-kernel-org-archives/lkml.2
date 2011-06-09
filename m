Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab1FIEpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 00:45:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44336 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1FIEpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 00:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <1307591659.3980.37.camel@edumazet-laptop>
References: <20110609004435.14550.qmail@science.horizon.com>
 <4DF037C6.4000507@linux.intel.com> <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
 <1307591659.3980.37.camel@edumazet-laptop>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 9 Jun 2011 00:44:50 -0400
Message-ID: <BANLkTikJ_LzmytD1UHTRK5c3Qaj3+pbGHA@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Darren Hart <dvhart@linux.intel.com>,
        George Spelvin <linux@horizon.com>, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 23:54, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 08 juin 2011 à 23:38 -0400, Andrew Lutomirski a écrit :
>> Huh?
>>
>> I still don't understand why userspace ought to need to deny read
>> access to a file to prevent DoS.  I think it's entirely reasonable for
>> userspace to make the assumption that users with read access cannot
>> make changes visible to writers unless explicitly documented (i.e.
>> file locking, which is so thoroughly broken that it shouldn't be taken
>> as an example of how to design anything).
>>
>> Given that current kernels make this use safe and the proposal is to
>> make it unsafe, I think it's worth designing the interface to avoid
>> introducing new security problems.
>
> I am very tired of this discussion, you repeat the same arguments over
> and over.
>
> You can not prevent DOS on a machine if you allow a process to RO map
> your critical files (where you put futexes), because you allow this
> process to interfere with critical cache lines bouncing between cpus.
>
> Really, please forget about this crazy idea of allowing foreigners to
> _read_ or memory _map_ your files. Dont do it.

The issue is NOT that things get "slow".  There are lots of ways to do that
in an untrusted process on a normal Linux system.  Chewing CPU time
and reading random small files from all over the disk are the easiest ones,
and most Linux distributions usually ship lots of such files in directories
such as /usr/share/doc, /usr/share/zoneinfo, various locales directories, etc.

The issue is that this allows you to eat wakeups and make processes hang.

One relatively trivial example would be a database library like libdb or
similar.  The library could very reasonably use futexes to communicate
between multiple simultaneous threads writing to the same database
file.  Since the library wants to be well-behaved and avoid thundering
herd problems, it only issues a single wakeup for each lock release.

Now you have another program which uses the same database library
to do lockless queries of the of the DB file.  This is all well and good
except that it can now permanently hang an unlimited number of writer
threads in FUTEX_WAIT with trivial effort and virtually zero CPU.

All the attacker process needs to do is mmap() one page containing
one lock that the victim threads take occasionally and do this in a loop:
    int *victimfutex = [...];
    while(1)
        futex(victimfutex, *victimfutex, FUTEX_WAIT, NULL, NULL, 0);

Suddenly read-only access to *ANY* database file that happens to
use an in-file futex means that you can hang the database... period.
If you write it in ASM, you could even probably start a whole bunch
of threads in parallel by sharing the same stack.

Even better from a DoS standpoint, this does not trigger any resource
limits the way other attacks would, because you are sleeping 99.999%
of the time and are using no memory.  On top of that, once all of the
program's threads are stuck you can exit and it will just stay stuck.

This kind of thing is incredibly common in web-applications and other
similar environments, where "www-data" should be allowed to query
various file databases which are maintained by another daemon.

If the C library happens to use an in-file futex for arbitrating processes
writing to /var/log/utmp or /var/log/lastlog, it suddenly becomes trivial
to lock up every login process.

That is why FUTEX_WAIT needs separate handling for read-only files.

Cheers,
Kyle Moffett
