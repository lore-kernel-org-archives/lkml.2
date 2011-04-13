Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1DMBFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:05:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:7030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1DMBFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,200,1301900400"; 
   d="scan'208";a="908799353"
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
In-Reply-To: <20110412190251.GD16342@mtj.dyndns.org>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <20110412190251.GD16342@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:05:36 +0800
Message-ID: <1302656736.3981.138.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 03:02 +0800, Tejun Heo wrote:
> On Tue, Apr 12, 2011 at 04:04:04PM +0800, Shaohua Li wrote:
> >  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> >  {
> > +#if BITS_PER_LONG == 32
> > +	s64 count;
> > +	spin_lock(&fbc->lock);
> > +	count = fbc->count;
> > +	spin_unlock(&fbc->lock);
> > +	return count;
> > +#else
> >  	return fbc->count;
> > +#endif
> 
> I don't know.  Is there any problem caused by this?  The interface is
> known to be unreliable and already being used in speculative manner.
> I think it's more beneficial to avoid using locks on fast read path.
yes, it is unreliable, but only in an extent of batch*nr_cpus. accessing
64bits in 32bit machine can give us a _very_ big inaccuracy, which is
unacceptable to me.

