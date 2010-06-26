Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0FZRhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 13:37:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0FZRhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 13:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xht9vDBjvhTQcsuyrGDMhFvFa4k/sFfwUTMyS/M6aIVpCTCamhYekqBQ7QohzjxXb9
         oUpkwde69ATWkqVqcV3gP3mA07jFrCYLNf6U9kg5t9zsBbbBz51WaWqS/FFjBeOAbpLS
         NLdIWFZ4XCTW06Me8Mn0o9WOY4FpMpgXU9LxA=
MIME-Version: 1.0
In-Reply-To: <20100625112232.GA21217@opensource.wolfsonmicro.com>
References: <1277392337-27627-1-git-send-email-linus.walleij@stericsson.com>
	<20100625112232.GA21217@opensource.wolfsonmicro.com>
Date: Sat, 26 Jun 2010 19:37:20 +0200
Message-ID: <AANLkTikiPByvzfbj-gwfyozWb5MMJXSWuINFbrLdcwtU@mail.gmail.com>
Subject: Re: [PATCH] MMC: remove regulator refcount fiddling in mmc core
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Sundar Iyer <sundar.iyer@stericsson.com>,
       Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/25 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Jun 24, 2010 at 05:12:17PM +0200, Linus Walleij wrote:
>
>> Currently the mmc_regulator_set_ocr() fiddles with the regulator
>> refcount by selectively calling regulator_[enable|disable]
>> depending on the state of the regulator. This will confuse the
>> reference count if case the regulator is for example shared with
>> other MMC slots or user for other stuff than the MMC card.
>
>> Push regulator_[enable|disable] out into the MMC host drivers
>> and remove this from the MMC core so the reference count can be
>> trusted.
>
> So, the feedback from folks at the time this was originally written was
> that the MMC code was unable to cope with sharing regulators since it
> really needs to be able to set specific voltages.  This needn't be a
> showstopper since people can force a single voltage in the constraints
> but it does need to be considered here.

Well hm, that's not strictly true. If you only provide one standard
voltage ONLY in your OCR mask, i.e. MMC_VDD_* then you can use
the same regulator for two or more MMC cards.

Further that's a perfectly reasonable thing to do if you have e.g.
two embedded eMMC cards and you know which voltage they like
to operate on ... so share the same regulator, why not. The above
assumption comes from a slot-based world.

Another argument is that a function named
mmc_regulator_set_ocr() shouldn't be enabling/disabling regulators
anyway because it's hopeless to read the code, and the other
functions in mmc/core.c only deals with voltages, not on/off:ing.
(Maybe it's just me who have a hard time reading code like that.)

Yours,
Linus Walleij
