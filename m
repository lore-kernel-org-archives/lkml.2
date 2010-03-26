Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0CZARk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:17:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0CZARj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:17:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qEq1Nggd7Tfsu88Kal/k45KlDIX/ffMDf2OFS4sLDptX6Ua0u6XOfVGeyuo7dXYYe
	tbkbIX6AgBWR8jBLtTznA==
MIME-Version: 1.0
In-Reply-To: <20100325232511.GF3041@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
	 <20100325180423.25299.60415.stgit@meat.mtv.corp.google.com>
	 <20100325232511.GF3041@redhat.com>
Date: Thu, 25 Mar 2010 17:17:34 -0700
Message-ID: <1786ab031003251717o71f51d4l41a63e7b564fe8e7@mail.gmail.com>
Subject: Re: [PATCH 1/4] blkio_group key change: void * -> request_queue *
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 4:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> human-readable disk names probably are more convenient. I got few general
> concerns.

Thanks for the quick and detailed review.

> - Can we change the sysfs interface now. In 2.6.33 kernel we released the
>  code to export blkio.time and blkio.sectors using device numbers. We
>  shall have to change those interfaces also to reflect device stats in
>  terms of device names.

I wasn't aware of those interface, but I'm all for consistency.  I'll
look into it.

> - I had kept void* as the key in blkg object so that it does not make any
>  assumption about the key. This allowed that any xyz code in kernel can
>  register with blkio code and implement some kind of IO control policy
>  and it does not have to instanciate a request queue.
>
>  But I am not sure if there will be any subsystems which will really do
>  that. I am assuming that all the device mapper and md code do
>  instanciate the request queue? (In case we implement max bw policy
>  there).

I understand your preference to keep the key generic, but I wonder if
there is *any* device that won't have a request_queue?  The penalty of
keeping it very generic might be the complexity of another auxiliary
structure to lookup gendisks or the next thing.  I wish the device
mapper folks would speak up and be involved in these discussions.

> - How do you make sure that request queue does not go away and while
>  somebody is accessing blkg->queue under rcu read lock? This can happen
>  while we call unlink code.

Here I'll admit to being very new to RCU, and I'll defer to your
worries.  More homework needed on my part.

>  blkio_unlink_group_fn().
>
>  Because we store the pointer to cfqd as key, we make sure cfqd does not
>  get deleted before one rcu grace period. (call_rcu). But this gurantees
>  only that cfqd object is around and not cfqd->queue. So this is a
>  problem with even today's code.
>
> ...
> - How do you make sure that gendisk does not go away while q->disk is
>  being accessed under rcu lock. (Already asked in other thread too.)

On locking between gendisk deletion and stats printing: I suppose that
you've already considered and discarded using the queue_lock to
protect a  gendisk pointer in request_queue?

> These are some quick thoughs. More later...

Thanks again!
Chad
