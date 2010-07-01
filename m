Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0GAOKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0GAOKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:10:50 -0400
Date: Thu, 1 Jul 2010 16:08:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: A possible sys_wait* bug
Message-ID: <20100701140836.GA8379@redhat.com>
References: <AANLkTinUy8Uk8pAom03DKzYTqthdXQ5ADfjGmjbI7jxN@mail.gmail.com> <20100701093621.DA24.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701093621.DA24.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, KOSAKI Motohiro wrote:
>
> > Basically, it is possibly for readers to continuously hold
> > tasklist_lock

Yes, this is the known problem.

Perhaps do_wait() is not the worst example. sys_kill(-1),
sys_ioprio_set() scan the global list.

> > I think the most direct approach to the problem is to have the
> > readers-writer locks be writer biased (i.e. as soon as a writer
> > contends, we do not permit any new readers).

I thought about this too, but this is deadlockable. At least,
read_lock(tasklist) should nest, and it should work in irq context.

We need the more fine-grained locking, but it is not clear to me what
should be done in the long term. Afaics, this is very nontrivial.

Oleg.

