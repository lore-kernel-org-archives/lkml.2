Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1LITjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:39:36 -0500
Received: from claw.goop.org ([74.207.240.146]:35233 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1LITjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:39:32 -0500
Message-ID: <4EE24A3A.7030304@goop.org>
Date: Fri, 09 Dec 2011 09:49:46 -0800
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
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com> <4ED90E6D.8090402@goop.org> <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com> <4ED9BDF8.3010600@goop.org> <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com> <4EDE4C7A.1010802@goop.org> <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com> <4EDFA192.7000602@goop.org> <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com> <4EE015D1.5070005@goop.org> <20111209101700.GA20100@oksana.dev.rtsoft.ru>
In-Reply-To: <20111209101700.GA20100@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 02:17 AM, Anton Vorontsov wrote:
> A few more minor nits...
>
> On Wed, Dec 07, 2011 at 05:41:37PM -0800, Jeremy Fitzhardinge wrote:
> [...]
>> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
>> index 329b46b..bacf327 100644
>> --- a/drivers/power/power_supply_core.c
>> +++ b/drivers/power/power_supply_core.c
>> @@ -147,6 +147,12 @@ struct power_supply *power_supply_get_by_name(char *name)
>>  }
>>  EXPORT_SYMBOL_GPL(power_supply_get_by_name);
>>  
>> +
> Needless newline. :-)

OK.

>> +int power_supply_powers(struct power_supply *psy, struct device *dev)
>> +{
>> +	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
>> +}
> - This surely creates an important ABI to the userland. This has to be
>   documented via Documentation/ABI (or at least via commit message that
>   I don't see in this email :-).

Sure, I'll add that.  It doesn't look like Documentation/ABI has
anything about the whole power_supply class, so I'll consider adding
that as out of scope for this work, but I'll fill out the commit comment.

> - This functionality isn't used anywhere as of now (i.e. I don't see
>   anyone calling this function), so let's omit it for now?

I have a patch in my hid-input battery series which use it.  Actually, I
can use it in this series for the Wacom and Wiimote HID power supplies.

> - I still don't think that this should be a single symlink, to me the
>   more universal (so that we don't have to break ABI in the future)
>   way would be 'powers' directory with symlinks in it.
>   But maybe I'm not following where exactly the link will be created?
>   Documentation or an example of the new sysfs structure would help.

At the moment, it's a pointer to a single device, which may have
sub-devices under it.  This matches the general device tree power
management model which assumes that the bus topology of the system is
also a reasonable approximation for the power distribution topology (if
nothing else, because if you power off a bridge device, you can't see
anything behind it so it may as well be considered powered off as well).

I understand your point about powering multiple devices, but it seems
like overengineering to implement it now unless you have some specific
users of that interface in mind.  If you did want to support a single
power supply powering multiple devices in future, you could add the
notion of a "power bus" device which distributes power to multiple
devices, without having to complicate the common case of powering a
single device, and without having to change the current semantics of the
"powers" link.

>> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
>> index e15d4c9..21178eb 100644
>> --- a/drivers/power/power_supply_sysfs.c
>> +++ b/drivers/power/power_supply_sysfs.c
>> @@ -63,6 +63,9 @@ static ssize_t power_supply_show_property(struct device *dev,
>>  	static char *capacity_level_text[] = {
>>  		"Unknown", "Critical", "Low", "Normal", "High", "Full"
>>  	};
>> +	static char *scope_text[] = {
>> +		"Unknown", "System", "Device"
>> +	};
>>  	ssize_t ret = 0;
>>  	struct power_supply *psy = dev_get_drvdata(dev);
>>  	const ptrdiff_t off = attr - power_supply_attrs;
>> @@ -95,6 +98,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>>  		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
>>  	else if (off == POWER_SUPPLY_PROP_TYPE)
>>  		return sprintf(buf, "%s\n", type_text[value.intval]);
>> +	else if (off == POWER_SUPPLY_PROP_SCOPE)
>> +		return sprintf(buf, "%s\n", scope_text[value.intval]);
> Should we really handle the PROP_SCOPE as a dynamic property?
> Maybe do it similar to PROP_TYPE, so that drivers will only need to
> specity the scope during registration, and not bother w/ handling
> it in theirs get_property() callbacks?

I don't really know.  I guess its possible in theory that a device could
change scope on the fly if its power was re-routed.  But then, the type
can change too (if, for example, a UPS switched between AC and battery
power, or a HID device switching between corded USB power or cordless
battery power), so I'm not really sure what the rationale is either
way.  (I guess you model power supplies switching type as having
multiple power supplies which turn themselves on and offline?)

    J
