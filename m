Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1DLT5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:57:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58898 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920Ab1DLT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:57:02 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302633208.2661.29.camel@dolmen>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
	 <1302625621.2604.24.camel@mulgrave.site>  <1302627097.2661.25.camel@dolmen>
	 <1302630090.2604.30.camel@mulgrave.site>  <1302633208.2661.29.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 14:56:56 -0500
Message-ID: <1302638216.2604.35.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 19:33 +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Tue, 2011-04-12 at 12:41 -0500, James Bottomley wrote:
> > On Tue, 2011-04-12 at 17:51 +0100, Steven Whitehouse wrote:
> > > Still not quite there, but looking more hopeful now,
> > 
> > Not sure I share your optimism; but this one
> > 
> Neither do I any more :-) Looks like we are back in blk_peek_request()
> again. 
[...]
>                 if (!q->elevator->ops || !q->elevator->ops->elevator_dispatch_fn
> (q, 0))
>     6d62:       49 8b 44 24 18          mov    0x18(%r12),%rax
>     6d67:       48 8b 00                mov    (%rax),%rax
>     6d6a:       48 85 c0                test   %rax,%rax
>     6d6d:       74 0c                   je     6d7b <blk_peek_request+0x11b>
>     6d6f:       31 f6                   xor    %esi,%esi
>     6d71:       4c 89 e7                mov    %r12,%rdi                                <----- here
>     6d74:       ff 50 28                callq  *0x28(%rax)
>     6d77:       85 c0                   test   %eax,%eax
>     6d79:       75 da                   jne    6d55 <blk_peek_request+0xf5>
>     6d7b:       45 31 ed                xor    %r13d,%r13d

Hmm, wrong signal for no elevator then.  How about this?

James

---

Index: BUILD-2.6/block/blk.h
===================================================================
--- BUILD-2.6.orig/block/blk.h	2011-04-12 14:51:35.000000000 -0500
+++ BUILD-2.6/block/blk.h	2011-04-12 14:51:53.000000000 -0500
@@ -62,7 +62,8 @@ static inline struct request *__elv_next
 			return rq;
 		}
 
-		if (!q->elevator->ops || !q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }


