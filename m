Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2FVOMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762216Ab2FVOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:12:17 -0400
Date: Fri, 22 Jun 2012 10:12:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120622141211.GB18409@redhat.com>
References: <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
 <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
 <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
 <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 04:11:18PM -0500, Josh Hunt wrote:

[..]
> > say put some logs in select_queue() and see where did it bail out. That
> 
> Well I did add some instrumentation in select_queue, the "keep_queue
> st->count:%d, dispatch:%u" line I mentioned above, but I will add more
> and retest.

Actually before the stall we expired the current queue. That means there
is no active queue in cfq now. So keep_queue trace will help only if there
is an active queue and we decide to keep that queue. 

  8,0    0        0  4466.139959742     0  m   N cfq20720 del_from_rr
  8,0    0        0  4466.139963653     0  m   N cfq schedule dispatch
  8,0    1  1499521  4466.791207736  7570  A   R 7258191 + 8 <- (8,1)
7258128

Thing to figure out here is that why cfq is not picking a new queue
despite the fact there are pending requests and there is no active
queue (hence cfq is not obiviously not seeing that queue).

> 
> I'm attaching a similar run with no stalls when I set slice_idle to 0.

At this point I am not sure why slice_idle=0 is not seeing this issue. It
does not see to be directly related to idling. Because when stall happens
CFQ is not idling on anything. It has expired active queue and for some
reason it thinks that I have no more requests to dispatch, so I have
nothing to do until a new request comes in.

Thanks
Vivek
