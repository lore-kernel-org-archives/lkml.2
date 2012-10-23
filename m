Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2JWVro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:47:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:47284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2JWVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:47:40 -0400
Date: Tue, 23 Oct 2012 23:47:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, peterz@infradead.org,
        mingo@redhat.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        xemul@parallels.com
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
In-Reply-To: <1350978723.8609.1555.camel@edumazet-glaptop>
Message-ID: <alpine.LFD.2.02.1210232345200.2756@ionos>
References: <20121023073913.23514.87934.stgit@localhost.localdomain> <1350978723.8609.1555.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Eric Dumazet wrote:

> On Tue, 2012-10-23 at 11:40 +0400, Stanislav Kinsbursky wrote:
> > This patch is required CRIU project (www.criu.org).
> > To migrate processes with posix timers we have to make sure, that we can
> > restore posix timer with proper id.
> > Currently, this is not true, because timer ids are allocated globally.
> > So, this is precursor patch and it's purpose is make posix timer id to be
> > allocated per process.
> > 
> > Patch replaces global idr with global hash table for posix timers and
> > makes timer ids unique not globally, but per process. Next free timer id is
> > type of integer and stored on signal struct (posix_timer_id). If free timer id
> > reaches negative value on timer creation, it will be dropped to zero and
> > -EAGAIN will be returned to user.
> > 
> > Hash table has 512 slots.
> > Key is constructed as follows:
> > key = hash_32(hash_32(current->signal) ^ posix_timer_id));
> > 
> > Note: with this patch, id, returned to user, is not the minimal free
> > amymore. It means, that id, returned to user space in loop, listed below, will
> > be increasing on each iteration till INT_MAX and then dropped to zero:
> > 
> > while(1) {
> > 	id = timer_create(...);
> > 	timer_delete(id);
> > }
> > 
> > Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > 
> > ---
> 
> SGTM

Not so good to me.
 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

And that should be either an Acked-by or a Reviewed-by. You can't sign
off on patches which have not been submitted or transported by you.

Thanks,

	tglx


