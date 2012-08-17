Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab2HQOiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:38:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62935 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2HQOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <0000013934e4a8cf-51ac82e4-ad78-46b0-abf7-8dc81be01952-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com>
	<000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com>
	<CAAmzW4M9WMnxVKpR00SqufHadY-=i0Jgf8Ktydrw5YXK8VwJ7A@mail.gmail.com>
	<000001392b579d4f-bb5ccaf5-1a2c-472c-9b76-05ec86297706-000000@email.amazonses.com>
	<CAAmzW4MMY5TmjMjG50idZNgRUW3qC0kNMnfbGjGXaoxtba8gGQ@mail.gmail.com>
	<00000139306844c8-bb717c88-ca56-48b3-9b8f-9186053359d3-000000@email.amazonses.com>
	<CAAmzW4P=w6-yrmDmK1SPo3pwgH68Q0+RCe0tpqZPXnk-QEBLMQ@mail.gmail.com>
	<0000013934e4a8cf-51ac82e4-ad78-46b0-abf7-8dc81be01952-000000@email.amazonses.com>
Date: Fri, 17 Aug 2012 23:37:40 +0900
Message-ID: <CAAmzW4PXf=GK-a8-r_Ep4vR=kx54pr9h5K00iEDx3rVii5ROiA@mail.gmail.com>
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
> On Fri, 17 Aug 2012, JoonSoo Kim wrote:
>
>> > What difference does this patch make? At the end of the day you need the
>> > total number of objects available in the partial slabs and the cpu slab
>> > for comparison.
>>
>> It doesn't induce any large difference, but this makes code robust and
>> consistent.
>> Consistent code make us easily knowing what code does.
>
> Consistency depends on the way you think about the code.
>
>> It is somewhat odd that in first loop, we consider number of objects
>> kept in cpu slab,
>> but second loop exclude that number and just consider number of
>> objects in cpu partial slab.
>
> In the loop we consider the number of objects available to the cpu
> without locking.
>
> First we populate the per_cpu slab and if that does not give us enough per
> cpu objects then we use the per cpu partial list to increase that number
> to the desired count given by s->cpu_partial.
>
> "available" is the number of objects available for a particular cpu
> without having to go to the partial slab lists (which means having to acquire a
> per node lock).
>

Yes! You are right!
But, currently, "available" is not used as above meaning exactly.
It is used twice and each one has different meaning.

                if (!object) {
                        c->page = page;
                        stat(s, ALLOC_FROM_PARTIAL);
                        object = t;
                        available =  page->objects - page->inuse;
                } else {
                        available = put_cpu_partial(s, page, 0);
                        stat(s, CPU_PARTIAL_NODE);
                }

See above code.
In case of !object (available =  page->objects - page->inuse;),
"available" means the number of objects in cpu slab.
In this time, we don't have any cpu partial slab, so "available" imply
the number of objects available to the cpu without locking.
This is what we want.


But, see another "available" (available = put_cpu_partial(s, page, 0);).

This "available" doesn't include the number of objects in cpu slab.
It only include the number of objects in cpu partial slab.
So, it doesn't imply the number of objects available to the cpu without locking.
This isn't what we want.

Therefore, I think a minor fix is needed for consistency.
Isn't it reasonable?

Thanks!
