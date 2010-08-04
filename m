Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0HDPoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:44:39 -0400
Received: from vps.mortis.eu ([79.99.135.181]:56029 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0HDPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:44:37 -0400
Date: Wed, 4 Aug 2010 17:44:31 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: Add support for the Fintek F71808E
Message-ID: <20100804154431.GA14382@salidar.me.mortis.eu>
References: <20100801132226.GE3711@salidar.me.mortis.eu>
 <1280669402-31213-1-git-send-email-me@mortis.eu>
 <4C5950B6.5010503@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <4C5950B6.5010503@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2010 at 13:36:22 +0200, Hans de Goede wrote:
> On 08/01/2010 03:30, Giel van Schijndel wrote:
>> Allow device probing to recognise the Fintek F71808E.
>>=20
>> Sysfs interface:
>>   * Fan/pwm control is the same as for F71889FG
>=20
> My datasheet strongly disagrees with this the F71889FG has 5 pwm zones
> each with their own speed divided by 4 boundary temps, where as
> the F71808E has 3 pwm zones divided by 2 boundary temps. So it is much
> more like the F71862FG, which also has 2 boundary temps, and 3 pwm zones,
> *but* the F71862FG has one pwm zone hardwired to 100%.

I'm assuming that by "pwm zone" you mean a separate PWM output channel?
I.e. each "pwm zone" controls a single fan?

Because in the datasheet I have for the F71889 only 3 fan controls are
mentioned, not 5, it does however have 4 boundary temps:
> 7.5. Hardware Monitor
> ... snip ...
> ... page 46-47:
> Device registers, the following is a register map order which shows a
> summary of all registers.  Please refer each one register if you want
> more detail information.
> Register CR01 ~ CR03 -> Configuration Registers
> Register CR0A ~ CR0F -> PECI/SST/TSI Control Register
> Register CR10 ~ CR4F -> Voltage Setting Register
> Register CR60 ~ CR8E -> Temperature Setting Register
> Register CR90 ~ CRDF -> Fan Control Setting Register
>                      -> Fan1 Detail Setting CRA0 ~ CRAF
>                      -> Fan2 Detail Setting CRB0 ~ CRBF
>                      -> Fan3 Detail Setting CRC0 ~ CRCF
> Register CR5A ~ CR5D -> HW Chip ID and Vender ID Register

> So it looks like you need to create a new f71808e_auto_pwm_attr array
> esp. for this model, as well as a special case for reading the
> auto pwm attr in f71882fg_update_device.

Ack.

> Also the auto pwm of the F71808E allows following of digital temps
> read to peci / amdsi / ibex rather then following a directly connected
> temp diode like the F71889FG, which the driver does not support, so
> you should check if this is enabled and if so disable the auto pwm
> attr entirely. Code for this is already in place for the F71889FG,
> you simply need to make it trigger when the chip is a F71808E too.

Do you mean the checking of the FANx_TEMP_SEL_DIG flag in the fan's
"Temperature Mapping Select" registers currently done for the F71889 in
the second switch-statement inside f71882fg_probe?  As that code is
already used for the F71808E as well.

>>   * Temperature and voltage sensor handling is largely the same as for
>>     the F71889FG
>>    - Has one temperature sensor less (doesn't have temp3)
>>    - Misses one voltage sensor (doesn't have V6, thus in6_input refers to
>>      what in7_input refers for F71889FG)
>>=20
>> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
>> such that it can largely be reused.
>=20
> There is a problem here though, the new fxxxx_temp_attr contains
> attributes for temp#_max_beep and temp#_crit_beep, but the F71808E
> lacks that function. So I think that the new fxxxx_temp_attr
> need to be split into fxxxx_temp_attr and fxxxx_temp_beep_attr,
> like is already done with fxxxx_fan_attr.

Ack.

> Also while making changes, I must say I don't like the splitting
> of fxxxx_temp_attr into fxxxx_temp_attr and f71862_temp_attr just because
> the number of sensors differs. I think it would be better to instead
> make fxxxx_temp_attr a 2 dimensional array like fxxxx_fan_attr and like
> with fxxxx_fan_attr register as many sensor attr blocks as the specific
> model has.

Right, that's probably a nicer way of going about it, I think that might
be easier done in a separate patch (most likely preceding the addition
of F71808E support), though I'll look at that.

>> Signed-off-by: Giel van Schijndel<me@mortis.eu>
>> ---
>>   Documentation/hwmon/f71882fg |    4 ++
>>   drivers/hwmon/Kconfig        |    6 ++--
>>   drivers/hwmon/f71882fg.c     |   83 ++++++++++++++++++++++++++++++++++=
++++----
>>   3 files changed, 82 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/Documentation/hwmon/f71882fg b/Documentation/hwmon/f71882fg
>> index a7952c2..1a07fd6 100644
>> --- a/Documentation/hwmon/f71882fg
>> +++ b/Documentation/hwmon/f71882fg
>> @@ -2,6 +2,10 @@ Kernel driver f71882fg
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>>   Supported chips:
>> +  * Fintek F71808E
>> +    Prefix: 'f71808fg'
>=20
> This is wrong, as you already indicate and the datasheet as well this
> chip in question is an f71808e not an f71808fg, also note that there is
> an f71808a model as well which is different (and has a different super io
> chip id).

Ah yes, I think I, wrongly, assumed that 'fg' was just some suffix used
in this driver.  For example, I cannot find F71889FG in the datasheet I
have, only 'F71889' along with 'F71889F' in the section "Ordering
Information" (for the F71889 I've got datasheet version V0.17P released
December 2008).

At the same time the F71808E datasheet I have clearly marks the chip as
F71808E all over the entire datasheet (version V0.17P released October
2009).

Either way I changed that ^^ portion of documentation while changing the
enumeration value 'f71808fg' -> 'f71808e' in the code itself as well.

> One last request in the second switch case in f71882fg_remove()
> there is a default label which contains a comment which models it applies
> to, please add the f71808e to that comment.

Wouldn't it be better, to instead replace that 'default' label with a
serie of case labels that code applies to?  Along with providing the
same documentation effect (expressed in C instead of English) it would
cause GCC to warn whenever one of the chips was forgotten in a switch
statement.  E.g. something similar to this patch:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index b891b65..bfb2b4c 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2113,7 +2113,8 @@ static int __devinit f71882fg_probe(struct platform_d=
evice *pdev)
                                break;
                        }
                        /* fall through */
