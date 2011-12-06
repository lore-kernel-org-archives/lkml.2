Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1LFRRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:17:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:38169 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1LFRRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:17:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,306,1320652800"; 
   d="scan'208";a="99245418"
Date: Tue, 6 Dec 2011 09:17:51 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111206171751.GA15062@alboin.jf.intel.com>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
 <1322851407-17182-3-git-send-email-andi@firstfloor.org>
 <20111206114438.GA17186@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206114438.GA17186@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 07:44:38PM +0800, Wu Fengguang wrote:
> > +#include <linux/seq_file.h>
> > +#include <linux/percpu.h>
> > +#include <linux/kernel.h>
> > +
> > +/* OPEN: implement module support */
> 
> Yeah, I think the module support would benefit my case as well.
> 
> To support module users, init_counters() will be exported with the
> __start___debugfs/__stop___debugfs hard coding removed. Then I'll be
> call it from the readahead initilization code:

No, the module loader should take care of this: look for the magic
section, register it. This is already done for other magic
sections and not too difficult, i just didn't write the code
so far.

Then the DEFINE_* macros would work seamlessly in modules too.

Do you really need it for the readahead code? I thought that
was builtin.


> 
> DEFINE_PER_CPU(unsigned long[RA_PATTERN_MAX][RA_ACCOUNT_MAX], ra_counter);
> struct debugfs_counter ra_pcpu_counter[RA_PATTERN_MAX][RA_ACCOUNT_MAX];
> 
> // init ra_pcpu_counter in a loop
> for each pattern
>         init_counters(ra_pcpu_counter[pattern], ra_pcpu_counter[pattern+1]);

Ok so you need arrays.

The idea is to not call some init function, but just put it into section
and let the init code walk it.

Should probably have a macro that handles arrays nicely.

> > +static int show_debugfs_counter(struct seq_file *m, void *arg)
> > +{
> > +	int n;
> > +	n = dump_counters(m, __start___debugfs, __stop___debugfs, m->private);
> 
> That hard coded __start___debugfs/__stop___debugfs is OK for POC, and
> will need to be improved to work with multiple users in kernel.

For Modules it obviously has to walk a list. It's a straight forward extension.

I don't think it should allow everyone to register their own lists,
that doesn't make sense because they could as well create the debug 
files themselves.

-Andi
