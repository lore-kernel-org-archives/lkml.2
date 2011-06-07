Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1FGNr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:47:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:37750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1FGNr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:47:26 -0400
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 15:47:19 +0200
Message-ID: <1307454439.2322.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 21:41 +0800, Hillf Danton wrote:
> It is suppose to check the owner task that is not absolutly running on the
> local CPU, 

Oh, why do you think so?

> and if NEED_RESCHED is happenly set on the current task of local
> CPU, we get incorrect result.

Only if your above assumption holds, which it doesn't. It explicitly
checks to see if _this_ cpu needs a resched while spinning, if so it
bails the spinning and calls schedule in the lock slow path.

If the owner cpu reschedules, owner will leave the rq and
owner_running() will return false, also breaking the loop.

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index fd18f39..3ea64fe 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4326,7 +4326,7 @@ int mutex_spin_on_owner(struct mutex *lock,
> struct task_struct *owner)
>  		return 0;
> 
>  	while (owner_running(lock, owner)) {
> -		if (need_resched())
> +		if (test_tsk_need_resched(owner))
>  			return 0;
> 
>  		arch_mutex_cpu_relax();

