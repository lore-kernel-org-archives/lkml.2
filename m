Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0DBQoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:44:14 -0400
Received: from poutre.nerim.net ([62.4.16.124]:59492 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0DBQoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:44:08 -0400
Date: Fri, 2 Apr 2010 18:44:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without 
 CONFIG_REGULATOR set
Message-ID: <20100402184403.2ea1263e@hyperion.delvare>
In-Reply-To: <20100402160058.GE27613@sirena.org.uk>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>
	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
	<20100402160058.GE27613@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 2 Apr 2010 17:00:59 +0100, Mark Brown wrote:
> On Fri, Apr 02, 2010 at 11:47:50AM -0400, Jerome Oufella wrote:
> 
> Please fix your mail client to word wrap paragraphs, I've manually fixed
> this up here.
> 
> > Working on drivers/hwmon/sht15.c, I noticed it would return bogus
> > temperatures in my case, where CONFIG_REGULATOR is not set.
> 
> > This is due to the following section in drivers/hwmon/sht15.c:
> > 
> > /* If a regulator is available, query what the supply voltage actually is!*/
> >         data->reg = regulator_get(data->dev, "vcc");
> >         if (!IS_ERR(data->reg)) {
> >             ...
> 
> > Looking at consumer.h, it appears that regulator_get() returns a
> > pointer to its second argument when CONFIG_REGULATOR is not set.
> 
> Right, it's just returning something that won't match IS_ERR().

Ugly design. You're casting a random pointer to struct regulator * and
just hope that the user won't make use of it. Right now, you're safe
because the definition of struct regulator is not public, but assuming
it will stay that way forever is somewhat risky.

I've never seen any API doing things that way, and I can't think of a
sane reason for doing things that way. It's pretty error-prone.

> > What would be the proper way to determine if the returned value is a
> > valid regulator ?  Would it be safe to check it against the 2nd
> > argument ?
> 
> You're asking the wrong question here.  The problem here is not that the
> regulator got stubbed out, the problem is that the sht15 driver is not
> checking the return value of regulator_get_voltage() and so is trying to
> use the error code that was returned as a voltage,

Error code? regulator_get_voltage() returns 0, how is that supposed to
be an error code?

> with predictably poor
> results.  It is this function that the driver needs to check, not
> regulator_get().

This goes against the expectations. When I have to get a reference to
something and then use that something, I expect the former to fail is
the something is not available for whatever reason. I don't expect to
have to do the latter to realize that the former did not actually work.

> There are a range of reasons why an error might be
> returned when querying the voltage, all of which would cause the same
> result.

I don't quite follow you here.

> It is not sensible to check the return code of regulator_get() for
> anything other than IS_ERR().

Why can't we have the stub form of regulator_get() return NULL or
ERR_PTR(-ENODEV)? This would be a much friendlier API.

-- 
Jean Delvare
