Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0GWRn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:43:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0GWRn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:43:26 -0400
Date: Fri, 23 Jul 2010 19:40:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Message-ID: <20100723174036.GB29831@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com> <20100721144944.5351c741.akpm@linux-foundation.org> <20100721222529.EFBAA400B6@magilla.sf.frob.com> <20100722090524.GA6647@redhat.com> <20100722192446.E1258400B8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722192446.E1258400B8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Roland McGrath wrote:
>
> > So, this list_empty() check needs taskslit at least for reading. But, we
> > are going to take it for writing right after exit_ptrace() returns, afaics
> > we can add this fastpatch check for free.
>
> That looks good to me, but it could use some more scare comments.

Good. Hopfully Zhang can test it to confirm it has the same effect.
It should, but I am still wondering about 10% improvement.

> >  /*
> > - * Detach all tasks we were using ptrace on.
> > + * Detach all tasks we were using ptrace on. Called with tasklist held.
>
>  * Called with tasklist held for writing, and returns with it held too.
>  * But note it can release and reacquire the lock.

OK.

> > +	write_lock_irq(&tasklist_lock);
> > +
> 	/*
> 	 * Note that exit_ptrace() might drop tasklist_lock and reacquire it.
> 	 */
> >  	exit_ptrace(father);

Well, this comment a bit "unfair", please see below.

> > -	write_lock_irq(&tasklist_lock);
> >  	reaper = find_new_reaper(father);

Note that find_new_reaper() can drop/reacquire tasklist too.

Perhaps,

	/* These two might drop and reacquire tasklist_lock */
	exit_ptrace(father);
	reaper = find_new_reaper(father);

	...

?

Oleg.

