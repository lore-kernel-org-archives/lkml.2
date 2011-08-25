Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1HYRiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:38:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50464 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1HYRiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:38:02 -0400
MIME-Version: 1.0
Message-ID: <d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default>
Date: Thu, 25 Aug 2011 10:37:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 2/4] mm: frontswap: core code
References: <20110823145815.GA23190@ca-server1.us.oracle.com
 20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E56885B.0017:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
> 
> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V7 2/4] mm: frontswap: core code
> >
> > This second patch of four in this frontswap series provides the core code
> 
> I think you should add diffstat...

The diffstat is in [PATCH V7 0/4] for the whole patchset.  I didn't
think a separate diffstat for each patch in the patchset was necessary?

> and add include changes to Makefile in the same patch.

The Makefile change must be in a patch after the patch that
creates frontswap.o or the build will fail.

> I have small questions.
> 
> > +/*
> > + * frontswap_ops is set by frontswap_register_ops to contain the pointers
> > + * to the frontswap "backend" implementation functions.
> > + */
> > +static struct frontswap_ops frontswap_ops;
> > +
> 
> Hmm, only one frontswap_ops can be registered to the system ?
> Then...why it required to be registered ? This just comes from problem in
> coding ?

Yes, currently only one frontswap_ops can be registered.  However there
are different users (zcache and Xen tmem) that will register different
callbacks for the frontswap_ops.  A future enhancement may allow "chaining"
(see https://lkml.org/lkml/2011/6/3/202 which describes chaining for
cleancache).

> BTW, Do I have a chance to implement frontswap accounting per cgroup
> (under memcg) ? Or Do I need to enable/disale switch for frontswap per memcg ?
> Do you think it is worth to do ?

I'm not very familiar with cgroups or memcg but I think it may be possible
to implement transcendent memory with cgroup as the "guest" and the default
cgroup as the "host" to allow for more memory elasticity for cgroups.
(See http://lwn.net/Articles/454795/ for a good overview of all of
transcendent memory.)

> > +/*
> > + * This global enablement flag reduces overhead on systems where frontswap_ops
> > + * has not been registered, so is preferred to the slower alternative: a
> > + * function call that checks a non-global.
> > + */
> > +int frontswap_enabled;
> > +EXPORT_SYMBOL(frontswap_enabled);
> > +
> > +/* useful stats available in /sys/kernel/mm/frontswap */
> > +static unsigned long frontswap_gets;
> > +static unsigned long frontswap_succ_puts;
> > +static unsigned long frontswap_failed_puts;
> > +static unsigned long frontswap_flushes;
> > +
> 
> What lock guard these ? swap_lock ?

These are informational statistics so do not need to be protected
by a lock or an atomic-type.  If an increment is lost due to a cpu
race, it is not a problem.

> > +/*
> > + * register operations for frontswap, returning previous thus allowing
> > + * detection of multiple backends and possible nesting
> > + */
> > +struct frontswap_ops frontswap_register_ops(struct frontswap_ops *ops)
> > +{
> > +	struct frontswap_ops old = frontswap_ops;
> > +
> > +	frontswap_ops = *ops;
> > +	frontswap_enabled = 1;
> > +	return old;
> > +}
> > +EXPORT_SYMBOL(frontswap_register_ops);
> > +
> 
> No lock ? and there is no unregister_ops() ?

Right now only one "backend" can register with frontswap.  Existing
backends (zcache and Xen tmem) only register when enabled via a
kernel parameter.  In the future, there will need to be better
ways to do this, but I think this is sufficient for now.

So since only one backend can register, no lock is needed and
no unregister is needed yet.

> > +/* Called when a swap device is swapon'd */
> > +void __frontswap_init(unsigned type)
> > +{
> > +	struct swap_info_struct *sis = swap_info[type];
> > +
> > +	BUG_ON(sis == NULL);
> > +	if (sis->frontswap_map == NULL)
> > +		return;
> > +	if (frontswap_enabled)
> > +		(*frontswap_ops.init)(type);
> > +}
> > +EXPORT_SYMBOL(__frontswap_init);
> > +
> > +/*
> > + * "Put" data from a page to frontswap and associate it with the page's
> > + * swaptype and offset.  Page must be locked and in the swap cache.
> > + * If frontswap already contains a page with matching swaptype and
> > + * offset, the frontswap implmentation may either overwrite the data
> > + * and return success or flush the page from frontswap and return failure
> > + */
> 
> What lock should be held to guard global variables ? swap_lock ?

Which global variables do you mean and in what routines?  I think the
page lock is required for put/get (as documented in the comments)
but not the swap_lock.

Thanks,
Dan
