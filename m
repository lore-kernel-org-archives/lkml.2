Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3ACW1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:27:06 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:43550 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3ACW1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:27:03 -0500
Message-ID: <1357252019.2685.45.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 3 Jan 2013 22:26:59 +0000
In-Reply-To: <20130103134749.1d01bc2e.akpm@linux-foundation.org>
References: <cover.1357163124.git.decot@googlers.com>
	 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
	 <20130102151242.fc6f1bee.akpm@linux-foundation.org>
	 <CAG88wWYuxY7Gi6tuBsv_tY2QqGmQgB-zER9pzpZga7uV21HorA@mail.gmail.com>
	 <20130103134749.1d01bc2e.akpm@linux-foundation.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.005
X-TM-AS-Result: No--29.811700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 13:47 -0800, Andrew Morton wrote:
> On Wed, 2 Jan 2013 18:35:00 -0800
> David Decotigny <decot@googlers.com> wrote:
> >
> 
> (please don't top-post)
> 
> > Thanks. It is not too late to review this code. But I'd prefer not to
> > address refactoring issues with this patch, which is supposed to fix a
> > deadlock with some drivers. So I'd rather not to add function
> > renaming, suppressions, etc. that have an effect outside cpu_rmap's
> > code. Instead, I'd like to propose another patch later, which will be
> > a little more intrusive in that respect, if that's ok with you.
> > 
> > I believe Ben answered your other concerns, I consider him as the
> > expert as to whether there should be finer-grained locking implemented
> > in this subsystem. Let me just add that I second him in saying that
> > the deadlock risk was clearly identified and mentioned in the doc.
> > Unfortunately, initial implementation makes this risk hard to
> > work-around for some drivers, which is what this patch proposes to
> > address.
> 
> ^^ all this pertains to the existing code.
> 
> > So, for now, I'd like to keep v4 as the current version. And some
> > refactoring will be done in a later patch.
> 
> ^^ this pertains to the current patch.  And no reason for ignoring my
> review comments was provided.
> 
> So I did it myself.  It's very simple, as free_cpu_rmap() has no callers.
> 
> Also, free_irq_cpu_rmap() is now distinctly fishy - it runs all the
> notifiers every time it is called.

It removes the notifiers.

> Surely it should only do that when the refcount falls to zero?
[...]

No, absolutely not.  An IRQ cpu_rmap may have multiple references to it
now, but it only has one owner: the driver that allocates it and the
associated IRQs.

As soon as the driver frees those IRQs, they may be allocated by some
other driver, so we require that notifiers are removed from them first
(see the WARN_ON in free_irq()).  Also, if free_irq_cpu_rmap() did not
remove the notifiers, more notifications could be scheduled and keep the
cpu_rmap alive indefinitely.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

