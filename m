Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1LLDsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:48:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36926 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1LLDsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:48:52 -0500
MIME-Version: 1.0
In-Reply-To: <1323636148.16764.44.camel@twins>
References: <20111210104341.592561407@chello.nl>
	<20111210104840.295857663@chello.nl>
	<CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	<1323529084.16764.5.camel@twins>
	<CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
	<1323546551.2822.14.camel@laptop>
	<CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
	<1323607627.16764.13.camel@twins>
	<CACVXFVOYj+Mmph8WGQUdcGS8t-GPr9y3crPuz0SrBCtOmCvstQ@mail.gmail.com>
	<1323617738.16764.21.camel@twins>
	<1323636148.16764.44.camel@twins>
Date: Mon, 12 Dec 2011 11:48:51 +0800
Message-ID: <CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 4:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2011-12-11 at 16:35 +0100, Peter Zijlstra wrote:
>> On Sun, 2011-12-11 at 20:59 +0800, Ming Lei wrote:
>> >
>> > The implicit rule about kref is that use should make sure
>> > that kref can not be touched once it is released.
>>
>> The only transition for with order makes any difference what so ever is
>> 1 -> 0, you just said that should be done by external means (I agree and
>> have argued thusly), therefore any memory barriers outside of these
>> external means are superfluous.
>>
>> Thus the proposed patch is correct.
>
> Also, this was an entirely different issue than was raised in the
> original changelog. Memory barriers in general are about ordering
> visibility between multiple operations done on one cpu vs them being
> visible on another.

For kref, maybe it is still multiple operations done on one cpu vs them
being visible on another, but seems a bit implicit, see the common kref
usage below:

CPU0				CPU1
					A:kref_init(&obj->ref)

B:kref_get(&obj->ref)
C:access obj			E:access obj
					F:kref_put(&ojb->ref)
D:kref_put(obj->ref)

There is one smp_mb between E and F on CPU1, and we still need
another one between B and C  on CPU 0 to keep the order. Otherwise,
CPU1 may observe out of order about B and C, then make obj released
(F)too early,  and cause OOPS on CPU 0.

>
> The important point being that there need to be multiple operations on
> one cpu in order for them to be able to make a difference. And the whole
> issue in the past few emails only had a single operation on each cpu.
> Therefore memory barriers are completely irrelevant.
>
> Ever so more because atomic_t is atomic on the variable regardless of
> visibility by a second party.

Maybe not, see above.

>
> Anyway, one more way to illustrate my point; there's three distinct
> phases in the life cycle of a kref managed object: insert, lookup and
> removal. They are as follows:
>
> INSERT:
>        obj = alloc_obj();
>        init_obj(obj);
>          kref_set(&obj->ref, 1);
>
>        LOCK
>        insert(obj);
>        UNLOCK
>
> LOOKUP:
>        LOCK
>        obj = lookup(key);
>        if (obj)
>          kref_get();
>        UNLOCK
>
>        ...
>
>        kref_put(); /* assuming obj != NULL */
>
> REMOVAL: /* assumes obj was acquired using a preceding LOOKUP */
>        LOCK
>        remove(obj);
>        UNLOCK
>
>        kref_sub(&obj->ref, 2); /* lookup + insert */

Looks like should be kref_sub(1) since LOOKUP may handle by itself.

>
> Before the insert() our obj isn't visible to other CPUs doing lookup(),
> therefore there can be no concurrency on the kref, after insert the
> insert's UNLOCK + lookup's LOCK provide the full memory barrier

We can't assume any lock about kref usage, because kref is often used
in lockless scenario.

> separating the last write to the object and the first read of it.
>
> Multiple lookup()s can be concurrent with each other and the last
> remove(). Concurrent lookups are completely non-interesting since they
> can't ever trigger the ->0 transition.
>
> A lookup interleaved with a removal is serialized on the lock around our
> data-structure, after the removal no new lookups will succeed, and thus
> no new kref_get()s will be issued and all that happens is decrements
> until we hit 0.
>
> The issue from the original changelog was that within a lookup, reads
> and writes to the obj might be re-ordered with the acquisition of the
> refcount. IOW. something like:
>
>  LOCK
>  obj = lookup(); /* lets assume obj != NULL */
>  kref_get(&obj->ref);
>  UNLOCK
>
>  value = obj->member;
>
>  kref_put(&obj->ref);
>
> Now, under our memory model, the read from obj->member can both happen,
> or be observed to happen before the increment from kref_get() is
> processed.

It should be the problem if another CPU observed that write/read obj
is done before kref_get.

> I completely fail to see how that is an issue, nor when it is, why kref
> should care. If you rely on that, you're doing something weird and
> exotic and had better place the appropriate memory barriers yourself.
>
>


thanks,
-- 
Ming Lei
