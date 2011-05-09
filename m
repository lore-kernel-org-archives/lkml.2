Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1EIOp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:45:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54323 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab1EIOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:45:55 -0400
X-Sasl-enc: BoM9Km+sgWI/ODEe22qUnw6uHb+6pHC7nVFV6X+hiy8e 1304952354
Date: Mon, 9 May 2011 11:45:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110509144546.GB13275@khazad-dum.debian.net>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 May 2011, Andrew Lutomirski wrote:
> I've figured out how the ThinkPad SMAPI charge control works (at least
> well enough to program thresholds on some models), and I'd like to get

Yeah, there's a little protocol to talk to the EC, otherwise it simply
ignores writes to the battery threshold registers.  I think you had to set
bit 7 before you write the threshold to the relevant EC register, or
something.  Found it by trial-and-error a long time ago, I documented it
somewhere but never took it forward.  I never bothered to hunt down the
force-drain/battery-select commands, though.

Anyway, since SMAPI works, and is *stable* (the fact that it works from the
A21 to the latest Lenovos tells you just how stable), which is a lot more
than what I can say about the ACPI stuff, I didn't see any reason to mess
with this.

> Currently, I have a little driver (not yet in mergeable shape) that
> creates a platform device and sticks some sysfs attributes in it
> depending on which thresholds it can figure out how to program.  It's
> here:
> 
> https://gitorious.org/linux-test-utils/tp_charge/blobs/master/kmod/tp_charge.c

I apologise, but I will not read that code until it is clear I need not be
available for any possible clean-room attempts.

> 2. Integrate it with power_supply.

Only if we can make it generic enough, but yes, THIS is the better way.

However, I'd prefer if you went all the way and actually hooked to the SBS
subsystem and exposed all the battery information.  There is a way to do
that through the ACPI DSDT (but you will have to do the rev. engineering
yourself, as I said, smapi works just fine across so many models, that I
never bothered with it -- it is far better supported than ACPI).

It is not even difficult, just look at the methods used to expose the
standard ACPI battery interface, then read the Smart Battery System (SBS)
standard, and you will find out by fast trial-and-error how to map one to
the other.  Or you can look at tp_smapi to speed things up (only, tp_smapi
talks directly to the EC instead of doing it over ACPI).

The SBS interface exposes more data about the battery, including
per-cell-group voltage and pack microcontroller aging counters, alarms, and
the "needs to get through the fuel-gaugue reset procedure" semasphore.

> then other laptops and devices could reuse the same interface.  The
> problem is that the ACPI battery driver can't see the charge control.
> So either it would need a hook to allow per-vendor control like this
> or the power_supply class would need to recognize separate charge
> controllers.
> 
> I have no intention of creating a kitchen sink like tp_smapi.  But I
> might want to add things like forced discharge or outright disabling
> of charging.  On possible added complication: on ThinkPads, the charge
> thresholds stay in effect until reprogrammed or until the battery is
> removed, even if the computer is off.

This is not a complication.  You must never assume you are the one in charge
of the ThinkPad firmware (you're not, it does its own thing).  You can
respectfully ask it to do something else, but you have to keep an eye on it,
because it might change its mind as soon as an external event is detected.

If the kernel power_supply subsystem cannot work that way, you will have to
fix that limitation first.  You need to read the thresholds when you need
that information, etc.

The SBS parameters stay in effect until the EC is power-cycled.  IBMs will
shut it down when turned off if the AC feed is removed.  Lenovos will only
shut it down when there is no power at all (i.e. no AC feed, and no SBS
batteries connected to the box).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
