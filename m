Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1AUKLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:11:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1AUKLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jeygePyyfpTf3sKBJrbuIlh4rbwS1xz8bS4/jBXJbnI0zANudhBfRErYMa6xluMFQ+
         ocZmZ+3wvKPTey6kW3A4aJZ3wHD9uIUw5KNHjCybwHIB9bk448TDCSJPWIlfDZ75L6FU
         XLpjXzfIpy1r+9VZEzFBg+9Z26x9DayLxQIiU=
MIME-Version: 1.0
In-Reply-To: <20110121093940.GC13235@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111091607.GI12552@n2100.arm.linux.org.uk>
	<201101111744.59712.jeremy.kerr@canonical.com>
	<20110111103929.GN24920@pengutronix.de>
	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
	<4D386ABF.9060908@fluff.org>
	<20110120190822.GK6335@n2100.arm.linux.org.uk>
	<AANLkTim5N_sCCoOR40y7sTvdDoFkUJd4tUSSbrCccGjy@mail.gmail.com>
	<AANLkTikJjkJvr2J-9eq2-Jj8L=JvwUQS+QNj9gWFX-TL@mail.gmail.com>
	<20110121093940.GC13235@n2100.arm.linux.org.uk>
Date: Fri, 21 Jan 2011 19:11:48 +0900
Message-ID: <AANLkTimrZGd80+L-X3d9tZDHg4n_ajv8tv55pLFx_kRC@mail.gmail.com>
Subject: Re: Locking in the clk API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 6:39 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jan 21, 2011 at 01:47:29PM +0900, Jassi Brar wrote:
>> On Fri, Jan 21, 2011 at 9:09 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> > On Fri, Jan 21, 2011 at 4:08 AM, Russell King - ARM Linux
>> > <linux@arm.linux.org.uk> wrote:
>> >> On Thu, Jan 20, 2011 at 05:02:55PM +0000, Ben Dooks wrote:
>> >>> If you want to make it so that each low-power mode has to work
>> >>> out what PLLs need to be disabled and then re-enabled makes me
>> >>> want to be sick. Hiding this stuff behind specific implementations
>> >>> is a recipe for disaster.
>> >>
>> >> Why should systems which don't suffer from such problems be prevented
>> >> from gaining power saving from turning off their clocks when devices
>> >> are not being used (eg, the console serial port.)
>> >>
>> >> One solution to your root PLL issue would be to have a separate set of
>> >> enable/disable API calls which get called at setup/release time (or
>> >> whatever you'd like to call it) which can only be called from non-atomic
>> >> context.  Maybe clk_prepare() and clk_unprepare().  These functions
>> >> should perform whatever is necessary to ensure that the clock source
>> >> is available for use atomically when clk_enable() is called.
>> >>
>> >> So, in your case, clk_prepare() ensures that the root PLL is enabled,
>> >> clk_unprepare() allows it to be turned off.
>> >>
>> >> In the case of a console driver, clk_prepare() can be called when we
>> >> know the port will be used as a console.  clk_enable() is then called
>> >> before writing out the string, and clk_disable() after we've completely
>> >> sent the last character.
>> >>
>> >> This allows the best of both worlds.  We now have a clk_enable() which
>> >> can be used to turn the clocks off through the clock tree up to the first
>> >> non-atomic clock, and we also have a way to deal with those which need
>> >> to sleep.  So not only do "sleeping clock" implementations become possible
>> >> but these "sleeping clock" implementations also get the opportunity to
>> >> shutdown some of their clock tree with minimal latency for doing so.
>> >
>> > This is exactly what I suggested in my last post, except the console example.
>> > Only to be a part of common clock api because it's not very safe to assume
>> > future SoCs will have the same simple clock topologies that they have today.
>> >
>> > Not to mean to teach, but I hope you realize with more and more
>> > device controller being crammed into ever shrinking SoCs,
>> > clock would eventually have to be flexible in functionality
>> > and complicated in hierarchy. Ben already gave examples
>> > of Audio, MFC and Video controllers of latest Samsung SoCs.
>>
>> plus
>>
>> a) If only Samsung bsp implements the api, it would be impossible to
>> share drivers, those that can be, with other platforms without nasty ifdef's.
>> b) If the task of unification starts with only a particular platform made to
>> implement a new api, the attempt kills its own purpose.
>
> I guess we give up with the idea of unifying the API then, because it is
> proving to be impossible to come to any kind of concensus.  Even ideas
> to solve the points of contention are argued against.
>
> I see no one else coming up with any practical ideas how to resolve this,
> but what I do see is that attempts to provide a solution to allow progress
> towards a unified API are shot down with great vigour.
>
> So from what I can see it's a complete waste of time discussing this any
> further.
>
> Unified clock API?  It'll *never* happen.

Why can't we have that new function, clk_setup or whatever, a part of new API?
For now, it'll just be a place holder whit NULL as platform specific hooks.
Eventually platforms like Samsung will have that filled and others
keep that empty.
Only let it be defined for drivers to always call clk_setup at probe
and clk_enable when
needed.
Or am I overlooking something?
