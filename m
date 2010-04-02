Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0DBQBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:01:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49172 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0DBQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:01:03 -0400
Date: Fri, 2 Apr 2010 17:00:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: regulator: regulator_get behaviour without CONFIG_REGULATOR set
Message-ID: <20100402160058.GE27613@sirena.org.uk>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com> <1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
X-Cookie: Forty two.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 11:47:50AM -0400, Jerome Oufella wrote:

Please fix your mail client to word wrap paragraphs, I've manually fixed
this up here.

> Working on drivers/hwmon/sht15.c, I noticed it would return bogus
> temperatures in my case, where CONFIG_REGULATOR is not set.

> This is due to the following section in drivers/hwmon/sht15.c:
> 
> /* If a regulator is available, query what the supply voltage actually is!*/
>         data->reg = regulator_get(data->dev, "vcc");
>         if (!IS_ERR(data->reg)) {
>             ...

> Looking at consumer.h, it appears that regulator_get() returns a
> pointer to its second argument when CONFIG_REGULATOR is not set.

Right, it's just returning something that won't match IS_ERR().

> What would be the proper way to determine if the returned value is a
> valid regulator ?  Would it be safe to check it against the 2nd
> argument ?

You're asking the wrong question here.  The problem here is not that the
regulator got stubbed out, the problem is that the sht15 driver is not
checking the return value of regulator_get_voltage() and so is trying to
use the error code that was returned as a voltage, with predictably poor
results.  It is this function that the driver needs to check, not
regulator_get().  There are a range of reasons why an error might be
returned when querying the voltage, all of which would cause the same
result.

It is not sensible to check the return code of regulator_get() for
anything other than IS_ERR().
