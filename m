Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2FYNa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2FYNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:30:57 -0400
Date: Mon, 25 Jun 2012 09:30:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120625133047.GA9394@redhat.com>
References: <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
 <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
 <20120622141211.GB18409@redhat.com>
 <CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
 <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
 <20120622204207.GA22063@redhat.com>
 <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
 <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
 <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:34:07PM -0500, Josh Hunt wrote:

[..]
> Shouldn't the queue stay on the RR list until it is empty?

This does look odd. cfqq should stay on service tree as long as it has
requests.

Can you attach the full log again. Also make sure that blktrace is not
dropping any trace events.

In slice_expire() we check following.

        if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
                cfq_del_cfqq_rr(cfqd, cfqq);

So for some reason RB_EMPTY_ROOT() is returning true. But we must have
added the request and it should not have been empty.

cfq_insert_request()
  cfq_add_rq_rb()
    elv_rb_add()

So may be little more tracing after request addition will help. Just check
that RB_EMPTY_ROOT() is not true after addition of request and also print
number of requests queued. 

In slice_expired() we can probably put a BUG_ON() which checks following.

BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list) && (cfqq->queued[0] || cfqq->queued[1]));

Thanks
Vivek
