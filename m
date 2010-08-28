Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0H1THO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:07:14 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:55598 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0H1THN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:07:13 -0400
Message-ID: <4C795E5C.1080506@cesarb.net>
Date: Sat, 28 Aug 2010 16:07:08 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Joe Perches <joe@perches.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
References: <1282869660.1836.5.camel@Joe-Laptop> <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop> <4C784650.2030200@cesarb.net> <1282962104.1946.179.camel@Joe-Laptop> <4C78E8EF.1000009@cesarb.net> <1282994116.1946.226.camel@Joe-Laptop> <4C790693.1060908@cesarb.net> <1283002154.1946.268.camel@Joe-Laptop> <4C791ABA.9070005@cesarb.net> <20100828152335.GA2212@khazad-dum.debian.net>
In-Reply-To: <20100828152335.GA2212@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-08-2010 12:23, Henrique de Moraes Holschuh escreveu:
> On Sat, 28 Aug 2010, Cesar Eduardo Barros wrote:
>> The solution here probably is not less logging. The best solution
>> IMO would be to do some sanity checking when loading the module, and
>> if the values do not make sense, print something to the log and
>> return -ENODEV.
>
> As long as your sanity checking won't make the module fail to load in the
> following scenario:
>
> 1. environment temperature control fails, room starts to heat up
> 2. things go south, server reboots due to exceeded temperature limits
> 3. OS boots in an overheat situation
> 4. module refuse to load because it expects to never start in a overheating
>     situation.
>
> If the sanity checks will cause (4), then don't add them.  rate-limit the
> thermal alarms (issue them only once every T, and only if temperature has
> increased more than, say, 5°C from the last alarm).

I have not read the datasheet (I do not even know if it is available to 
the public; I have not looked), but I would not expect to see a power 
limit of 0 even if the CPU is on fire. Of course, you have to be more 
cautious when validating the current temperature (and even then, if it 
says the CPU is encased in a block of ice, something odd is going on).

> If a given platform is buggy crap (or just el-cheapo trash that overheats
> all the time) to the point that the module is useless, blacklist it by DMI
> and inform the user.
>
>> I expect that, when it works as it should, the first read while
>> loading the module already returns sane values, so a sanity check
>
> well, as long as "sane" does include server-is-too-hot situations...

Of course. (But you most probably will want to s/server/laptop/ here.)

>> there should not have many false positives. OTOH, it is best to not
>> load the module when you think things are strange.
>
> What good is an alarm module that refuses to load when there is an alarm
> condition happening already?

This is not an alarm module; AFAIK it is a module for the feature in 
recent Intel CPU/GPU chips which allow you to overclock it a bit as long 
as the thermal and power limit has not been exceeded:

config INTEL_IPS
	tristate "Intel Intelligent Power Sharing"
	depends on ACPI
	---help---
	  Intel Calpella platforms support dynamic power sharing between the
	  CPU and GPU, maximizing performance in a given TDP.  This driver,
	  along with the CPU frequency and i915 drivers, provides that
	  functionality.  If in doubt, say Y here; it will only load on
	  supported platforms.

If the module is not loaded, it simply will not be able to go above its 
nominal clock, so refusing to load it is not that much of a problem.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
