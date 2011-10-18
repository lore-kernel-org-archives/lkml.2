Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1JRMz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab1JRMzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:55:25 -0400
Date: Tue, 18 Oct 2011 08:49:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, "Chen, Gong" <gong.chen@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Message-ID: <20111018124929.GA3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017164715.e42591d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017164715.e42591d5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 04:47:15PM -0700, Andrew Morton wrote:
> On Fri, 14 Oct 2011 16:53:05 -0400
> > @@ -131,11 +133,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
> >  		total += l1_cpy + l2_cpy;
> >  		part++;
> >  	}
> > -	if (in_nmi()) {
> > -		if (is_locked)
> > -			spin_unlock(&psinfo->buf_lock);
> > -	} else
> > -		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> > +	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> >  }
> 
> afacit this assumes that (reason == KMSG_DUMP_PANIC) if in_nmi().  Is
> that always the case, and will it always be the case in the future?

I see your point.  For now yes.  The common case for which I think pstore
was designed for was the APEI/GHES case.  Normally when GHES hits an NMI
it stays at the APEI/GHES layer and either uses an irq_workqueue for
recoverable errors or panics on non-recoverable errors.

So currently the only time it reaches the pstore layer is in the panic
case.  Unfortunately, I can't vouch for all the backends that can hook
into pstore.

Perhaps a 'BUG_ON(in_nmi() && reason != KMSG_DUMP_PANIC)'?


> 
> I felt that the spin_trylock() approach was less horrid than this.  I
> assume that the new approach will cause lockdep to go berzerk?

Heh.  Good point.  That is probably a good test case.  Though finding a
working GHES implementation in the firmware isn't easy these days, making
it hard to test. :-/

Cheers,
Don
