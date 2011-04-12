Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab1DLQ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:27:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40761 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab1DLQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:27:07 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302624266.2661.21.camel@dolmen>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 11:27:01 -0500
Message-ID: <1302625621.2604.24.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 17:04 +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Tue, 2011-04-12 at 10:14 -0500, James Bottomley wrote:
> > On Tue, 2011-04-12 at 15:06 +0100, Steven Whitehouse wrote:
> > > Messages attached - getting closer I think, but still not quite there.
> > > It is very odd that so far (at least I've seen no other reports) that I
> > > seem to be the only one who hits this. I wonder what is different about
> > > my kernel/hardware...
> > 
> > 
> > > csi: killing requests for dead queue
> > > scsi: killing requests for dead queue
> > > BUG: unable to handle kernel scsi: killing requests for dead queue
> > > NULL pointer dereference at 0000000000000028
> > > IP: [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
> > 
> > Hmm, I don't see where this is ... it's a null pointer deref offset by
> > 0x28 bytes ... but I can't see where ... can you resolve this to a line?
> > 
> > James
> > 
> > 
> 
> So assuming I've calculated this correctly, it should be just about....
> 
> /home/steve/linux-2.6/include/linux/rcupdate.h:677
>     6de8:       a8 08                   test   $0x8,%al
>     6dea:       0f 84 65 ff ff ff       je     6d55 <blk_peek_request+0xf5>
>     6df0:       e8 00 00 00 00          callq  6df5 <blk_peek_request+0x195>
>                         6df1: R_X86_64_PC32     preempt_schedule-0x4
>     6df5:       e9 5b ff ff ff          jmpq   6d55 <blk_peek_request+0xf5>
>     6dfa:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
> __elv_next_request():
> /home/steve/linux-2.6/block/blk.h:65
>                 if (!list_empty(&q->queue_head)) {
>                         rq = list_entry_rq(q->queue_head.next);
>                         return rq;
>                 }
> 
>                 if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
>     6e00:       49 8b 44 24 18          mov    0x18(%r12),%rax
>     6e05:       31 f6                   xor    %esi,%esi
>     6e07:       48 8b 00                mov    (%rax),%rax
>     6e0a:       4c 89 e7                mov    %r12,%rdi                              <---- here!
>     6e0d:       ff 50 28                callq  *0x28(%rax)
>     6e10:       85 c0                   test   %eax,%eax
>     6e12:       0f 85 f4 fe ff ff       jne    6d0c <blk_peek_request+0xac>
>     6e18:       45 31 ed                xor    %r13d,%r13d
>     6e1b:       e9 70 ff ff ff          jmpq   6d90 <blk_peek_request+0x130>
> blk_peek_request():
> /home/steve/linux-2.6/block/blk-core.c:1912
>                                  * so that we don't add it again
>                                  */
> 
> The offset I got was 6e0d, but I guess thats the start of the following instruction
> by the time the fault is logged. Also I've attached my current .config just in case
> that might be a help is reproducing it,

Good work!  it's simpler if you compile with -g ... then the gdb line
command will just tell you all of this.  However, it seems clear that
elevator->ops is NULL (elevator_dispatch_fn is 0x28 offset into that in
a 64 bit system).

That's because blk_cleanup_queue called elevator_exit, so we need an out
in the peek case.

So unwrapping the onion, this is the next level

James

---

Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h
+++ linux-2.6/block/blk.h
@@ -62,7 +62,7 @@ static inline struct request *__elv_next
 			return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (!q->elevator->ops || !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }


