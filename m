Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1AIXLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:11:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59130 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1AIXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KDg/DZH20zqvusAA25kfWCphxB5vGDvCNSwRALid0doylHlbyIXLa6S2nIPgtvlQbQ
         jJx6F5xN4owI7E7v8zeECHGqnzhbjZ3Dg51kYq4pelKmig/sx+e6JgPEp2AXJQ51SpmE
         SUiQ9207I/YaxPH7O5zqEqTvf67po5z93uRQ0=
Date: Sun, 9 Jan 2011 18:11:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 12/17] sched: Also serialize ttwu_local() with
 p->pi_lock
Message-ID: <20110109231142.GA28206@mtj.dyndns.org>
References: <20101224122338.172750730@chello.nl>
 <20101224123743.101203663@chello.nl>
 <20110103173254.GA14742@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103173254.GA14742@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 06:32:54PM +0100, Oleg Nesterov wrote:
> > @@ -2523,16 +2523,21 @@ static void try_to_wake_up_local(struct
> >
> >  	BUG_ON(rq != this_rq());
> >  	BUG_ON(p == current);
> > -	lockdep_assert_held(&rq->lock);
> > +
> > +	raw_spin_unlock(&rq->lock);
> > +	raw_spin_lock(&p->pi_lock);
> > +	raw_spin_lock(&rq->lock);
> 
> I _think_ this is safe, this worker can't change cpu afaics. But
> probably Tejun can take a look, just in case.

Yeah, preemption is disabled so it should be safe.  Only bound workers
can be woken up by ttwu_local.  They get migrated to another CPU only
during CPU offlining.  Both CPU offlining and task exit wouldn't
happen while preemption is disabled so it should be safe.

Thanks.

-- 
tejun
