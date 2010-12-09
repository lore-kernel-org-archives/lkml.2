Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0LIMeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:34:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0LIMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:34:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZYj5hUnJn1eGvnwqddwINRuKeehDg25DJjBn61QzASgsYTeWnT236MoHEAxpsQk4FO
         KeNU2/O7uBC+oZGDZSLsbvgBmVf3loiDU9C99H0tE4QCRxjBvkvRqxCH1kmEQYEdpgZE
         rqT3FE5XTmjrQQF+c5cL+uNbq8pNpjzNQSsTE=
MIME-Version: 1.0
In-Reply-To: <20101209072234.GC8259@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<73262b3142d9650bcebd67ad301b36553ce8924f.1290852959.git.npiggin@kernel.dk>
	<20101209072234.GC8259@dastard>
Date: Thu, 9 Dec 2010 23:34:14 +1100
Message-ID: <AANLkTimuWJ_2H+fxGgK4qCTnfTtgzD3tW7Af+TeDh2+3@mail.gmail.com>
Subject: Re: [PATCH 12/46] fs: dcache scale lru
From: Nick Piggin <npiggin@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, forgot cc, sorry.

On Thu, Dec 9, 2010 at 6:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Nov 27, 2010 at 08:44:42PM +1100, Nick Piggin wrote:
>> Add a new lock, dcache_lru_lock, to protect the dcache LRU list from concurrent
>> modification. d_lru is also protected by d_lock.
>>
>> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
>> ---
>>  fs/dcache.c |  112 ++++++++++++++++++++++++++++++++++++++++++++---------------
>>  1 files changed, 84 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 50c65c7..aa410b6 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -37,11 +37,19 @@
>>
>>  /*
>>   * Usage:
>> - * dcache_hash_lock protects dcache hash table
>> + * dcache_hash_lock protects:
>> + *   - the dcache hash table
>> + * dcache_lru_lock protects:
>> + *   - the dcache lru lists and counters
>> + * d_lock protects:
>> + *   - d_flags
>
> Which bit of d_flags does it protect?

All of them.

> Why in this patch and not in
> the hash scaling patch with needs DCACHE_UNHASHED to be in sync with
> the whether it is in the hash list?

It's unrelated to this patch (same as d_name, below).

>> + *   - d_name
>> + *   - d_lru
>
> Why is the d_lock required to protect d_lru? I can't see any reason
> in this patch that requires d_lock to protect anything that
> dcache_lru_lock does not protect....

It's used in future patches.


>>  /**
>> @@ -186,6 +206,8 @@ static void dentry_lru_move_tail(struct dentry *dentry)
>>   * The dentry must already be unhashed and removed from the LRU.
>>   *
>>   * If this is the root of the dentry tree, return NULL.
>> + *
>> + * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
>>   */
>>  static struct dentry *d_kill(struct dentry *dentry)
>>       __releases(dentry->d_lock)
>> @@ -341,10 +363,19 @@ int d_invalidate(struct dentry * dentry)
>>  EXPORT_SYMBOL(d_invalidate);
>>
>>  /* This should be called _only_ with dcache_lock held */
>> +static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
>> +{
>> +     atomic_inc(&dentry->d_count);
>> +     dentry_lru_del(dentry);
>> +     return dentry;
>> +}
>> +
>>  static inline struct dentry * __dget_locked(struct dentry *dentry)
>>  {
>>       atomic_inc(&dentry->d_count);
>> +     spin_lock(&dentry->d_lock);
>>       dentry_lru_del(dentry);
>> +     spin_unlock(&dentry->d_lock);
>>       return dentry;
>>  }
>
> Why do we need to call dentry_lru_del() in __dget_* functions? The
> shrinkers already handle lazy deletion just fine, and this just
> seems like a method for bouncing the dcache_lru_lock around.

This is how the code works before the locking series. The intention
is that places which already hold dcache_lock for other reasons can
take the dentry off the list cheaply.

I am avoiding where possible in making functional changes along with
locking changes (like I have said many times). After dcache_lock goes
away, there are patches to make it more lazy.

>
> The new lazy inode lru code which was modelled on the dcache code
> does not remove inodes from the LRU when taking new references to an
> inode and it seems to function just fine,

I know, didn't I implement it? :)

> so I'm thinking that we
> should be making the dcache LRU even more lazy by removing these
> calls to dentry_lru_del() here.

Not in this patch, but later yes.

>
> I think this is important as as lockstat is telling me
> the dcache_lru_lock is the most heavily contended lock in the system
> in my testing....
>
>> @@ -474,21 +505,31 @@ static void shrink_dentry_list(struct list_head *list)
>>
>>       while (!list_empty(list)) {
>>               dentry = list_entry(list->prev, struct dentry, d_lru);
>> -             dentry_lru_del(dentry);
>> +
>> +             if (!spin_trylock(&dentry->d_lock)) {
>> +                     spin_unlock(&dcache_lru_lock);
>> +                     cpu_relax();
>> +                     spin_lock(&dcache_lru_lock);
>> +                     continue;
>> +             }
>
> Wouldn't it be better to move the entry to the tail of the list
> here so we don't get stuck spinning on the same dentry for a length
> of time?

Again, I'm avoiding functional changes in this part of the series. It
makes things slightly more clunky in intermediate stages, but makes
verification and bisecting much easier.

This particular one gets done completely without lru lock in future patch.


>> @@ -509,32 +550,36 @@ static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
>>       int cnt = *count;
>>
>>       spin_lock(&dcache_lock);
>> +relock:
>> +     spin_lock(&dcache_lru_lock);
>>       while (!list_empty(&sb->s_dentry_lru)) {
>>               dentry = list_entry(sb->s_dentry_lru.prev,
>>                               struct dentry, d_lru);
>>               BUG_ON(dentry->d_sb != sb);
>>
>> +             if (!spin_trylock(&dentry->d_lock)) {
>> +                     spin_unlock(&dcache_lru_lock);
>> +                     cpu_relax();
>> +                     goto relock;
>> +             }
>
> Same again - if the dentry is locked, then it is likely to be
> newly referenced so move it to the tail of the list and continue....

Not this patch.

Thanks,
Nick
