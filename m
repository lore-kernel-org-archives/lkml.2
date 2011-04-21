Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab1DUMoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:44:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1DUMoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u0bxhDZd2/6LWvT22noQFPWNGpxP5+nLundtsLBjNk8YB7IbUPkeRx7IhF4Yfttd0s
         keCa3o+UWhXeatp/CXaDAyEFBeH0fZhtz0STqfbnOD6g5YtaVxLtIkfGfE7n7PtvNb8J
         KoIx9RKhtMpKbx7hDhv0mEzs/WBj84yGyJxvI=
MIME-Version: 1.0
In-Reply-To: <20110420093823.38f1c2fe.akpm@linux-foundation.org>
References: <BANLkTins3c6r0z-WR8PWrVvYa5OdOZ1BGg@mail.gmail.com>
	<20110420093823.38f1c2fe.akpm@linux-foundation.org>
Date: Thu, 21 Apr 2011 20:44:53 +0800
Message-ID: <BANLkTik0N9wKjbU3akPA0ej-YGncEKkUvQ@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: simplify destroying inode
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 4 Apr 2011 11:36:56 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
>> Just before reclaimed by the hugetlbfs inode cache, little difference
>> could be made by initializing the list head of the dentry member of
>> vfs inode, thus the operation of initialization could be removed to
>> simplify the destroy of hugetlbfs inode.
>>
>> Signed-off-by: Hillf Danton <gmail.com>
>> ---
>>
>> --- a/fs/hugetlbfs/inode.c    2011-03-30 03:09:48.000000000 +0800
>> +++ b/fs/hugetlbfs/inode.c    2011-04-04 11:27:30.000000000 +0800
>> @@ -665,7 +665,6 @@ static struct inode *hugetlbfs_alloc_ino
>>  static void hugetlbfs_i_callback(struct rcu_head *head)
>>  {
>>       struct inode *inode = container_of(head, struct inode, i_rcu);
>> -     INIT_LIST_HEAD(&inode->i_dentry);
>>       kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
>>  }
>
> How well was this tested?
>
> hugetlbfs_inode_cachep has a slab constructor,
> init_once()->inode_init_once().  The slab protocol requires that
> objects be returned to the cache in the same state as that which the
> constructor creates.  (It's a bit weird and it would probably be faster
> and certainly saner if the ctor were run by kmem_cache_alloc()).
>
> inode_init_once() does INIT_LIST_HEAD(&inode->i_dentry), so objects

Hi Andrew,

Thank you for good explanation about the ctor of inode, first.

Just because the ctor is responsible for initializing newly requested inode,
the same work could be skipped when the inode is then reclaimed.

The overwork could also be observed in other cases of file system,
then I have to check with more care it is really necessary.

thanks

          Hillf

> should be returned to the cache in that state.  If no other code was
> already reliably reinitialising ->i_dentry, the patch will add a bug.
