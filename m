Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1ARQ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:27:50 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36812 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1ARQ1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:27:49 -0500
Date: Tue, 18 Jan 2011 21:57:18 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>, suzuki@in.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 09/12] xen/pvticketlock: Xen implementation for PV
 ticket locks
Message-ID: <20110118162717.GA18234@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <32e63cc978ec4b3f36c7f641ce48b3d86aed22ed.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <20100926113910.GA6719@linux.vnet.ibm.com>
 <4C9FCA8F.4070802@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9FCA8F.4070802@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:34:55PM -0700, Jeremy Fitzhardinge wrote:
>  On 09/26/2010 04:39 AM, Srivatsa Vaddagiri wrote:
> > On Fri, Jul 16, 2010 at 06:03:04PM -0700, Jeremy Fitzhardinge wrote:
> >> Replace the old Xen implementation of PV spinlocks with and implementation
> >> of xen_lock_spinning and xen_unlock_kick.
> > I see that the old implementation took care of a spinlock() call being
> > interrupted by another spinlock (in interrupt handler), by saving/restoring 
> > old lock of interest. We don't seem to be doing that in this new version?
> > Won't that lead to loss of wakeup -> hang?

Sorry about coming back late on this, but as I was looking at the most recent
version of pv-ticketlocks, this came up in my mind again ..

> No, interrupts are disabled while waiting to take the lock, so it isn't
> possible for an interrupt to come in.

Where are we disabling interrupts? Is it in xen_poll_irq()?

>  With the old-style locks it was
> reasonable to leave interrupts enabled while spinning, but with ticket
> locks it isn't.
> 
> (I haven some prototype patches to implement nested spinning of ticket
> locks,

Hmm ..where is nested spinning allowed/possible? Process context will
disable interrupts/bh from wanting the same (spin-)lock it is trying to
acquire?

> by allowing the nested taker to steal the queue position of the
> outer lock-taker, and switch its ticket with a later one.  But there's a
> fundamental problem with the idea: each lock taker needs to take a
> ticket.  If you don't allow nesting, then the max amount of tickets
> needed = number of cpus-1; however, with nesting, the max number of
> tickets = ncpus * max-nesting-depth, so the size of the ticket type must
> be larger for a given number of cpus, or the max number of cpus must be
> reduced.)

- vatsa
