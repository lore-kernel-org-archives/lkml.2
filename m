Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1AHQSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:18:44 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:50286 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1AHQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sqw8PGz1F6XWmxLqde8q67B8E3PJWUxf97bND5zneDqfG2V7hWfEWpEeScd4EkIRsh
         BaKsTNZDin/mO3DzziUSSbZcLWzxN/bPUbtJ3VVWhu56+DGp+hSjbesgOLxohDu2l+zd
         OS98X/zqqD7UWpjI9OkbXih86g8BtRg46Msn0=
Date: Sat, 8 Jan 2011 11:18:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Screwing with the concurrency limit
Message-ID: <20110108161840.GC13269@mtj.dyndns.org>
References: <4D287AED.9090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D287AED.9090304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 08, 2011 at 06:55:41AM -0800, Kent Overstreet wrote:
> First off, wild applause for cmwq. The limitations of the old
> workqueues were a major irritation, I think your new implementation
> is fabulous.

Heh, that's flattering.  Thanks.

> However, when merging bcache with mainline, I ran into a bit of a
> thorny issue. Bcache relies heavily on workqueues, updates to the
> cache's btree have to be done after every relevant IO completes.
> Additionally, btree insertions can involve sleeping on IO while the
> root of the tree isn't write locked - so we'd like to not block
> other work items from completing if we don't have to.
> 
> So, one might expect the way to get the best performance would be
>   alloc_workqueue("bcache", WQ_HIGHPRI|WQ_MEM_RECLAIM, 0)

A bit tangential but is WQ_HIGHPRI really necessary?  Is the use case
very latency sensitive?

> Trouble is, sometimes we do write lock the root of the btree,
> blocking everything else from getting anything done - the end result
> is
>   root@moria:~# ps ax|grep kworker|wc -l
>   1550

Yeah, that will happen.

> (running dbench in a VM with disks in tmpfs). Performance is fine (I
> think, haven't been trying to rigorously benchmark) but that's
> annoying.
> 
> I think the best way I can express it is that bcache normally wants
> a concurrency limit of 1, except when we're blocking and we aren't
> write locking the root of the btree.
> 
> So, do you think there might be some sane way of doing this with
> cmwq? Some way to say "Don't count this work item I'm in right now
> count against the workqueue's concurrency limit anymore". If such a
> thing could be done, I think it'd be the perfect solution (and I'll
> owe you a case of your choice of beer :)

Hmmm... workqueue allows adjusting @max_active on the fly with
workqueue_set_max_active().  I think what you can do is to wrap write
locks with max_active cramping.  ie. set_max_active(1); write_lock();
do the stuff; write_unlock(); set_max_active(orig_max_active);

workqueue_set_max_active() would need a bit update to make it behave
under such dynamic usage (so that it returns the original max_active
after applying the new one and kicks the delayed work items when
max_active gets increased) but if that sounds like a plan which could
work, I'll be happy to update it.

Good luck.

-- 
tejun
