Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2HQNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:34:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40126 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2HQNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <00000139306844c8-bb717c88-ca56-48b3-9b8f-9186053359d3-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com>
	<000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com>
	<CAAmzW4M9WMnxVKpR00SqufHadY-=i0Jgf8Ktydrw5YXK8VwJ7A@mail.gmail.com>
	<000001392b579d4f-bb5ccaf5-1a2c-472c-9b76-05ec86297706-000000@email.amazonses.com>
	<CAAmzW4MMY5TmjMjG50idZNgRUW3qC0kNMnfbGjGXaoxtba8gGQ@mail.gmail.com>
	<00000139306844c8-bb717c88-ca56-48b3-9b8f-9186053359d3-000000@email.amazonses.com>
Date: Fri, 17 Aug 2012 22:34:18 +0900
Message-ID: <CAAmzW4P=w6-yrmDmK1SPo3pwgH68Q0+RCe0tpqZPXnk-QEBLMQ@mail.gmail.com>
Subject: Re: [PATCH] slub: try to get cpu partial slab even if we get enough
 objects for cpu freelist
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/17 Christoph Lameter <cl@linux.com>:
> On Thu, 16 Aug 2012, JoonSoo Kim wrote:
>
>> But, if you prefer that s->cpu_partial is for both cpu slab and cpu
>> partial slab,
>> get_partial_node() needs an another minor fix.
>> We should add number of objects in cpu slab when we refill cpu partial slab.
>> Following is my suggestion.
>>
>> @@ -1546,7 +1546,7 @@ static void *get_partial_node(struct kmem_cache *s,
>>         spin_lock(&n->list_lock);
>>         list_for_each_entry_safe(page, page2, &n->partial, lru) {
>>                 void *t = acquire_slab(s, n, page, object == NULL);
>> -               int available;
>> +               int available, nr = 0;
>>
>>                 if (!t)
>>                         break;
>> @@ -1557,10 +1557,10 @@ static void *get_partial_node(struct kmem_cache *s,
>>                         object = t;
>>                         available =  page->objects - page->inuse;
>>                 } else {
>> -                       available = put_cpu_partial(s, page, 0);
>> +                       nr = put_cpu_partial(s, page, 0);
>>                         stat(s, CPU_PARTIAL_NODE);
>>                 }
>> -               if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
>> +               if (kmem_cache_debug(s) || (available + nr) >
>> s->cpu_partial / 2)
>>                         break;
>>
>>         }
>>
>> If you agree with this suggestion, I send a patch for this.
>
> What difference does this patch make? At the end of the day you need the
> total number of objects available in the partial slabs and the cpu slab
> for comparison.

It doesn't induce any large difference, but this makes code robust and
consistent.
Consistent code make us easily knowing what code does.

It is somewhat odd that in first loop, we consider number of objects
kept in cpu slab,
but second loop exclude that number and just consider number of
objects in cpu partial slab.

Thanks!