-               default: /* f71858fg / f71882fg */
+               case f71858fg:
+               case f71882fg:
                        err =3D f71882fg_create_sysfs_files(pdev,
                                &fxxxx_auto_pwm_attr[0][0],
                                ARRAY_SIZE(fxxxx_auto_pwm_attr[0]) * nr_fan=
s);
@@ -2224,7 +2225,10 @@ static int f71882fg_remove(struct platform_device *p=
dev)
                                        f8000_auto_pwm_attr,
                                        ARRAY_SIZE(f8000_auto_pwm_attr));
                        break;
-               default: /* f71808e / f71858fg / f71882fg / f71889fg */
+               case f71808e:
+               case f71858fg:
+               case f71882fg:
+               case f71889fg:
                        f71882fg_remove_sysfs_files(pdev,
                                &fxxxx_auto_pwm_attr[0][0],
                                ARRAY_SIZE(fxxxx_auto_pwm_attr[0]) * nr_fan=
s);
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

PS For comparison, which datasheet versions do you have?
All Fintek datasheets I have access to:
 * F71808E - V0.17P, October 2009
 * F71858  - V0.26P, July 2007
 * F71862  - V0.28P, July 2008
 * F71882  - V0.24P, November 2006
 * F71889  - V0.17P, December 2008

Those most interesting are of course the F71808E, F71862 and F71889---as
you refer to those in your text.  This because I have already had
experience with a hardware vendor giving me the wrong datasheets and
would like to prevent any such mistakes from causing similar
communication problems here.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxZit0ACgkQZBYm/87l50JurACgiW4Z05hVnaR+0JYsGdc6riz8
YA0AnRmu64EoKSvytFpnHCH+H+iSKYhz
=4eVB
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
