Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2L0W1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:27:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63874 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0W1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
	<1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
	<alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
Date: Fri, 28 Dec 2012 00:27:11 +0200
X-Google-Sender-Auth: qgpBLGM4M2WaxJLyTIRHpSx9eN4
Message-ID: <CAOJsxLH4RzWdxdVXyn+eFc56JfJtije2jK1eWaBYVaoZSHuUBA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even if
 slab is available
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012, Sasha Levin wrote:
>> diff --git a/mm/bootmem.c b/mm/bootmem.c
>> index 1324cd7..198a92f 100644
>> --- a/mm/bootmem.c
>> +++ b/mm/bootmem.c
>> @@ -763,9 +763,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>  void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>                                  unsigned long align, unsigned long goal)
>>  {
>> -     if (WARN_ON_ONCE(slab_is_available()))
>> -             return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>> -
>>       return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
>>  }

On Fri, Dec 28, 2012 at 12:25 AM, David Rientjes <rientjes@google.com> wrote:
> All you're doing is removing the fallback if this happens to be called
> with slab_is_available().  It's still possible that the slab allocator can
> successfully allocate the memory, though.  So it would be rather
> unfortunate to start panicking in a situation that used to only emit a
> warning.
>
> Why can't you panic only kzalloc_node() returns NULL and otherwise just
> return the allocated memory?

I'm not sure what Sasha's patch is trying to do here but the fall-back
is there simply to let the caller know it's calling the bootmem
allocator *too late*. That is, the slab allocator is already up and
running so you're expected to use that.

                        Pekka
