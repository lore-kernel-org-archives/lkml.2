Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1LKMsC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 07:48:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:35623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LKMsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 07:48:00 -0500
Message-ID: <1323607627.16764.13.camel@twins>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Date: Sun, 11 Dec 2011 13:47:07 +0100
In-Reply-To: <CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.295857663@chello.nl>
	 <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	 <1323529084.16764.5.camel@twins>
	 <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
	 <1323546551.2822.14.camel@laptop>
	 <CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 10:22 +0800, Ming Lei wrote:
> On Sun, Dec 11, 2011 at 3:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Sat, 2011-12-10 at 23:57 +0800, Ming Lei wrote:
> >
> >> CPU0                  CPU1
> >>
> >> atomic_set(v)
> >> smp_mb()
> >>                               smp_mb()
> >>                               atomic_dec_and_test(v)
> >>
> >> Without the barrier after atomic_set, CPU1 may see a stale
> >> value of v first, then decrease it, so may miss a release operation.
> >
> > Your example is doubly broken. If there's concurrency possible with
> > atomic_set() you've lost.
> 
> kref_init is guaranteed to be run only one time __before__ executing
> kref_get/kref_put.

If used properly, yes. But in that case you still don't need the
barrier. Whatever means you use to make the object visible to other CPUs
will include a barrier.

> > Lets change it to kref_get() aka atomic_inc():
> >
> >        CPU0            CPU1
> >
> >        atomic_inc()
> >                        atomic_dec_and_test()
> >
> > and
> >
> >                        atomic_dec_and_test()
> >        atomic_inc()
> >
> > For if the first is possible, then so is the second.
> 
> Yes, both are reasonable.
> 
> >
> > This illustrates that no matter how many barriers you put in, you're
> > still up shit creek without no paddle because the kref_put() can come in
> > before you do the kref_get(), making the kref_get() the invalid
> > operation.
> 
> So one smp_mb__before_atomic_inc should be added before atomic_inc
> to make sure that CPU0 can see the uptodate ref, right?

No.

Assume v == 1:

	CPU0		CPU1

			atomic_dec_and_test(); /* --v == 0 */
				kfree()

	smp_mb__before_atomic_inc()
	atomic_inc(); <-- OOPS!


You still got an access to already freed memory. There is no amount of
memory barriers that will solve this problem.

> But the initial value of kref is 1, so seems we don't need to consider
> the 0-refs.

There's a dec in there, isn't it. How much is 1-1?


