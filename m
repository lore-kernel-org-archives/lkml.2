Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1LIDKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 22:10:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:11605 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab1LIDK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 22:10:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83864145"
Date: Fri, 9 Dec 2011 11:00:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111209030025.GA17149@localhost>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
 <1322851407-17182-3-git-send-email-andi@firstfloor.org>
 <20111206114438.GA17186@localhost>
 <20111206171751.GA15062@alboin.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206171751.GA15062@alboin.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:17:51AM +0800, Andi Kleen wrote:
> On Tue, Dec 06, 2011 at 07:44:38PM +0800, Wu Fengguang wrote:
> > > +#include <linux/seq_file.h>
> > > +#include <linux/percpu.h>
> > > +#include <linux/kernel.h>
> > > +
> > > +/* OPEN: implement module support */
> > 
> > Yeah, I think the module support would benefit my case as well.
> > 
> > To support module users, init_counters() will be exported with the
> > __start___debugfs/__stop___debugfs hard coding removed. Then I'll be
> > call it from the readahead initilization code:
> 
> No, the module loader should take care of this: look for the magic
> section, register it. This is already done for other magic
> sections and not too difficult, i just didn't write the code
> so far.
>
> Then the DEFINE_* macros would work seamlessly in modules too.
 
OK.

> Do you really need it for the readahead code? I thought that
> was builtin.

Yeah because in the current form I'm initializing an array of counters
at runtime in the readahead call site. 

> > DEFINE_PER_CPU(unsigned long[RA_PATTERN_MAX][RA_ACCOUNT_MAX], ra_counter);
> > struct debugfs_counter ra_pcpu_counter[RA_PATTERN_MAX][RA_ACCOUNT_MAX];
> > 
> > // init ra_pcpu_counter in a loop
> > for each pattern
> >         init_counters(ra_pcpu_counter[pattern], ra_pcpu_counter[pattern+1]);
> 
> Ok so you need arrays.
> 
> The idea is to not call some init function, but just put it into section
> and let the init code walk it.
> 
> Should probably have a macro that handles arrays nicely.

That would be nice!

> > > +static int show_debugfs_counter(struct seq_file *m, void *arg)
> > > +{
> > > +	int n;
> > > +	n = dump_counters(m, __start___debugfs, __stop___debugfs, m->private);
> > 
> > That hard coded __start___debugfs/__stop___debugfs is OK for POC, and
> > will need to be improved to work with multiple users in kernel.
> 
> For Modules it obviously has to walk a list. It's a straight forward extension.
> 
> I don't think it should allow everyone to register their own lists,
> that doesn't make sense because they could as well create the debug 
> files themselves.

OK. It just looks a bit inefficient when (this becomes so popular that)
the list grows large.

Thanks,
Fengguang
