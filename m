Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0KHPVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0KHPVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:21:34 -0500
Date: Mon, 8 Nov 2010 16:15:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
	kernel/pid.c:419 invoked rcu_dereference_check() without protection!
Message-ID: <20101108151509.GA3702@redhat.com>
References: <xr93fwwbdh1d.fsf@ninji.mtv.corp.google.com> <20101107182028.GZ15561@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107182028.GZ15561@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Paul E. McKenney wrote:
>
> On Tue, Oct 12, 2010 at 12:08:46AM -0700, Greg Thelen wrote:
> >
> > ioprio_set() contains a comment warning against of usage of
> > rcu_read_lock() to avoid this warning:
> > 	/*
> > 	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
> > 	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
> > 	 * in copy_process().
> > 	 */
> >
> > So I'm not sure what the best fix is.

(please note that "we can't use rcu_read_lock()" actually meant
 rcu_read_lock() is not _enough_)

> I must defer to Oleg, who wrote the comment.  But please see below.

I added this comment to explain some oddities in copy_process().
Nobody confirmed my understanding was correct ;)

In any case, this comment doesn't look right today. This code was
changed by fd0928df98b9578be8a786ac0cb78a47a5e17a20
"ioprio: move io priority from task_struct to io_context" after that,
tasklist can't help to make sys_ioprio_set(IOPRIO_WHO_PGRP) atomic.

I think tasklist_lock can be removed now.

And, as Paul pointed out, we need rcu_read_lock() anyway, it was
already added by Sergey.

Oleg.

