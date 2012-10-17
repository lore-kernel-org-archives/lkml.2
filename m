Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2JQWoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:44:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33618 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2JQWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:44:36 -0400
Date: Wed, 17 Oct 2012 15:44:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121017224430.GC2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121015190958.GA4799@redhat.com>
 <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017165902.GB9872@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101722-2876-0000-0000-0000012095A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 06:59:02PM +0200, Oleg Nesterov wrote:
> On 10/16, Linus Torvalds wrote:
> >
> > On Mon, Oct 15, 2012 at 12:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > This patch adds the new sleeping lock, brw_mutex. Unlike rw_semaphore
> > > it allows multiple writers too, just "read" and "write" are mutually
> > > exclusive.
> >
> > So those semantics just don't sound sane. It's also not what any kind
> > of normal "rw" lock ever does.
> 
> Yes, this is not usual.
> 
> And initially I made brw_sem which allows only 1 writer, but then
> I changed this patch.
> 
> > So can you explain why these particular insane semantics are useful,
> > and what for?
> 
> To allow multiple uprobe_register/unregister at the same time. Mostly
> to not add the "regression", currently this is possible.
> 
> It is not that I think this is terribly important, but still. And
> personally I think that "multiple writers" is not necessarily insane
> in general. Suppose you have the complex object/subsystem, the readers
> can use a single brw_mutex to access it "lockless", start_read() is
> very cheap.
> 
> But start_write() is slow. Multiple writes can use the fine-grained
> inside the start_write/end_write section and do not block each other.

Strangely enough, the old VAXCluster locking primitives allowed this
sort of thing.  The brw_start_read() would be a "protected read", and
brw_start_write() would be a "concurrent write".  Even more interesting,
they gave the same advice you give -- concurrent writes should use
fine-grained locking to protect the actual accesses.

It seems like it should be possible to come up with better names,
but I cannot think of any at the moment.

							Thanx, Paul

PS.  For the sufficiently masochistic, here is the exclusion table
     for the six VAXCluster locking modes:

		NL	CR	CW	PR	PW	EX
	NL
	CR						X
	CW				X	X	X
	PR			X		X	X
	PW			X	X	X	X
	EX		X	X	X	X	X

	"X" means that the pair of modes exclude each other,
	otherwise the lock may be held in both of the modes
	simultaneously.


Modes:

NL:	Null, or "not held".
CR:	Concurrent read.
CW:	Concurrent write.
PR:	Protected read.
PW:	Protected write.
EX:	Exclusive.


A reader-writer lock could use protected read for readers and either of
protected write or exclusive for writers, the difference between protected
write and exclusive being irrelevant in the absence of concurrent readers.

