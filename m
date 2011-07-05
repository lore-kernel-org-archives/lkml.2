Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1GEF56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:57:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36556 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1GEF55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110704171634.GD28726@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
	<1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
	<20110630052808.GA796@opensource.wolfsonmicro.com>
	<BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
	<20110630055719.GA930@opensource.wolfsonmicro.com>
	<BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
	<20110630155634.GE3249@opensource.wolfsonmicro.com>
	<BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
	<20110704171634.GD28726@opensource.wolfsonmicro.com>
Date: Tue, 5 Jul 2011 14:57:54 +0900
Message-ID: <CAJ0PZbST6Xp82HTxpspiSEbjPmSzUuiKaHsycUKfyBFPQsSA_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Jul 5, 2011 at 2:16 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jul 01, 2011 at 09:43:31AM +0900, MyungJoo Ham wrote:
>> On Fri, Jul 1, 2011 at 12:56 AM, Mark Brown
>
>> > This looks like charger specific configuration which should be done by
>> > the charger driver rather than by directly working with the IRQs?
>
>> Well, the issue is that the charger driver just does not know what to
>> do with its own interrupts.
>
>> For example, each board has different regulator setting for DCIN
>> depending on the specification of the board (some uses 450mA
>> constantly, some uses 450mA and 700mA depending on the connection
>> information, which is not known to charger driver, some uses 900mA
>> unconditionally, and so on).
>
> That sounds like the charger driver just needs some platform data.

Right. And, that platform data includes IRQs: in this case, the IRQs
of MAX8997, which have charger and USB connection information.
MAX8997's IRQ handlers need to notify the charger driver and the
charger driver may use other PMIC, USB switch (such as FSA9480), and
any devices with external power connections.

>
>> Sometimes setting the attributes of a charger at its own interrupts
>> depends on the status of another charger; when we have USB charger,
>> wireless charger, and solar panels, which may be enabled independently
>> and have their own device drivers.
>
> My understanding was that one of the goals of the power_supply subsystem
> was to support this sort of interaction? This (and your subsequent
> paragraphs) all sounds entirely sensible but it should be being dealt
> with at a higher level with the various charger drivers delivering
> events into a subsystem or board driver which coordinates them all.  It
> seems like the driver should be doing the work of dealing with the
> actual interrupts.
>

Yes, I also think that it is supposed to read and update attributes of
chargers. However, I don't see any ways to interconnect chargers and
related devices with power_supply subsystem.

If we let a user process interconnect the chargers and related
devices, we need to allow userland to access (both read and write)
related attributes including power_supply_class entries and regulators
(charger on/off and adjusting charger speed). But, we don't support
userland r/w access to regulators. Also, I feel a bit wierd to rely on
user programs for specifying hardware dependencies between on-board
chips (e.g., setting charger limit at 450mA if USB is attached, at
900mA if TA is attached, at 1.5A if high-speed TA is attached, or at
300mA if wireless charger is attached / disable charger B if charger A
started CV charging, ...).

Besides, we want charger control/monitoring while user tasks are
frozen, which was the reason why we have been working on
"suspend_again" callback for suspend:
http://us.generation-nt.com/answer/patch-v5-pm-core-suspend-again-callback-suspend-ops-help-203628722.html
. For this, we will need in-kernel code (but out of max8997 device
driver code) to have information about the IRQs of max8997 (or any
other similar chips).

Anyway, even if we are going to implement charger control/monitoring
service in userspace directly accessing the device drivers of PMIC,
chargers, and switches, those user programs need to access IRQ (need
to get notifications from the interrupts). Isn't including
"non-private" kernel headers more preferable for user programs than
including "private" kernel headers or hard coding IRQ numbers, is it?



Thank you.


Cheers!
- MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
