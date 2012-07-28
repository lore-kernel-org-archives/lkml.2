Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2G1N4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 09:56:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33067 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2G1N4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 09:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207271538250.25434@router.home>
References: <1343420271-3825-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207271538250.25434@router.home>
Date: Sat, 28 Jul 2012 22:56:03 +0900
Message-ID: <CAAmzW4N5HxN+Ha_kwwKSf9na-g6bnro1UumQ+ZiQEmgS4kacrA@mail.gmail.com>
Subject: Re: [PATCH] slub: remove one code path and reduce lock contention in __slab_free()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/28 Christoph Lameter <cl@linux.com>:
> On Sat, 28 Jul 2012, Joonsoo Kim wrote:
>
>> Subject and commit log are changed from v1.
>
> That looks a bit better. But the changelog could use more cleanup and
> clearer expression.
>
>> @@ -2490,25 +2492,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>>                  return;
>>          }
>>
>> +     if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
>> +             goto slab_empty;
>> +
>
> So we can never encounter a empty slab that was frozen before? Really?

In my suggestion,  'was_frozen = 1' is "always" handled without taking a lock.
Then, never hit following code.
+     if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
+             goto slab_empty;
+

Instead, hit following code.
        if (likely(!n)) {

                /*
                 * If we just froze the page then put it onto the
                 * per cpu partial list.
                 */
                if (new.frozen && !was_frozen) {
                        put_cpu_partial(s, page, 1);
                        stat(s, CPU_PARTIAL_FREE);
                }
                /*
                 * The list lock was not taken therefore no list
                 * activity can be necessary.
                 */
                if (was_frozen)
                        stat(s, FREE_FROZEN);
                return;
        }

So, even if we encounter a empty slab that was frozen before, we just
do "stat(s, FREE_FROZEN)".
Please let me know my answer is sufficient.
Thanks!!
