Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2IYVLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:11:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:41743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab2IYVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,485,1344236400"; 
   d="scan'208";a="212947524"
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Tue, 25 Sep 2012 14:11:51 -0700
In-Reply-To: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
	 <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1348607511.26695.438.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 12:12 -0700, Linus Torvalds wrote:
> On Mon, Sep 24, 2012 at 11:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Aside from the cache pollution I recall having been mentioned, on my
> > E5620, cross core is a tbench win over affine, cross thread is not.
> 
> Oh, I agree with trying to avoid HT threads, the resource contention
> easily gets too bad.
> 
> It's more a question of "if we have real cores with separate L1's but
> shared L2's, go with those first, before we start distributing it out
> to separate L2's".

There is one issue though. If the tasks continue to run in this state
and the periodic balance notices an idle L2, it will force migrate
(using active migration) one of the tasks to the idle L2. As the
periodic balance tries to spread the load as far as possible to take
maximum advantage of the available resources (and the perf advantage of
this really depends on the workload, cache usage/memory bw, the upside
of turbo etc).

But I am not sure if this was the reason why we chose to spread it out
to separate L2's during wakeup.

Anyways, this is one of the places where the Paul Turner's task load
average tracking patches will be useful. Depending on how long a task
typically runs, we can probably even chose a SMT siblings or a separate
L2 to run.

thanks,
suresh

