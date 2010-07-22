Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0GVTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab0GVTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:25:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
In-Reply-To: Oleg Nesterov's message of  Thursday, 22 July 2010 11:05:24 +0200 <20100722090524.GA6647@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
	<20100721144944.5351c741.akpm@linux-foundation.org>
	<20100721222529.EFBAA400B6@magilla.sf.frob.com>
	<20100722090524.GA6647@redhat.com>
X-Zippy-Says: Is there something I should be DOING with a GLAZED DONUT??
Message-Id: <20100722192446.E1258400B8@magilla.sf.frob.com>
Date: Thu, 22 Jul 2010 12:24:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, this list_empty() check needs taskslit at least for reading. But, we
> are going to take it for writing right after exit_ptrace() returns, afaics
> we can add this fastpatch check for free.

That looks good to me, but it could use some more scare comments.

>  /*
> - * Detach all tasks we were using ptrace on.
> + * Detach all tasks we were using ptrace on. Called with tasklist held.

 * Called with tasklist held for writing, and returns with it held too.
 * But note it can release and reacquire the lock.

> +	write_lock_irq(&tasklist_lock);
> +
	/*
	 * Note that exit_ptrace() might drop tasklist_lock and reacquire it.
	 */
>  	exit_ptrace(father);
>  
> -	write_lock_irq(&tasklist_lock);
>  	reaper = find_new_reaper(father);


Thanks,
Roland
