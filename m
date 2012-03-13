Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349Ab2CMWrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:47:55 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58988 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab2CMWry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:47:54 -0400
Date: Tue, 13 Mar 2012 15:47:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>
Subject: Re: [PATCH v2] block: fix ioc leak in put_io_context
Message-ID: <20120313224749.GH7349@google.com>
References: <20120312142226.GD17288@redhat.com>
 <1331659266-21940-1-git-send-email-xtfeng@gmail.com>
 <20120313142820.GF29169@redhat.com>
 <20120313154945.GA7349@google.com>
 <CAJn8CcHk3Q1ke7839s+pKzkEeo6dGdNsZBHhEUek7c7=dp3y3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJn8CcHk3Q1ke7839s+pKzkEeo6dGdNsZBHhEUek7c7=dp3y3w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 06:44:22AM +0800, Xiaotian Feng wrote:
> On Tue, Mar 13, 2012 at 11:49 PM, Tejun Heo <tj@kernel.org> wrote:
> > On Tue, Mar 13, 2012 at 10:28:20AM -0400, Vivek Goyal wrote:
> >> On Tue, Mar 13, 2012 at 01:21:06PM -0400, Xiaotian Feng wrote:
> >> > diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> >> > index 8b782a6..9690f27 100644
> >> > --- a/block/blk-ioc.c
> >> > +++ b/block/blk-ioc.c
> >> > @@ -145,6 +145,7 @@ static void ioc_release_fn(struct work_struct *work)
> >> >  void put_io_context(struct io_context *ioc)
> >> >  {
> >> >     unsigned long flags;
> >> > +   bool free_ioc = false;
> >> >
> >> >     if (ioc == NULL)
> >> >             return;
> >> > @@ -159,8 +160,13 @@ void put_io_context(struct io_context *ioc)
> >> >             spin_lock_irqsave(&ioc->lock, flags);
> >> >             if (!hlist_empty(&ioc->icq_list))
> >> >                     schedule_work(&ioc->release_work);
> >> > +           else
> >> > +                   free_ioc = true;
> >
> > Calling kmem_cache_free() here directly is probably better.
> 
> I did this on my first try, but I got a kernel warning with the
> following spin_unlock on ioc->lock :(
> We'll hit a use after free bug then...

Ah, you're right.  Thanks.

-- 
tejun
