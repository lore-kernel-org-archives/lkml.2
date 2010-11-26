Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0KZKqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:46:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40778 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0KZKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:46:24 -0500
Date: Fri, 26 Nov 2010 10:45:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Olof Johansson <olof@lixom.net>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101126104548.GG9310@n2100.arm.linux.org.uk>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net> <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com> <20101126091832.GE9310@n2100.arm.linux.org.uk> <AANLkTimS-cSi1B5LdtwhJWhKDuFKOYG1j_p-iQiH=zRe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimS-cSi1B5LdtwhJWhKDuFKOYG1j_p-iQiH=zRe@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 12:16:39PM +0200, Ohad Ben-Cohen wrote:
> On Fri, Nov 26, 2010 at 11:18 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Nov 26, 2010 at 10:53:10AM +0200, Ohad Ben-Cohen wrote:
> >> >> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
> >> >> +{
> >> >> +     int ret;
> >> >> +
> >> >> +     if (unlikely(!hwlock)) {
> >> >> +             pr_err("invalid hwlock\n");
> >> >
> >> > These kind of errors can get very spammy for buggy drivers.
> >>
> >> Yeah, but that's the purpose - I want to catch such egregious drivers
> >> who try to crash the kernel.
> >
> > That can be better - because you get a backtrace, and it causes people
> > to report the problem rather than just ignore it.  It may also prevent
> > the driver author releasing his code (as it won't work on their
> > initial testing.)
> >
> ...
> >
> > If it's "extremely buggy behaviour" then the drivers deserve to crash.
> > Such stuff should cause them not to get out the door.  A simple printk
> > with an error return can just be ignored.
> 
> I like this approach too, but recently we had a few privilege
> escalation exploits which involved NULL dereference kernel bugs
> (process context mapped address 0 despite a positive mmap_min_addr).

That's not a concern on ARM.  The prevention of having a user page mapped
at virtual address 0 does not rely on mmap_min_addr - in fact, we can't
use this as it's tuneable to enforce this requirement.

It's highly illegal on ARM - as ARM CPUs without vector remap place the
hardware vectors at virtual address 0, and as such allowing the user to
map a page there will take the system down.  So we have this code in the
mmap path:

#define arch_mmap_check(addr, len, flags) \
        (((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)

which prevents any attempt what so ever, irrespective of the mmap_min_addr
setting, to create a userspace induced mapping at address 0.
