Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2DSOFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:05:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57092 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab2DSOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120419124204.GE3046@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
Date: Thu, 19 Apr 2012 19:35:03 +0530
Message-ID: <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 April 2012 18:12, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 19, 2012 at 03:21:37PM +0530, Jassi Brar wrote:
>> Usually changing the regulator output involves delays before/after the
>> operation.
>> There are consumer drivers shared by platforms, where some may
>> not really have a regulator in the path. Which causes the consumer
>> to unnecessarily (sometimes disruptively) incur delays for the
>> "dummy" regulator.
>
> This analysis doesn't sound quite right - if it's the dummy regulator
> then obviously these delays don't happen so presumably the cost is
> actually coming from the rdev mutex and recursion up the regulator tree
> - the basic overheads of calling into the regulator API.
>
Sorry, I didn't explain well.

I am not talking about the time the regulator output needs to stabilize or the
time taken by control to traverse the regulator tree for "dummy".

I am talking about the delay the consumer driver might want after
enabling the regulator for the end device to, say, initialize itself or
perform POST or whatever.
Now the consumer driver is shared by two platforms - one that has
direct supply to the device that turns on with main power supply
and another platform that has indeed a regulator that is turned
off by default and the consumer driver enables it during probe
and then has to wait tens of millisecs for end device's POST (say).

I do realize that such consumer drivers ought to know about the
presence of the real regulator via platform_data(PD) or DT, but
if we already don't expect consumers to know from PD/DT that
a regulator doesn't exist and hence never even need a "dummy",
maybe the regulator core could lessen the number of PD/DT
nodes by also telling if a given regulator is a real or a dummy one.

That way dummy could actually play a 'positive' role - right now
it only excuses platforms that are lazy to neither define a regulator
nor tell consumer via PD/DT that there is none.

Another POV is :
  Is a consumer's need, to know if the gotten regulator is a real
or a dummy one, reasonable ?

>
> I've just sent out an untested patch (you're CCed) which should give a
> substantial win for the enable/disable case which will hopefully address
> the issue for you.
>
The patch does address an issue, but not mine :)

Regards,
Jassi
