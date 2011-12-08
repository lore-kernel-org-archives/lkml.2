Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1LHQxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:53:21 -0500
Received: from claw.goop.org ([74.207.240.146]:60210 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1LHQxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:53:20 -0500
Message-ID: <4EE0EB7B.6060807@goop.org>
Date: Thu, 08 Dec 2011 08:53:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com> <4ED90E6D.8090402@goop.org> <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com> <4ED9BDF8.3010600@goop.org> <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com> <4EDE4C7A.1010802@goop.org> <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com> <4EDFA192.7000602@goop.org> <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com> <4EE015D1.5070005@goop.org> <20111208104127.GA1753@oksana.dev.rtsoft.ru>
In-Reply-To: <20111208104127.GA1753@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 02:41 AM, Anton Vorontsov wrote:
> On Wed, Dec 07, 2011 at 05:41:37PM -0800, Jeremy Fitzhardinge wrote:
> [...]
>> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
>> index 6512b20..ec36c82 100644
>> --- a/drivers/acpi/ac.c
>> +++ b/drivers/acpi/ac.c
>> @@ -142,6 +142,9 @@ static int get_ac_property(struct power_supply *psy,
>>  	case POWER_SUPPLY_PROP_ONLINE:
>>  		val->intval = ac->state;
>>  		break;
>> +	case POWER_SUPPLY_PROP_SCOPE:
>> +		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
>> +		break;
>>  	default:
>>  		return -EINVAL;
>>  	}
> Mm... how about the rest of the drivers? I.e. drivers/power/*battery.c?
>
> I think it's not a great idea to patch every driver, would be better to make
> it similar to how we handle power_supply.type (w/ default value 'SYSTEM').

Yes.  That patch was mostly so I could test the mechanism.  Certainly
general rule is that if there's no scope attribute then assume System.

> But, thinking more about it... personally, from the ABI point of view, I'd
> like to just see some kind of 'supplicants' directory in the power_supply
> instances, with symlinks to an appropriate devices.

Yes, that was my first proposal, and I have a patch to allow Device
scope power supplies to indicate which "device" it is (which may be a
root of a subtree of devices).  I'm not too sure about making it
multiple devices; at that point I'd be tempted to introduce the notion
of a "power bus" which points to multiple devices and make power
supplies point to that.

> I.e.
> /sys/class/power_supply/battery/supplicants/<device_name>
> is a symlink to /sys/class/HID/.../device.
>
> With a special meaning of an empty directory (or non-existent, or w/ a
> symlink pointing to '/sys/devices/system') -- system power.

Yes.  That's awkward to implement because the kobj isn't exported from
device/base.  But aside from that, its a somewhat awkward interface for
usermode, because it has to end up following symlink and resolving their
paths, and then having special hardcoded knowledge of what particular
paths mean.  When all upower really wants to know is "do I need to
suspend when this supply gets low?".

> That way we may describe any possible power hierarchy.
>
> From the implementation point of view, for now power_supply may just
> conditionally (by introducing power_supply.not_system_power flag)

How is that different from scope?

    J
