Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1GSNJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:09:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:52512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1GSNJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:09:07 -0400
Subject: Re: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
References: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de>
	 <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Jul 2011 15:08:41 +0200
Message-ID: <1311080921.13765.203.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 16:24 -0700, Paul Turner wrote:

> Subject: [PATCH] sched: handle on_list ancestor in leaf_add_cfs_rq()
> From: Paul Turner <pjt@google.com>
> Date: Mon, 18 Jul 2011 16:08:10 -0700
> 
> Jan H. Schönherr found that in the case of an on_list ancestor we may
> incorrectly place the child to the right of a great-ancestor on the list.
> 
> Consider:
> 
>       A
>      / \     Here, t1A results in A->cfs_rq being on_list, however when
>     B  t1A   we start enqueuing from C this will not be visible.  This is
>    /         compounded by the fact that on_list expiration may also be out
>   C          of order, punching holes in the tree.
>  /
> t1C
> 
> Prevent this by making additions to the leaf_cfs_rq_list position independent.
> This is done by maintaining additions to this list within the
> enqueue_task_fair() path, which allows us to always enqueue against the
> current entity's first on_list ancestor.

The problem I have with this is that it makes the enqueue more
expensive. We're now optimizing a relatively slow path (load-balance) at
the cost of the hottest path in the kernel (enqueue/dequeue).


