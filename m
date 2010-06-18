Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0FREv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:51:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56920 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0FREv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:51:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JWTX25AGZyLKK/SZmoUsy62WoP207LZRILsnn2/78HKAZQrAjBAxVyxNg3JQYrVquM
         tNvaXj4rcaMMIxC9V/+J3io0qmqOi/4XrPHOy9H4qhnjavnUkfQVQao9QlhnEOCcF7zT
         3BPxEXvcQgIPhwTNT72t7pJfkRi01v3ex1/Dk=
Date: Fri, 18 Jun 2010 06:51:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
Message-ID: <20100618045155.GG5345@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.241599593@chello.nl> <20100616170354.GA5530@nowhere> <1276710480.1745.608.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276710480.1745.608.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 07:48:00PM +0200, Peter Zijlstra wrote:
> > > +
> > > +struct pmu *perf_init_event(struct perf_event *event)
> > > +{
> > > +	struct pmu *pmu;
> > > +	int idx;
> > > +
> > > +	idx = srcu_read_lock(&pmus_srcu);
> > > +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> > > +		int ret = pmu->event_init(event);
> > > +		if (!ret)
> > > +			break;
> > > +		if (ret != -ENOENT) {
> > > +			pmu = ERR_PTR(ret);
> > > +			break;
> > >  		}
> > > -		pmu = &perf_ops_generic;
> > > -		break;
> > >  	}
> > > +	srcu_read_unlock(&pmus_srcu, idx);
> > 
> > 
> > 
> > This could use a simple mutex instead of a spinlock + srcu_sync on
> > writer and srcu on reader.
> 
> Right, that spinlock needs to be a mutex for sure, a later patch adds an
> allocation under it.
> 
> But even with a mutex we need srcu_sync in there to sync against the
> readers.
> 
> > That doesn't matter much that said. What I don't understand is
> > why we need to synchronize the writers. Walking the list with
> > list_*_rcu() looks justified once we support boot events, but
> > until then...
> 
> Well, the typical unregister user would be a module, if you unregister
> and then dealloc the struct pmu by unloading the module a reader might
> still see a reference to it if you don't srcu_sync it.


Ok, I see what you mean.

