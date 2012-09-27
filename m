Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2I0SKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:10:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:46533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2I0SKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:10:13 -0400
Message-ID: <1348769391.3292.41.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 20:09:51 +0200
In-Reply-To: <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
References: <1348505683.11847.111.camel@twins>
	   <1348511193.6951.44.camel@marge.simpson.net>
	   <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	   <20120924192056.GB4082@liondog.tnic>
	   <1348538258.7100.23.camel@marge.simpson.net>
	   <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	   <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	   <20120925170058.GC30158@x1.osrc.amd.com>
	   <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	   <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	  <1348734104.3292.5.camel@twins>
	  <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
	 <1348767498.3292.29.camel@twins>
	 <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 10:45 -0700, david@lang.hm wrote:
> But I thought that this conversation (pgbench) was dealing with long 
> running processes, 

Ah, I think we've got a confusion on long vs short.. yes pgbench is a
long-running process, however the tasks might not be long in runnable
state. Ie it receives a request, computes a bit, blocks on IO, computes
a bit, replies, goes idle to wait for a new request.

If all those runnable sections are short enough, it will 'never' be
around when the periodic load-balancer does its thing, since that only
looks at the tasks in runnable state at that moment in time.

I say 'never' because while it will occasionally show up due to pure
chance, it will unlikely be a very big player in placement.

Once a cpu is overloaded enough to get real queueing they'll show up,
get dispersed and then its back to wakeup stuff.

Then again, it might be completely irrelevant to pgbench, its been a
while since I looked at how it schedules.
