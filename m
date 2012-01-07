Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2AGRGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:06:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50172 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2AGRF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:05:58 -0500
Date: Sat, 7 Jan 2012 09:05:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they
 exist
Message-ID: <20120107170506.GA29261@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
 <1325499859-2262-8-git-send-email-gilad@benyossef.com>
 <4F033EC9.4050909@gmail.com>
 <20120105142017.GA27881@csn.ul.ie>
 <20120105144011.GU11810@n2100.arm.linux.org.uk>
 <20120105161739.GD27881@csn.ul.ie>
 <20120107165201.GA23939@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107165201.GA23939@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010717-3352-0000-0000-000001C75D24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 08:52:01AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 05, 2012 at 04:17:39PM +0000, Mel Gorman wrote:
> > On Thu, Jan 05, 2012 at 02:40:11PM +0000, Russell King - ARM Linux wrote:
> > > On Thu, Jan 05, 2012 at 02:20:17PM +0000, Mel Gorman wrote:
> 
> [ . . . ]
> 
> > > I've been chasing that patch and getting no replies what so
> > > ever from folk like Peter, Thomas and Ingo.
> > > 
> > > The problem affects all IPI-raising functions, which mask with
> > > cpu_online_mask directly.
> > 
> > Actually, in one sense I'm glad to hear it because from my brief
> > poking around, I was having trouble understanding why we were always
> > safe from sending IPIs to CPUs in the process of being offlined.
> 
> The trick is to disable preemption (not interrupts!) across the IPI, which
> prevents CPU-hotplug's stop_machine() from running.  You also have to
> have checked that the CPU is online within this same preemption-disabled
> section of code.  This means that the outgoing CPU has to accept IPIs
> even after its CPU_DOWN_PREPARE notifier has been called -- right up
> to the stop_machine() call to take_cpu_down().

Of course, another trick is to hold the CPU-hotplug lock across the IPI,
but this is quite a bit more heavy-weight than disabling preemption.

							Thanx, Paul

