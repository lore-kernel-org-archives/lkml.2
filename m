Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1ELQGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:06:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38228 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab1ELQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:06:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
In-Reply-To: Your message of "Thu, 12 May 2011 02:47:05 PDT."
             <20110512094704.GL2258@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <6921.1304989476@localhost> <20110510082029.GF2258@linux.vnet.ibm.com> <34783.1305155494@localhost>
            <20110512094704.GL2258@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305216324_4101P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 12 May 2011 12:05:24 -0400
Message-ID: <5817.1305216324@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DCC0546.00FE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305216324_4101P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 May 2011 02:47:05 PDT, "Paul E. McKenney" said:
> On Wed, May 11, 2011 at 07:11:34PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > My source has this:
> >
> >         raw_spin_lock_irqsave(&rnp->lock, flags);
> >         rnp->wakemask |= rdp->grpmask;
> >         invoke_rcu_node_kthread(rnp);
> >         raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >
> > the last 2 lines swapped from what you diffed against.  I can easily work around
> > that, except it's unclear what the implications of the invoke_rcu moving outside
> > of the irq save/restore pair (or if it being inside is the actual root cause)...
>
> Odd...
>
> This looks to me like a recent -next -- I do not believe that straight
> mmotm has rcu_cpu_kthread_timer() in it.  The patch should apply to the
> last few days' -next kernels.

Ah. Found it. Your tree and current linux-next include this commit:

commit	1217ed1ba5c67393293dfb0f03c353b118dadeb4
tree	a765356c8418e134de85fd05d9fe6eda41de859c	tree | snapshot
parent	29ce831000081dd757d3116bf774aafffc4b6b20	commit | diff
rcu: permit rcu_read_unlock() to be called while holding runqueue locks

which includes this chunk:

@@ -1546,8 +1531,8 @@ static void rcu_cpu_kthread_timer(unsigned long arg)

        raw_spin_lock_irqsave(&rnp->lock, flags);
        rnp->wakemask |= rdp->grpmask;
-       invoke_rcu_node_kthread(rnp);
        raw_spin_unlock_irqrestore(&rnp->lock, flags);
+       invoke_rcu_node_kthread(rnp);
 }


but that was committed 4 days ago, and Andrew pulled linux-next for the -mmotm
6 days ago, so it's not in there.  The *rest* of your recent commits appear to
be in there though.  So that explains the patch failure to apply.


--==_Exmh_1305216324_4101P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNzAVEcC3lWbTT17ARAq37AJ99BJDiC8la1nOfutkD43yaFULQKQCfUAbR
cLdUqxD+99QEOdSi1qrgUBY=
=p+Ll
-----END PGP SIGNATURE-----

--==_Exmh_1305216324_4101P--

