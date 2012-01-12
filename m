Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2ALPwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:52:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:60103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2ALPwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:52:46 -0500
Message-ID: <1326383551.2442.203.camel@twins>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Miklos Szeredi <mszeredi@novell.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
        Gong Chen <gong.chen@intel.com>
Date: Thu, 12 Jan 2012 16:52:31 +0100
In-Reply-To: <20120112153712.GL4118@suse.de>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
	 <1326276668-19932-3-git-send-email-mgorman@suse.de>
	 <1326381492.2442.188.camel@twins> <20120112153712.GL4118@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 15:37 +0000, Mel Gorman wrote:
> On Thu, Jan 12, 2012 at 04:18:12PM +0100, Peter Zijlstra wrote:
> > On Wed, 2012-01-11 at 10:11 +0000, Mel Gorman wrote:
> > > At least one bug report has
> > > been seen on ppc64 against a 3.0 era kernel that looked like a bug
> > > receiving interrupts on a CPU being offlined. 
> > 
> > Got details on that Mel? The preempt_disable() in on_each_cpu() should
> > serialize against the stop_machine() crap in unplug.
> 
> I might have added 2 and 2 together and got 5.
> 
> The stack trace clearly was while sending IPIs in on_each_cpu() and
> always when under memory pressure and stuck in direct reclaim. This was
> on !PREEMPT kernels where preempt_disable() is a no-op. That is why I
> thought get_online_cpu() would be necessary.

For non-preempt the required scheduling of stop_machine() will have to
wait even longer. Still there might be something funny, some of the
hotplug notifiers are ran before the stop_machine thing does its thing
so there might be some fun interaction.
