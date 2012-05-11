Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab2EKSyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:54:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab2EKSye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:54:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
Date: Fri, 11 May 2012 20:59:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
References: <201205092340.26561.rjw@sisk.pl> <201205102041.42473.rjw@sisk.pl> <4FACCC79.5000805@ti.com>
In-Reply-To: <4FACCC79.5000805@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205112059.25233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 11, 2012, Santosh Shilimkar wrote:
> On Friday 11 May 2012 12:11 AM, Rafael J. Wysocki wrote:
> > On Thursday, May 10, 2012, Santosh Shilimkar wrote:
> >> Rafael,
> >>
> >> On Thursday 10 May 2012 03:13 AM, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>
> >>> On some systems there are CPU cores located in the same power
> >>> domains as I/O devices.  Then, power can only be removed from the
> >>> domain if all I/O devices in it are not in use and the CPU core
> >>> is idle.  Add preliminary support for that to the generic PM domains
> >>> framework.
> >>>
> >> I am just curious to know, what kind of IO devices, you are
> >> talking here?
> > 
> > Nothing specific, really.  It can be any kind of I/O devices that happen
> > to be in the same power domain.  This includes USB, SDHI, MMCIF controllers
> > on the SoC I have in mind in particular.
> > 
> OK.
> These are more of generic devices and actually not related to CPU/CPU
> clusters as such.
> 
> >> And also how those devices linked with CPU low power
> >> states apart from being part of same power domain. And is it
> >> the power domain or more of voltage domain, we are talking here.
> > 
> > Depending on the definitions I guess.  How do you define a power domain and
> > a voltage domain?
> >
> 
> A voltage domain can be a section of the device supplied by a dedicated
> voltage rail. A voltage domain can have many power-domains like
> CPU cluster domain, Interconnect domain, peripheral domains.
> And each power domain then can have many sub-modules like UART, SPI,
> USB etc

OK, so this is not the level of detail the code in question is about.

In my terminology a power domain is a set of devices such that it only is
possible to remove power from (and restore power to) all of them together.

[...]
> > 
> > The system I have in mind is designed in such a way that there is a power
> > domain with three subdomains, one of which contains the CPU core and the
> > remaining two contain I/O devices of various kinds.  General purpose as well
> > as "core".
> > 
> I am not sure CPUIDLE is suppose to take care of these kind of general
> purpose IO's. CPUIDLE should take care of CPU and CPU cluster power
> management. Any other peripherals as you mentioned should be already
> have some sort of device drivers and they should be using runtime PM for
> it, no?

Yes.

> And for the constraints, PM-Qos can be used. So far CPUIDLE
> core code has maintained that distinction and all the C-state latencies
> are of the CPU clusters rather than the SOC.

Well, that need not be the case and my patch is about that.

> If you have a voltage rail dependency then that should be handled
> in the voltage layer/regulator layer. If there is a power domain
> dependency then the power domain framework should do the use
> counting yo handle such scenarios.

The power domain framework, though, only covers I/O devices at the moment
and this is an attempt to extend it to cover domains containing CPU cores
as well as I/O devices.

> Please correct me but, IIUC, your proposal wants to use CPUIDLE
> for the SOC level power management.

That depends on what you mean by SoC-level.

> Will you be able to expand your requirements and explain why can't
> you manage PM for the general purpose devices like MMC, USB etc
> in their own device drivers ?

Because it is not possible to remove power from those devices individually.

Say you have a bunch of I/O devices such that you can only remove power from
all of them simultaneously (a power domain, that is).  Suppose that there
is a register such that if a specific value is written to it, power is cut
from all of those devices at the same time (and there's an analogous value
for restoring power).  Then, you can use the generic PM domains framework
for power management of those devices.

Suppose, however, that if you write the "cut power" value to the register,
your CPU core will lose power too.  This case is beyond the scope of the
existing generic PM domains framework, because it has to take the CPU power
management into account, which is cpuidle in this particular case.

Thanks,
Rafael
