Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab2CMWoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:44:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53752 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760312Ab2CMWoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:44:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120313154945.GA7349@google.com>
References: <20120312142226.GD17288@redhat.com>
	<1331659266-21940-1-git-send-email-xtfeng@gmail.com>
	<20120313142820.GF29169@redhat.com>
	<20120313154945.GA7349@google.com>
Date: Wed, 14 Mar 2012 06:44:22 +0800
Message-ID: <CAJn8CcHk3Q1ke7839s+pKzkEeo6dGdNsZBHhEUek7c7=dp3y3w@mail.gmail.com>
Subject: Re: [PATCH v2] block: fix ioc leak in put_io_context
From: Xiaotian Feng <xtfeng@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:49 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 13, 2012 at 10:28:20AM -0400, Vivek Goyal wrote:
>> On Tue, Mar 13, 2012 at 01:21:06PM -0400, Xiaotian Feng wrote:
>> > diff --git a/block/blk-ioc.c b/block/blk-ioc.c
>> > index 8b782a6..9690f27 100644
>> > --- a/block/blk-ioc.c
>> > +++ b/block/blk-ioc.c
>> > @@ -145,6 +145,7 @@ static void ioc_release_fn(struct work_struct *work)
>> >  void put_io_context(struct io_context *ioc)
>> >  {
>> >     unsigned long flags;
>> > +   bool free_ioc = false;
>> >
>> >     if (ioc == NULL)
>> >             return;
>> > @@ -159,8 +160,13 @@ void put_io_context(struct io_context *ioc)
>> >             spin_lock_irqsave(&ioc->lock, flags);
>> >             if (!hlist_empty(&ioc->icq_list))
>> >                     schedule_work(&ioc->release_work);
>> > +           else
>> > +                   free_ioc = true;
>
> Calling kmem_cache_free() here directly is probably better.

I did this on my first try, but I got a kernel warning with the
following spin_unlock on ioc->lock :(
We'll hit a use after free bug then...

>
>> >             spin_unlock_irqrestore(&ioc->lock, flags);
>> >     }
>> > +
>> > +   if (free_ioc)
>> > +           kmem_cache_free(iocontext_cachep, ioc);
>> >  }
>> >  EXPORT_SYMBOL(put_io_context);
>>
>> This one looks good to me. Tejun?
>>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.
>
> --
> tejun
