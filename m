Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2AGQwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 11:52:12 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55535 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2AGQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 11:52:10 -0500
Date: Sat, 7 Jan 2012 08:52:01 -0800
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
Message-ID: <20120107165201.GA23939@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
 <1325499859-2262-8-git-send-email-gilad@benyossef.com>
 <4F033EC9.4050909@gmail.com>
 <20120105142017.GA27881@csn.ul.ie>
 <20120105144011.GU11810@n2100.arm.linux.org.uk>
 <20120105161739.GD27881@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105161739.GD27881@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010716-4242-0000-0000-00000075A751
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 04:17:39PM +0000, Mel Gorman wrote:
> On Thu, Jan 05, 2012 at 02:40:11PM +0000, Russell King - ARM Linux wrote:
> > On Thu, Jan 05, 2012 at 02:20:17PM +0000, Mel Gorman wrote:

[ . . . ]

> > I've been chasing that patch and getting no replies what so
> > ever from folk like Peter, Thomas and Ingo.
> > 
> > The problem affects all IPI-raising functions, which mask with
> > cpu_online_mask directly.
> 
> Actually, in one sense I'm glad to hear it because from my brief
> poking around, I was having trouble understanding why we were always
> safe from sending IPIs to CPUs in the process of being offlined.

The trick is to disable preemption (not interrupts!) across the IPI, which
prevents CPU-hotplug's stop_machine() from running.  You also have to
have checked that the CPU is online within this same preemption-disabled
section of code.  This means that the outgoing CPU has to accept IPIs
even after its CPU_DOWN_PREPARE notifier has been called -- right up
to the stop_machine() call to take_cpu_down().

							Thanx, Paul

