Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab2BJU3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:29:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2BJU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:29:34 -0500
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
In-Reply-To: <CAOtvUMfZ-sfTd-WTV=+RcerTk6ejC2mmjrMGg8KkdMR=RaV+CA@mail.gmail.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	 <1327591185.2446.102.camel@twins>
	 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	 <20120201170443.GE6731@somewhere.redhat.com>
	 <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
	 <4F2AAEB9.9070302@tilera.com>
	 <CAOtvUMfE3xpwmRKnFPTsstr3SuUG7SnpWn5eomEQzkap4_nfrg@mail.gmail.com>
	 <1328899148.25989.38.camel@laptop>
	 <CAOtvUMfZ-sfTd-WTV=+RcerTk6ejC2mmjrMGg8KkdMR=RaV+CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 21:29:19 +0100
Message-ID: <1328905759.25989.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 22:13 +0200, Gilad Ben-Yossef wrote:
> My current understanding is that if I have a real time task and wish it
> have a deterministic performance time, you should call mlockall() to lock
> the program data and text into physical memory so that  a  less often taken
> branch or access to a new data region will not result in a page fault.
> 
> You still have to worry about TLB misses on non hardware page table
> walk architecture, but at least everything is in the  page tables
> 
> If there is a better way to do this? I'm always happy to learn new
> ways to do things. :-) 

A rt application usually consists of a lot of non-rt parts and a usually
relatively small rt part. Using mlockall() pins the entire application
into memory, which while on the safe side is very often entirely too
much.

The alternative method is to only mlock the text and data used by the rt
part. You need to be aware of what text runs in your rt part anyway,
since you need to make sure it is in fact deterministic code.

One of the ways of achieving this is using a special linker section for
your vetted rt code and mlock()'ing only that text section.

On thread creation, provide a custom allocated (and mlock()'ed) stack
etc..

Basically, if you can't tell a-priory what code is part of your rt part,
you don't have an rt part ;-)

