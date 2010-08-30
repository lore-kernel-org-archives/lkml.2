Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0H3QaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:30:04 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:47728 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755936Ab0H3QaB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:30:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ddIekra4dO33NbrtHIpktg0vroRFp6P/4X3OgG7yXk/ak2SLjPRpPZ4TXaa2QTuTPFeSZY+4pJdu0Wqa91MlJX+aLoY6QM7v3F5lEZNyFNHdfLukOmhgQuUUcVLSHnr4;
Date: Mon, 30 Aug 2010 09:29:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Joe Perches <joe@perches.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
Message-ID: <20100830092958.1c50c8cb@jbarnes-desktop>
In-Reply-To: <4C795E5C.1080506@cesarb.net>
References: <1282869660.1836.5.camel@Joe-Laptop>
	<4C77171E.6060008@cesarb.net>
	<1282894751.1836.41.camel@Joe-Laptop>
	<4C784650.2030200@cesarb.net>
	<1282962104.1946.179.camel@Joe-Laptop>
	<4C78E8EF.1000009@cesarb.net>
	<1282994116.1946.226.camel@Joe-Laptop>
	<4C790693.1060908@cesarb.net>
	<1283002154.1946.268.camel@Joe-Laptop>
	<4C791ABA.9070005@cesarb.net>
	<20100828152335.GA2212@khazad-dum.debian.net>
	<4C795E5C.1080506@cesarb.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Aug 2010 16:07:08 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> Em 28-08-2010 12:23, Henrique de Moraes Holschuh escreveu:
> > On Sat, 28 Aug 2010, Cesar Eduardo Barros wrote:
> >> The solution here probably is not less logging. The best solution
> >> IMO would be to do some sanity checking when loading the module, and
> >> if the values do not make sense, print something to the log and
> >> return -ENODEV.
> >
> > As long as your sanity checking won't make the module fail to load in the
> > following scenario:
> >
> > 1. environment temperature control fails, room starts to heat up
> > 2. things go south, server reboots due to exceeded temperature limits
> > 3. OS boots in an overheat situation
> > 4. module refuse to load because it expects to never start in a overheating
> >     situation.
> >
> > If the sanity checks will cause (4), then don't add them.  rate-limit the
> > thermal alarms (issue them only once every T, and only if temperature has
> > increased more than, say, 5°C from the last alarm).
> 
> I have not read the datasheet (I do not even know if it is available to 
> the public; I have not looked), but I would not expect to see a power 
> limit of 0 even if the CPU is on fire. Of course, you have to be more 
> cautious when validating the current temperature (and even then, if it 
> says the CPU is encased in a block of ice, something odd is going on).
> 
> > If a given platform is buggy crap (or just el-cheapo trash that overheats
> > all the time) to the point that the module is useless, blacklist it by DMI
> > and inform the user.
> >
> >> I expect that, when it works as it should, the first read while
> >> loading the module already returns sane values, so a sanity check
> >
> > well, as long as "sane" does include server-is-too-hot situations...
> 
> Of course. (But you most probably will want to s/server/laptop/ here.)
> 
> >> there should not have many false positives. OTOH, it is best to not
> >> load the module when you think things are strange.
> >
> > What good is an alarm module that refuses to load when there is an alarm
> > condition happening already?
> 
> This is not an alarm module; AFAIK it is a module for the feature in 
> recent Intel CPU/GPU chips which allow you to overclock it a bit as long 
> as the thermal and power limit has not been exceeded:
> 
> config INTEL_IPS
> 	tristate "Intel Intelligent Power Sharing"
> 	depends on ACPI
> 	---help---
> 	  Intel Calpella platforms support dynamic power sharing between the
> 	  CPU and GPU, maximizing performance in a given TDP.  This driver,
> 	  along with the CPU frequency and i915 drivers, provides that
> 	  functionality.  If in doubt, say Y here; it will only load on
> 	  supported platforms.
> 
> If the module is not loaded, it simply will not be able to go above its 
> nominal clock, so refusing to load it is not that much of a problem.

It sounds like either your BIOS values are wrong or the driver isn't
fetching them correctly on your platform.

It's possible that the main issue here is bad thermal limits.  There's
obviously a relationship between power and thermal output, but the
driver tries to monitor both.  However it's up to the BIOS to provide
the driver with accurate thermal limits, as well as accurate power
limits.  The power limits sound reasonable at 25W, thus the
informational output about 35W vs 25W (35W is what the MCP can handle,
but some platforms are designed to handle less, so they clamp it down a
bit).  But the temp limits look all wrong.  I'll see if I can find info
on getting better data into the driver...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
