Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957Ab2J0BxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 21:53:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab2J0BxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 21:53:22 -0400
Message-ID: <508B3E6E.6060702@vlnb.net>
Date: Fri, 26 Oct 2012 21:52:46 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Nico Williams <nico@cryptonector.com>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net> <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
In-Reply-To: <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:12ux4i/NJdHVDsDeopgDVRHyYFoUMkfkjnkn8+caybI
 MfKnDk4R37mByEkLfZZlGL+Umpyh8O9CmeabP51ienqY2sJiOs
 ELVlSUdMvpeolS0nAGy0mw40oRQMu7CD7OWQOZZenkhBD4vyTZ
 s2pwVkXG4ytLNyE6pbWSvgQ+1wWxeJb8PIWIW4RN3ip1HPaVII
 WWbbhBSD4x+94BqnL5jvZqqEmIukuPGHkeqm4c+BBJIXkSHQOn
 XSjFDNRP/eRD7jXb4sfdYFSqdXGt+86I/76bQoR0/130HmCLs4
 Wrj6LZBnyBZb6G6eTR8vsM7RQo9qChvmIh/xbm6SbDxyYjjLyY
 0/SYjNefwVvPyMh+alsY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nico Williams, on 10/24/2012 05:17 PM wrote:
>> Yes, SCSI has full support for ordered/simple commands designed exactly for
>> that task: [...]
>>
>> [...]
>>
>> But historically for some reason Linux storage developers were stuck with
>> "barriers" concept, which is obviously not the same as ORDERED commands,
>> hence had a lot troubles with their ambiguous semantic. As far as I can tell
>> the reason of that was some lack of sufficiently deep SCSI understanding
>> (how to handle errors, believe that ACA is something legacy from parallel
>> SCSI times, etc.).
>
> Barriers are a very simple abstraction, so there's that.

It isn't simple at all. If you think for some time about barriers from the storage 
point of view, you will soon realize how bad and ambiguous they are.

>> Before that happens, people will keep returning again and again with those
>> simple questions: why the queue must be flushed for any ordered operation?
>> Isn't is an obvious overkill?
>
> That [cache flushing]

It isn't cache flushing, it's _queue_ flushing. You can call it queue draining, if 
you like.

Often there's a big difference where it's done: on the system side, or on the 
storage side.

Actually, performance improvements from NCQ in many cases are not because it 
allows the drive to reorder requests, as it's commonly thought, but because it 
allows to have internal drive's processing stages stay always busy without any 
idle time. Drives often have a long internal pipeline.. Hence the need to keep 
every stage of it always busy and hence why using ORDERED commands is important 
for performance.

> is not what's being asked for here. Just a
> light-weight barrier.  My proposal works without having to add new
> system calls: a) use a COW format, b) have background threads doing
> fsync()s, c) in each transaction's root block note the last
> known-committed (from a completed fsync()) transaction's root block,
> d) have an array of well-known ubberblocks large enough to accommodate
> as many transactions as possible without having to wait for any one
> fsync() to complete, d) do not reclaim space from any one past
> transaction until at least one subsequent transaction is fully
> committed.  This obtains ACI- transaction semantics (survives power
> failures but without durability for the last N transactions at
> power-failure time) without requiring changes to the OS at all, and
> with support for delayed D (durability) notification.

I believe what you really want is to be able to send to the storage a sequence of 
your favorite operations (FS operations, async IO operations, etc.) like:

Write back caching disabled:

data op11, ..., data op1N, ORDERED data op1, data op21, ..., data op2M, ...

Write back caching enabled:

data op11, ..., data op1N, ORDERED sync cache, ORDERED FUA data op1, data op21, 
..., data op2M, ...

Right?

(ORDERED means that it is guaranteed that this ordered command never in any 
circumstances will be executed before any previous command completed AND after any 
subsequent command completed.)

Vlad
