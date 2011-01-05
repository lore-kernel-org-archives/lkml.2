Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1AETeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1AETeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:34:36 -0500
Date: Wed, 5 Jan 2011 20:26:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
Message-ID: <20110105192634.GA30361@redhat.com>
References: <20101224122338.172750730@chello.nl> <20101224123742.724459093@chello.nl> <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com> <1294054362.2016.74.camel@laptop> <20110104064542.GF3402@amd> <1294254867.2016.281.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294254867.2016.281.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05, Peter Zijlstra wrote:
>
> On Tue, 2011-01-04 at 17:45 +1100, Nick Piggin wrote:
> > So I agree, taking it out the back and shooting it in the head would make
> > the world a better place.
>
> There appear to be only two callsites of said horror,

Not sure I understand why spin_unlock_wait() is really awful, but OK.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -956,7 +956,8 @@ NORET_TYPE void do_exit(long code)
>  	 * an exiting task cleaning up the robust pi futexes.
>  	 */
>  	smp_mb();
> -	raw_spin_unlock_wait(&tsk->pi_lock);
> +	raw_spin_lock_irq(&tsk->pi_lock);
> +	raw_spin_unlock_irq(&tsk->pi_lock);

then you can kill smp_mb() above.

Oleg.

