Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1LMLt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab1LMLt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:49:58 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Date: Tue, 13 Dec 2011 12:51:25 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        gregkh@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu
References: <20111210104341.592561407@chello.nl> <201112122356.47545.oliver@neukum.org> <20111212231419.GA11089@kroah.com>
In-Reply-To: <20111212231419.GA11089@kroah.com>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112131251.25451.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. Dezember 2011, 00:14:19 schrieb Greg KH:
> > I guess I worried not about the increment, but the decrement.
> > Which makes me wonder what happens if you don't intend
> > to get the kref again, but need to make sure it is usually freed,
> > like:
> > 
> > CPU A                                                         CPU B
> > 
> > kref_get(p)
> > start_io(p)
> >                                                                       [interrupt from IO]
> >                                                                       kref_put(p)
> > 
> > You need an ordering primitive between start_io() and kref_get()
> > or the counter could go negative.
> 
> Really?  On an atomic variable?  I didn't think this was needed for
> atomics to ensure this type of thing couldn't happen.

If you use an atomic variable you can be sure that the result will be
mathematically correct, even if you touch the variable from many CPUs.
(with add & sub of course) That is, refering to that variable.

It does not guarantee ordering

CPU A								CPU B
atomic_set(&a, 1);
atomic_set(&b, 1);
atomic_set(&c, 1);
									while (!atomic_read(&c));
									d = atomic_read(&a) + atomic_read(&b);

is asking for trouble. You need to do:

CPU A								CPU B
atomic_set(&a, 1);
atomic_set(&b, 1);
smp_wmb();
atomic_set(&c, 1);
									while (!atomic_read(&c));
									smp_rmb();
									d = atomic_read(&a) + atomic_read(&b);

Now replace c with an interrupt and you see the problem. It definitely exists,
but my solution was quite bad. The wmb() must be in start_io() in the first example
I gave. Putting it into kref was the wrong place.

	Regards
		Oliver

PS: even in the example I first gave the result will eventually be 0.
But that is useless because the check for zero is done only in kref_put()


-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
