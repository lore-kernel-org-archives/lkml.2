Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3ACRzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:55:36 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40155 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3ACRyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:54:50 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Beulich <JBeulich@suse.com>, Rik van Riel <riel@redhat.com>,
        therbert@google.com, walken@google.com, jeremy@goop.org,
        tglx@linutronix.de, aquini@redhat.com, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1357231525.10284.58.camel@gandalf.local.home>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>
	 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
	 <1356618448.30414.948.camel@edumazet-glaptop> <50DC5CC0.6010003@redhat.com>
	 <50DC9662020000780009210D@nat28.tlf.novell.com>
	 <50DC9CE1.9030709@redhat.com>
	 <50E5580102000078000B29D1@nat28.tlf.novell.com>
	 <1357219477.10284.23.camel@gandalf.local.home>
	 <1357220117.21409.24539.camel@edumazet-glaptop>
	 <1357227169.10284.32.camel@gandalf.local.home>
	 <1357229439.21409.25042.camel@edumazet-glaptop>
	 <1357231525.10284.58.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 09:54:46 -0800
Message-ID: <1357235686.21409.25360.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 11:45 -0500, Steven Rostedt wrote:
> On Thu, 2013-01-03 at 08:10 -0800, Eric Dumazet wrote:
> 
> > > But then would the problem even exist? If the lock is on its own cache
> > > line, it shouldn't cause a performance issue if other CPUs are spinning
> > > on it. Would it?
> > 
> > Not sure I understand the question.
> > 
> 
> I'll explain my question better.
> 
> I thought the whole point of Rik's patches was to solve a performance
> problem caused by contention on a lock that shares a cache line with
> data.
> 
> In the ideal case, locks wont be contented, and are taken and released
> quickly (being from the RT world, I know this isn't true :-( ). In this
> case, it's also advantageous to keep the lock on the same cache line as
> the data that's being updated. This way, the process of grabbing the
> lock also pulls in the data that you will soon be using.
> 
> But then the problem occurs when you have a bunch of other CPUs trying
> to take this lock in a tight spin. Every time the owner of the lock
> touches the data, the other CPUs doing a LOCK read on the spinlock will
> cause bus contention on the owner CPU as the data shares the cache and
> needs to be synced. As the owner CPU just touched the cache line that is
> under a tight loop of LOCK reads on other CPUs. By adding the delays,
> the CPU with the lock doesn't stall at every update of the data
> protected by the lock.
> 
> Thus, if monitor/mwait is ideal only for locks on its own cache line,
> then they are pointless for the locks that are causing the issue we are
> trying to fix.

I think you misunderstood the monitor/mwait usage I was speaking of

- Only for MCS type lock, where each cpu spins on it own busy/locked
bit.

Of course, if we use a ticket spinlock with no additional storage, we
have to spin without making any memory reference, and thats Rick's patch
using this idea : 

http://www.cs.rochester.edu/research/synchronization/pseudocode/ss.html#ticket



