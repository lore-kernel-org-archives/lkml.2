Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1AVEIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 23:08:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60371 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1AVEIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 23:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NOSEYnHYbLkOxRbPOR/zyfjGnRqmU9k0dLZB5ZDoSoDfPbPzNonWVjv0uFtqzvbY/W
         aOpPd+U2+YhZJqL3UGJIuXbEuOGVycXVwn7dv0iFYEEYbhLnLj4Jgt7+6anIh4eIg9QJ
         EDZBA4KtZa3mtkO6NF75Lpuel2viqd1qt92jI=
Date: Sat, 22 Jan 2011 12:08:00 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: Locking in the clk API
Message-ID: <20110122040757.GA2094@richard-laptop>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <20110111091607.GI12552@n2100.arm.linux.org.uk>
 <201101111744.59712.jeremy.kerr@canonical.com>
 <20110111103929.GN24920@pengutronix.de>
 <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
 <4D386ABF.9060908@fluff.org>
 <20110120190822.GK6335@n2100.arm.linux.org.uk>
 <AANLkTim5N_sCCoOR40y7sTvdDoFkUJd4tUSSbrCccGjy@mail.gmail.com>
 <AANLkTikJjkJvr2J-9eq2-Jj8L=JvwUQS+QNj9gWFX-TL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikJjkJvr2J-9eq2-Jj8L=JvwUQS+QNj9gWFX-TL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 01:47:29PM +0900, Jassi Brar wrote:
> On Fri, Jan 21, 2011 at 9:09 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> > On Fri, Jan 21, 2011 at 4:08 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> >> On Thu, Jan 20, 2011 at 05:02:55PM +0000, Ben Dooks wrote:
> >>> If you want to make it so that each low-power mode has to work
> >>> out what PLLs need to be disabled and then re-enabled makes me
> >>> want to be sick. Hiding this stuff behind specific implementations
> >>> is a recipe for disaster.
> >>
> >> Why should systems which don't suffer from such problems be prevented
> >> from gaining power saving from turning off their clocks when devices
> >> are not being used (eg, the console serial port.)
> >>
> >> One solution to your root PLL issue would be to have a separate set of
> >> enable/disable API calls which get called at setup/release time (or
> >> whatever you'd like to call it) which can only be called from non-atomic
> >> context.  Maybe clk_prepare() and clk_unprepare().  These functions
> >> should perform whatever is necessary to ensure that the clock source
> >> is available for use atomically when clk_enable() is called.
> >>
> >> So, in your case, clk_prepare() ensures that the root PLL is enabled,
> >> clk_unprepare() allows it to be turned off.
> >>
> >> In the case of a console driver, clk_prepare() can be called when we
> >> know the port will be used as a console.  clk_enable() is then called
> >> before writing out the string, and clk_disable() after we've completely
> >> sent the last character.
> >>
> >> This allows the best of both worlds.  We now have a clk_enable() which
> >> can be used to turn the clocks off through the clock tree up to the first
> >> non-atomic clock, and we also have a way to deal with those which need
> >> to sleep.  So not only do "sleeping clock" implementations become possible
> >> but these "sleeping clock" implementations also get the opportunity to
> >> shutdown some of their clock tree with minimal latency for doing so.
> >
> > This is exactly what I suggested in my last post, except the console example.
> > Only to be a part of common clock api because it's not very safe to assume
> > future SoCs will have the same simple clock topologies that they have today.
> >
> > Not to mean to teach, but I hope you realize with more and more
> > device controller being crammed into ever shrinking SoCs,
> > clock would eventually have to be flexible in functionality
> > and complicated in hierarchy. Ben already gave examples
> > of Audio, MFC and Video controllers of latest Samsung SoCs.
> 
> plus
> 
> a) If only Samsung bsp implements the api, it would be impossible to
> share drivers, those that can be, with other platforms without nasty ifdef's.
> b) If the task of unification starts with only a particular platform made to
> implement a new api, the attempt kills its own purpose.
I'm not clear. Why does Samsung SoC go against clk_prepare/unprepare?
If its clock tree has many plls and device clock is not far away from plls and
may sleep, we may use prepare/unprepare to do actually clock enable/disable.

Thanks
Richard
