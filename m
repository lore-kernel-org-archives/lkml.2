Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2EGViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:38:46 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:57238 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2EGVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:38:44 -0400
Date: Mon, 7 May 2012 14:38:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
In-Reply-To: <20120507185017.GA21152@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.00.1205071421130.1920@eggly.anvils>
References: <20120501142208.GA2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205011410360.28232@eggly.anvils> <20120501232516.GR2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205021324430.24246@eggly.anvils> <1335993615.4088.1.camel@pasglop> <20120502215406.GL2450@linux.vnet.ibm.com>
 <CANsGZ6bw4JwMRgUriooDvFB=g-HkpyL8XJa9s47RPfOEPCMcpw@mail.gmail.com> <20120503001433.GO2450@linux.vnet.ibm.com> <alpine.LSU.2.00.1205021721350.24869@eggly.anvils> <alpine.LSU.2.00.1205070858450.1416@eggly.anvils>
 <20120507185017.GA21152@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Paul E. McKenney wrote:
> On Mon, May 07, 2012 at 09:21:54AM -0700, Hugh Dickins wrote:
> > 
> > In 70 hours I got six isolated messages like the below (but from
> > different __might_sleep callsites) - where before I'd have flurries
> > of hundreds(?) and freeze within the hour.
> > 
> > And the "rcu_nesting" debug line I'd added to the message was different:
> > where before it was showing ffffffff on some tasks and 1 on others i.e.
> > increment or decrement had been applied to the wrong task, these messages
> > now all showed 0s throughout i.e. by the time the message was printed,
> > there was no longer any justification for the message.
> > 
> > As if a memory barrier were missing somewhere, perhaps.
> 
> These fields should be updated only by the corresponding CPU, so
> if memory barriers are needed, it seems to me that the cross-CPU
> access is the bug, not the lack of a memory barrier.

Yes: the code you added appeared to be using local CPU accesses only
(very much intentionally), and the context switch should already have
provided all the memory barriers needed there.

> 
> Ah...  Is preemption disabled across the access to RCU's nesting level
> when printing out the message?  If not, a preeemption at that point
> could result in the value printed being inaccurate.

Preemption was enabled in the cases I saw.  So you're pointing out that
#define rcu_preempt_depth() (__this_cpu_read(rcu_read_lock_nesting))
should have been
#define rcu_preempt_depth() (this_cpu_read(rcu_read_lock_nesting))
to avoid the danger of spurious __might_sleep() warnings.

Yes, I believe you've got it - thanks.

Hugh
