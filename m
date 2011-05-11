Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1EKXMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:12:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41502 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab1EKXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:12:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
In-Reply-To: Your message of "Tue, 10 May 2011 01:20:29 PDT."
             <20110510082029.GF2258@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <6921.1304989476@localhost>
            <20110510082029.GF2258@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305155494_2793P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 May 2011 19:11:34 -0400
Message-ID: <34783.1305155494@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DCB17A7.0061,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305155494_2793P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 May 2011 01:20:29 PDT, "Paul E. McKenney" said:

Would test, but it doesn't apply cleanly to my -mmotm0506 tree:

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5616b17..20c22c5 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1525,13 +1525,15 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
>   */
>  static void rcu_cpu_kthread_timer(unsigned long arg)
>  {
> -	unsigned long flags;
> +	unsigned long old;
> +	unsigned long new;
>  	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
>  	struct rcu_node *rnp = rdp->mynode;
>  
> -	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	rnp->wakemask |= rdp->grpmask;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	do {
> +		old = rnp->wakemask;
> +		new = old | rdp->grpmask;
> +	} while (cmpxchg(&rnp->wakemask, old, new) != old);
>  	invoke_rcu_node_kthread(rnp);
>  }

My source has this:

        raw_spin_lock_irqsave(&rnp->lock, flags);
        rnp->wakemask |= rdp->grpmask;
        invoke_rcu_node_kthread(rnp);
        raw_spin_unlock_irqrestore(&rnp->lock, flags);

the last 2 lines swapped from what you diffed against.  I can easily work around
that, except it's unclear what the implications of the invoke_rcu moving outside
of the irq save/restore pair (or if it being inside is the actual root cause)...


--==_Exmh_1305155494_2793P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyxemcC3lWbTT17ARAhTcAKDq4c+9o0tv6pWdVzsGNS5JCHwu+wCgpWnJ
DZZAx2bdmaeLxXBAC2I8yLw=
=2YiI
-----END PGP SIGNATURE-----

--==_Exmh_1305155494_2793P--

