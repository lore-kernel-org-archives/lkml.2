Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab2FHPIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:08:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56059 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab2FHPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:08:47 -0400
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
In-Reply-To: <20120608144602.GA17251@fieldses.org>
References: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120603231709.GP30000@ZenIV.linux.org.uk>
	 <20120603232820.GQ30000@ZenIV.linux.org.uk>
	 <20120606194233.GA1537@redhat.com>
	 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
	 <20120606230040.GA18089@redhat.com>
	 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	 <1339064814.23343.14.camel@twins>
	 <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
	 <1339140698.23343.26.camel@twins>  <20120608144602.GA17251@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 17:08:34 +0200
Message-ID: <1339168114.2507.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 10:46 -0400, J. Bruce Fields wrote:
> > > > Sadly, if you get that annotation wrong you can annotate an actual
> > > > deadlock away.
> 
> What's a (contrived as you want) example where that happens?

spinlock_t lock_array[10];

void init_array(void)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(lock_array); i++)
		spin_lock_init(array + i);
}

void double_lock(int a, int b)
{
	spin_lock(lock_array + a);
	spin_lock_nested(lock_array + b, SINGLE_DEPTH_NESTING);
}

The above places all locks in the array in the same class, it then does
a double lock without order, but tells lockdep the nesting is ok.

A correct version of the double_lock() function would look like:

void double_lock(int a, int b)
{
	if (b < a)
		swap(a, b);

	spin_lock(lock_array + a);
	spin_lock_nested(lock_array + b, SINGLE_DEPTH_NESTING);
}

This orders the locks in array order.

> > > > This the reason you have to be very careful when
> > > > annotating stuff.
> 
> Or alternatively--what do I need to check before I call
> mutex_lock_nested? 

That the lock order you tell lockdep is ok, is indeed correct.


