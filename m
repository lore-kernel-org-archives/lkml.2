Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab1IIOi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039Ab1IIOiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:38:54 -0400
Date: Fri, 9 Sep 2011 10:38:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        axboe@kernel.dk, takuya.yoshikawa@gmail.com,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: CFQ I/O starvation problem triggered by RHEL6.0 KVM guests
Message-ID: <20110909143847.GA15748@redhat.com>
References: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
 <20110908134945.GA7024@redhat.com>
 <20110909180028.d1aba6c0.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909180028.d1aba6c0.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 06:00:28PM +0900, Takuya Yoshikawa wrote:

[..]
> 
> > 
> > - Even if there are close cooperators, these queues are merged and they
> >   are treated as single queue from slice point of view. So cooperating
> >   queues should be merged and get a single slice instead of starving
> >   other queues in the system.
> 
> I understand that close cooperators' queues should be merged, but in our test
> case, when the 64KB request was issued from one aio thread, the other thread's
> queue was empty; because these queues are for the same stream, next request
> could not come until current request got finished.
> 
>   But this is complicated because it depends on the qemu block layer aio.
> 
> I am not sure if cfq would try to merge the queues in such cases.

[CCing Jeff Moyer ]

I think even if these queues are alternating, it should have been merged
(If we considered them close cooperator).

So in select queue we have.

        new_cfqq = cfq_close_cooperator(cfqd, cfqq);
        if (new_cfqq) {
                if (!cfqq->new_cfqq)
                        cfq_setup_merge(cfqq, new_cfqq);
                goto expire;
        }

So if we selected a new queue because it is a close cooperator, we should
have called setup_merge() and next time when the IO happens, one of the
queue should merge into another queue.

cfq_set_request() {
                if (cfqq->new_cfqq)
                        cfqq = cfq_merge_cfqqs(cfqd, cic, cfqq);
}

If merging is not happening and still we somehow continue to pick 
close_cooperator() as the new queue and starve other queues in the system,
then there is a bug.

I think try to reproduce this with fio with upstream kenrels and put
some more tracepoints and see what's happening.

Thanks
Vivek
