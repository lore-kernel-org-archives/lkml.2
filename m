Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1ARWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:42:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1ARWmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FCUFtBd6UfI30tYJ+nl12FMZMpzZUhxwa+cAna9HcQwOVEC2meu2J4DoRVK/jFnWkm
         OCVLUEYtbJot8S6jm8lYulGOImV8LDww3tXMwmpozmyF3o7EmRwrDqXQbRLq+35+WMNq
         Ezs+sZdRYG7kzKpxwzFgeYRB+5CrrQ7RqiEr8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
	<AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
Date: Wed, 19 Jan 2011 09:42:34 +1100
Message-ID: <AANLkTik3ScP5rvR2bOXOEEH8SNZGg+xO6Gy32CW3XmU6@mail.gmail.com>
Subject: Re: [PATCH 17/46] fs: Use rename lock and RCU for multi-step operations
From: Nick Piggin <npiggin@gmail.com>
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 9:32 AM, Yehuda Sadeh Weinraub
<yehudasa@gmail.com> wrote:
> On Sat, Nov 27, 2010 at 1:44 AM, Nick Piggin <npiggin@kernel.dk> wrote:
>> The remaining usages for dcache_lock is to allow atomic, multi-step read-side
>> operations over the directory tree by excluding modifications to the tree.
>> Also, to walk in the leaf->root direction in the tree where we don't have
>> a natural d_lock ordering.
>>
>> This could be accomplished by taking every d_lock, but this would mean a
>> huge number of locks and actually gets very tricky.
>>
>> Solve this instead by using the rename seqlock for multi-step read-side
>> operations, retry in case of a rename so we don't walk up the wrong parent.
>> Concurrent dentry insertions are not serialised against.  Concurrent deletes
>> are tricky when walking up the directory: our parent might have been deleted
>> when dropping locks so also need to check and retry for that.
>>
>> We can also use the rename lock in cases where livelock is a worry (and it
>> is introduced in subsequent patch).
>>
>> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> ..
>> @@ -237,6 +238,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
>>        __releases(dcache_inode_lock)
>>        __releases(dcache_lock)
>>  {
>> +       dentry->d_parent = NULL;
>>        list_del(&dentry->d_u.d_child);
>>        if (parent)
>>                spin_unlock(&parent->d_lock);
>
> There's an issue with ceph as it references the
> dentry->d_parent(->d_inode) at dentry_release(), so setting
> dentry->d_parent to NULL here doesn't work with ceph. Though there is
> some workaround for it, we would like to be sure that this one is
> really required so that we don't exacerbate the ugliness. The
> workaround is to keep a pointer to the parent inode in the private
> dentry structure, which will be referenced only at the .release()
> callback. This is clearly not ideal.

Hmm, I'll have to think about it. Probably we can check for
d_count == 0 rather than parent != NULL I think?
