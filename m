Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1CQNfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:35:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30968 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1CQNfv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Mar 2011 09:35:51 -0400
Date: Thu, 17 Mar 2011 09:35:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/irq.fairness and
 stable/irq.ween_of_nr_irqs for 2.6.39
Message-ID: <20110317133532.GA6120@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D820E27.0042,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

This pull request is coming in a bit late b/c it utilizes a lot
of the functionality provided by "genirq: Make nr_irqs runtime expandable"
(e7bcecb7b1d29b9ad5af939149a945658620ca8f) 

It also brings in conflict that is easy to solve. I've put the merge
and the conflict resolution in the for-2.6.39/irq.phase.two branch to make
it easier to visualize (I rebased it on your latest master just to show the commit
fix - also Stephen's #linux-next carries a similar commit solution).

Please pull these two branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.fairness stable/irq.ween_of_nr_irqs

I tried doing it in one swoop and hit an extra commit error with
"static struct cpu_evtchn_s.." b/c that particular piece of code gets removed
by the stable/irq.ween_of_nr_irqs code.

If you do it with two git pulls it works out nicely with just one conflict.


Back to the description.

#stable/irq.fairness is based off stable/irq.cleanup (which you pulled on Monday)

.. which allows the event nr->IRQ dispatch code to go round-robin across the events.
Previously it would always start at zero causing starvation issues when there were lots
of guests running. With this patchset we go fairly across the full spectrum of events
and execute in a fair fashion the IRQ handlers that are tied in with the event channel.

#stable/irq.ween_of_nr_irqs is also based off stable/irq.cleanup

.. and it does a nice job of cleaning up the IRQ code further and collapsing a lot
functionality in common code. It also allows us now to grow dynamically
the IRQ limit by using Thomas's "genirq: Make nr_irqs runtime expandable"
functionality. Really neat!

The diffstat:

 arch/x86/pci/xen.c   |   41 ++++--
 drivers/xen/events.c |  439 ++++++++++++++++++++++++++++++--------------------
 include/xen/events.h |   24 ++--
 3 files changed, 300 insertions(+), 204 deletions(-)

And the full log:

Ian Campbell (16):
      xen: events: Make last processed event channel a per-cpu variable.
      xen: events: separate two unrelated halves of if condition
      xen: events: simplify comment
      xen: events: fix xen_map_pirq_gsi error return
      xen: events: remove unused public functions
      xen: events: rename restore_cpu_pirqs -> restore_pirqs
      xen: events: refactor GSI pirq bindings functions
      xen: events: use per-cpu variable for cpu_evtchn_mask
      xen: events: turn irq_info constructors into initialiser functions
      xen: events: push setup of irq<->{evtchn,ipi,virq,pirq} maps into irq_info init functions
      xen: events: maintain a list of Xen interrupts
      xen: events: dynamically allocate irq info structures
      xen: events: remove use of nr_irqs as upper bound on number of pirqs
      xen: events: do not workaround too-small nr_irqs
      xen: events: propagate irq allocation failure instead of panicking
      xen: events: correct locking in xen_irq_from_pirq

Keir Fraser (3):
      xen: events: Clean up round-robin evtchn scan.
      xen: events: Make round-robin scan fairer by snapshotting each l2 word once only
      xen: events: Remove redundant clear of l2i at end of round-robin loop

Konrad Rzeszutek Wilk (1):
      xen: events: Fix compile error if CONFIG_SMP is not defined.

Scott Rixner (1):
      xen: events: Process event channels notifications in round-robin order.

