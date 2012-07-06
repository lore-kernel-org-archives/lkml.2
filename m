Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2GFO7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:59:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2GFO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207060928580.26790@router.home>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340389359-2407-3-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207050924330.4138@router.home>
	<CAAmzW4NJyX9e_dMyJBA5zDiVYVmL1vbUkaRHNoSbbhDZWW7iMg@mail.gmail.com>
	<alpine.DEB.2.00.1207060928580.26790@router.home>
Date: Fri, 6 Jul 2012 23:59:31 +0900
Message-ID: <CAAmzW4P941qeKy6UH079r73zR5VjUeNZNB53Mi4wiHE28f==gg@mail.gmail.com>
Subject: Re: [PATCH 3/3] slub: release a lock if freeing object with a lock is
 failed in __slab_free()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/6 Christoph Lameter <cl@linux.com>:
> On Fri, 6 Jul 2012, JoonSoo Kim wrote:
>
>> For example,
>> When we try to free object A at cpu 1, another process try to free
>> object B at cpu 2 at the same time.
>> object A, B is in same slab, and this slab is in full list.
>>
>> CPU 1                           CPU 2
>> prior = page->freelist;    prior = page->freelist
>> ....                                  ...
>> new.inuse--;                   new.inuse--;
>> taking lock                      try to take the lock, but failed, so
>> spinning...
>> free success                   spinning...
>> add_partial
>> release lock                    taking lock
>>                                        fail cmpxchg_double_slab
>>                                        retry
>>                                        currently, we don't need lock
>>
>> At CPU2, we don't need lock anymore, because this slab already in partial list.
>
> For that scenario we could also simply do a trylock there and redo
> the loop if we fail. But still what guarantees that another process will
> not modify the page struct between fetching the data and a successful
> trylock?


I'm not familiar with English, so take my ability to understand into
consideration.

we don't need guarantees that another process will not modify
the page struct between fetching the data and a successful trylock.

As I understand, do u ask below scenario?

CPU A               CPU B
lock
cmpxchg fail
retry
unlock
...                       modify page strcut
...
cmpxchg~~

In this case, cmpxchg will fail and just redo the loop.
If we need the lock again during redo, re-take the lock.
But I think this is not common case.
