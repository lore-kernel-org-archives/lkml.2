Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0FKUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:44:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17839 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759554Ab0FKUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:44:41 -0400
Date: Fri, 11 Jun 2010 13:43:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: to@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/4 v3][RFC] Infrastructure for compact call location
 representation
Message-Id: <20100611134300.4a14c505.randy.dunlap@oracle.com>
In-Reply-To: <20100611203356.GA28446@dvomlehn-lnx2.corp.sa.net>
References: <20100611203356.GA28446@dvomlehn-lnx2.corp.sa.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4C12A02E.017A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 13:33:56 -0700 David VomLehn wrote:

> This patch allows the location of a call to be recorded as a small integer,
> with each call location ("callsite") assigned a new value the first time
> the code in that location is executed. Locations can be recorded as a
> an address or as a __FILE__/__LINE__ pair. The later is easier to read, but
> requires significantly more space.

Did you happen to look at what drivers/base/power/trace.c does for callsite
recording?


> The goal here was to record the location in very few bits but, at the same
> time, to have minimal overhead.  The key observation towards achieving this
> goals is to note that there are are far fewer locations where calls of
> interest are made than there are addresses. If the site of each call of
> interest is assigned a unique ID, and there are fewer than n of them,
> only log2(n) bits are required to identify the call site. If the IDs
> are assigned dynamically and most call sites aren't reached, you can get
> by with even fewer bits.
> 
> This is debugging code and callsite IDs are generally only used when failures
> are detected, so though the mapping from a callsite location to a callsite ID
> must be fast, speed is not as critical for the reverse mapping. Also, an ID
> is assigned to a callsite just once, so it is acceptable to take a while to
> assign an ID, but things should run with minimal delay if an ID is already
> assigned.
> 
> The major implementation pieces are:
> 1.	Two macros are provided for use in wrapping functions that are to
> 	be instrumented. CALLSITE_CALL is for functions that return values,
> 	CALLSITE_CALL_VOID is used for functions that do not.
> 2.	The call site infrastructure consists of three data structures:
> 	a.	A statically allocated struct callsite_id holds the ID for
> 		the call site.
> 	b.	A statically allocated struct callsite_static holds
> 		information which is constant for each callsite. The call site
> 		ID could be combined with this, but by separating them I hope
> 		to avoid polluting the cache with this very cold information.
> 	c.	A struct callsite_frame builds on the oobparam infrastructure
> 		and holds the call site ID. This is assigned at this time
> 		if this had not previously been done. This will be pushed on
> 		the OOB parameter stack before calling the skb_* function
> 		and popped after it returns.
> 3.	A callsite_top structure is added to task_struct. When a call site
> 	is entered, its callsite_frame is pushed on the call site stack.
> 4.	When a function needs to know the call site ID so it can be stored,
> 	it gets it from the callsite_frame at the top of the call site
> 	stack.
> 
> Notes
> o	Under simple test conditions, the number of call site IDs allocated
> 	can be quite small, small enough to fit in 6 bits. That would reduce
> 	the sk_buff growth to one byte. This is *not* a recommended
> 	configuration.
> o	This is placed in net/core and linux/net since those are the only
> 	current users, but there is nothing about this that is networking-
> 	specific.
> 
> Restrictions
> o	Call site IDs are never reused, so it is possible to exceed the
> 	maximum number of IDs by having a large number of call locations.
> 	In addition, it does not recognize that the same module has been
> 	unloaded and reloaded, so calls from the reloaded module will be
> 	assigned new IDs. Detection of incorrect operations on an sk_buff
> 	is not affected by exhaustion of call site IDs, but it may not be
> 	possible to determine the location of the last operation.
> 	CONFIG_DEBUG_SKB_ID_SIZE is set to reduce the sk_buff growth to 16
> 	bits and should handle most cases. It could be made larger to allow
> 	more call site IDs, if necessary.
> o	The callsite structures for a module will be freed when that module
> 	is unloaded, even though sk_buffs may be using IDs corresponding to
> 	those call sites. To allow useful error reporting, the call site
> 	information in a module being unloaded is copied. If
> 	CONFIG_CALLSITE_TERSE is not enabled and the module that last changed
> 	the sk_buff is no longer loaded, the address of the call site
> 	is no longer valid, so only the function name and offset are printed
> 	if the module is unloaded. If it is loaded, the address is also
> 	reported.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
