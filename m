Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1AUEre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:47:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1AUErc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:47:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oLcmw4M+ibrO1liTj+2AZRrcdcMAPI0ZpjzsCkbhzXBhghC85X37X2P47taNkCPL+q
         /TCF3Jz2f9EjOfDpGKCIIC3iFJPHoET2fSGkheSV0Me5wbdrUr6euNh5LF+eUXZXbm0Q
         UCGLzhF4gl9eQsyao9jX92TVcWMAWFCGiBqCE=
MIME-Version: 1.0
In-Reply-To: <AANLkTim5N_sCCoOR40y7sTvdDoFkUJd4tUSSbrCccGjy@mail.gmail.com>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111091607.GI12552@n2100.arm.linux.org.uk>
	<201101111744.59712.jeremy.kerr@canonical.com>
	<20110111103929.GN24920@pengutronix.de>
	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>
	<4D386ABF.9060908@fluff.org>
	<20110120190822.GK6335@n2100.arm.linux.org.uk>
	<AANLkTim5N_sCCoOR40y7sTvdDoFkUJd4tUSSbrCccGjy@mail.gmail.com>
Date: Fri, 21 Jan 2011 13:47:29 +0900
Message-ID: <AANLkTikJjkJvr2J-9eq2-Jj8L=JvwUQS+QNj9gWFX-TL@mail.gmail.com>
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

On Fri, Jan 21, 2011 at 9:09 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Fri, Jan 21, 2011 at 4:08 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Thu, Jan 20, 2011 at 05:02:55PM +0000, Ben Dooks wrote:
>>> If you want to make it so that each low-power mode has to work
>>> out what PLLs need to be disabled and then re-enabled makes me
>>> want to be sick. Hiding this stuff behind specific implementations
>>> is a recipe for disaster.
>>
>> Why should systems which don't suffer from such problems be prevented
>> from gaining power saving from turning off their clocks when devices
>> are not being used (eg, the console serial port.)
>>
>> One solution to your root PLL issue would be to have a separate set of
>> enable/disable API calls which get called at setup/release time (or
>> whatever you'd like to call it) which can only be called from non-atomic
>> context.  Maybe clk_prepare() and clk_unprepare().  These functions
>> should perform whatever is necessary to ensure that the clock source
>> is available for use atomically when clk_enable() is called.
>>
>> So, in your case, clk_prepare() ensures that the root PLL is enabled,
>> clk_unprepare() allows it to be turned off.
>>
>> In the case of a console driver, clk_prepare() can be called when we
>> know the port will be used as a console.  clk_enable() is then called
>> before writing out the string, and clk_disable() after we've completely
>> sent the last character.
>>
>> This allows the best of both worlds.  We now have a clk_enable() which
>> can be used to turn the clocks off through the clock tree up to the first
>> non-atomic clock, and we also have a way to deal with those which need
>> to sleep.  So not only do "sleeping clock" implementations become possible
>> but these "sleeping clock" implementations also get the opportunity to
>> shutdown some of their clock tree with minimal latency for doing so.
>
> This is exactly what I suggested in my last post, except the console example.
> Only to be a part of common clock api because it's not very safe to assume
> future SoCs will have the same simple clock topologies that they have today.
>
> Not to mean to teach, but I hope you realize with more and more
> device controller being crammed into ever shrinking SoCs,
> clock would eventually have to be flexible in functionality
> and complicated in hierarchy. Ben already gave examples
> of Audio, MFC and Video controllers of latest Samsung SoCs.

plus

a) If only Samsung bsp implements the api, it would be impossible to
share drivers, those that can be, with other platforms without nasty ifdef's.
b) If the task of unification starts with only a particular platform made to
implement a new api, the attempt kills its own purpose.
