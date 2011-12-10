Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1LJUC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 15:02:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1LJUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 15:02:27 -0500
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
In-Reply-To: <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.295857663@chello.nl>
	 <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	 <1323529084.16764.5.camel@twins>
	 <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 20:49:11 +0100
Message-ID: <1323546551.2822.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 23:57 +0800, Ming Lei wrote:

> CPU0			CPU1
> 
> atomic_set(v)
> smp_mb()
> 				smp_mb()
> 				atomic_dec_and_test(v)
> 
> Without the barrier after atomic_set, CPU1 may see a stale
> value of v first, then decrease it, so may miss a release operation.

Your example is doubly broken. If there's concurrency possible with
atomic_set() you've lost.

Lets change it to kref_get() aka atomic_inc():

	CPU0		CPU1

	atomic_inc()
			atomic_dec_and_test()

and

			atomic_dec_and_test()
	atomic_inc()

For if the first is possible, then so is the second.

This illustrates that no matter how many barriers you put in, you're
still up shit creek without no paddle because the kref_put() can come in
before you do the kref_get(), making the kref_get() the invalid
operation.

> The pair of smp_mb can make order between atomic_set
> and atomic_dec_and_test, can't it?

No. Because there's nothing stopping the dec from happening before the
set/inc.

> > If there's a destruction race with kref_put() the barrier won't
> 
> Sorry, could you say what the destruction race is?

The race to 0-refs, iow. the case above when you assume both cases start
out with 1 ref.


