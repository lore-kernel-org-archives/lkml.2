Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1HHRT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:19:56 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:36952 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1HHRTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:19:55 -0400
Date: Mon, 8 Aug 2011 19:19:31 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Chris Wright <chrisw@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110808171931.GB867@local>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805001507.GA5987@local>
 <20110808062431.GB5182@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808062431.GB5182@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 09:24:31AM +0300, Michael S. Tsirkin wrote:
> On Fri, Aug 05, 2011 at 02:15:07AM +0200, Hans J. Koch wrote:
> > On Fri, Aug 05, 2011 at 12:04:13AM +0300, Michael S. Tsirkin wrote:
> > > On Thu, Aug 04, 2011 at 10:46:06PM +0200, Sebastian Andrzej Siewior wrote:
> > > > As reported by Anthony in a short way:
> > > > 
> > > > |irq 17 handler uio_interrupt+0x0/0x68 enabled interrupts
> > > > |NIP [c0069d84] handle_irq_event_percpu+0x260/0x26c
> > > > 
> > > > The problem here is that spin_unlock_irq() enables the interrupts which
> > > > is a no-no in interrupt context because they always run with interrupts
> > > > disabled. This is the case even if IRQF_DISABLED has not been specified
> > > > since v2.6.35. Therefore this patch uses simple spin_locks().
> > > > 
> > > > Looking at it further here is only one spot where the lock is hold. So
> > > > giving the fact that an ISR is not reentrant and is not executed on two
> > > > cpus at the same time why do we need a lock here?
> > > 
> > > I'm not sure anymore. I think the idea was to use
> > > it for synchronization down the road somehow,
> > > but it never materialized. Let's drop that lock completely.
> > 
> > That sounds reasonable.

Should I hack up a patch to remove the lock, or do you have anything in your
pipeline?

> > 
> > > 
> > > > The driver lacks of ->irqcontrol function so I guess the interrupt is
> > > > enabled via direct PCI-access in userland.
> > > 
> > > Through sysfs.
> > 
> > How? With /sys/devices/pci.../enable ?
> > 
> > Thanks,
> > Hans
> 
> No. By writing to the command register using
> /sys/bus/pci/devices/.../config

Hope that works at all times...
Anyway, the spin_lock in uio_pci_generic.c definetly doesn't help.

Thanks,
Hans
