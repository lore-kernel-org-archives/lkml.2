Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab1CYLNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:13:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55184 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934554Ab1CYLNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rOnvo+USX9l+PFj3U6QCcIupdYVz+Md95WOyS2xyT83NF7WPPFhgrLuDGW+HhDjzwD
         bPTM1jYn4RPgjO38DPE5iHyWRUQEOXlc4OEchtQP8wtaDl5XFUmfzq/IgCPKFNyFJLDk
         CEVjxB01tZhwS3+zoCk4Qa8hgloxOo622gOaQ=
MIME-Version: 1.0
In-Reply-To: <20110325033956.GB9313@home.goodmis.org>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org> <20110325033956.GB9313@home.goodmis.org>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 25 Mar 2011 14:13:14 +0300
Message-ID: <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 6:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
>> Adaptive owner spinning used to be applied only to mutex_lock().  This
>> patch applies it also to mutex_trylock().
>>
>> btrfs has developed custom locking to avoid excessive context switches
>> in its btree implementation.  Generally, doing away with the custom
>> implementation and just using the mutex shows better behavior;
>> however, there's an interesting distinction in the custom implemention
>> of trylock.  It distinguishes between simple trylock and tryspin,
>> where the former just tries once and then fail while the latter does
>> some spinning before giving up.
>>
>> Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
>> just once.  I got curious whether using adaptive spinning on
>> mutex_trylock() would be beneficial and it seems so, for btrfs anyway.
>>
>> The following results are from "dbench 50" run on an opteron two
>> socket eight core machine with 4GiB of memory and an OCZ vertex SSD.
>> During the run, disk stays mostly idle and all CPUs are fully occupied
>> and the difference in locking performance becomes quite visible.
>>
>> SIMPLE is with the locking simplification patch[1] applied.  i.e. it
>> basically just uses mutex.  SPIN is with this patch applied on top -
>> mutex_trylock() uses adaptive spinning.
>>
>>         USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
>>  SIMPLE 61107  354977    217  8099529  845.100 MB/sec
>>  SPIN   63140  364888    214  6840527  879.077 MB/sec
>>
>> On various runs, the adaptive spinning trylock consistently posts
>> higher throughput.  The amount of difference varies but it outperforms
>> consistently.
>>
>> In general, using adaptive spinning on trylock makes sense as trylock
>> failure usually leads to costly unlock-relock sequence.
>>
>> [1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> I'm curious about the effects that this has on those places that do:
>
> again:
>        mutex_lock(A);
>        if (mutex_trylock(B)) {
>                mutex_unlock(A);
>                goto again;
>
>
> Where the normal locking order is:
>  B -> A
>
> If another location does:
>
>        mutex_lock(B);
>        [...]
>        mutex_lock(A);
>
> But another process has A already, and is running, it may spin waiting
> for A as A's owner is still running.
>
> But now, mutex_trylock(B) becomes a spinner too, and since the B's owner
> is running (spinning on A) it will spin as well waiting for A's owner to
> release it. Unfortunately, A's owner is also spinning waiting for B to
> release it.
>
> If both A and B's owners are real time tasks, then boom! deadlock.

Turning try_lock into indefinitely spinning one breaks its semantics,
so deadlock is to be expected. But what's wrong in this scenario if
try_lock spins a bit before giving up?

Regards,
Andrey

>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
