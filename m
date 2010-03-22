Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0CVLmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:42:05 -0400
Received: from vps.mortis.eu ([79.99.135.181]:60007 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0CVLmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:42:04 -0400
Date: Mon, 22 Mar 2010 12:41:57 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Hwmon: f71882fg: use strict_stro(l|ul) instead of
 simple_strto$1
Message-ID: <20100322114157.GA14077@salidar.me.mortis.eu>
References: <1269185834-10266-1-git-send-email-me@mortis.eu>
 <1269185834-10266-2-git-send-email-me@mortis.eu>
 <20100322112308.13d58db4@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20100322112308.13d58db4@hyperion.delvare>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2010 at 11:23:08AM +0100, Jean Delvare wrote:
> On Sun, 21 Mar 2010 16:37:14 +0100, Giel van Schijndel wrote:
>> Use the strict_strol and strict_stroul functions instead of simple_strol
>> and simple_stroul respectively in sysfs functions.
>>=20
>> Signed-off-by: Giel van Schijndel <me@mortis.eu>
>> ---
>>  drivers/hwmon/f71882fg.c |   89 ++++++++++++++++++++++++++++++++++++++-=
-------
>>  1 files changed, 74 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>> index 21bc661..5c725a3 100644
>> --- a/drivers/hwmon/f71882fg.c
>> +++ b/drivers/hwmon/f71882fg.c
>> @@ -1128,7 +1128,10 @@ static ssize_t store_fan_full_speed(struct device=
 *dev,
>>  {
>>  	struct f71882fg_data *data =3D dev_get_drvdata(dev);
>>  	int nr =3D to_sensor_dev_attr_2(devattr)->index;
>> -	long val =3D simple_strtol(buf, NULL, 10);
>> +	long val;
>> +
>> +	if (strict_strtol(buf, 10, &val) =3D=3D -EINVAL)
>> +		return -EINVAL;
>
> That's not correct. You want to return an error if strict_strtol()
> returns _any_ error, not just -EINVAL. Maybe the current
> implementation can't return any other error code, but you should not
> assume this will always be the case in the future.

Agreed. New patch follows this line:
------------------------------------------------------------------------
Hwmon: f71882fg: use strict_stro(l|ul) instead of simple_strto$1

Use the strict_strol and strict_stroul functions instead of simple_strol
and simple_stroul respectively in sysfs functions.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |  133 ++++++++++++++++++++++++++++++++++++------=
----
 1 files changed, 104 insertions(+), 29 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 21bc661..4230729 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -1127,8 +1127,12 @@ static ssize_t store_fan_full_speed(struct device *d=
ev,
 				    const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
=20
 	val =3D SENSORS_LIMIT(val, 23, 1500000);
 	val =3D fan_to_reg(val);
@@ -1157,8 +1161,12 @@ static ssize_t store_fan_beep(struct device *dev, st=
ruct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	unsigned long val =3D simple_strtoul(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	unsigned long val;
+
+	err =3D strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
=20
 	mutex_lock(&data->update_lock);
 	data->fan_beep =3D f71882fg_read8(data, F71882FG_REG_FAN_BEEP);
@@ -1206,7 +1214,14 @@ static ssize_t store_in_max(struct device *dev, stru=
ct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	long val =3D simple_strtol(buf, NULL, 10) / 8;
+	int err;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 8;
 	val =3D SENSORS_LIMIT(val, 0, 255);
=20
 	mutex_lock(&data->update_lock);
@@ -1233,8 +1248,12 @@ static ssize_t store_in_beep(struct device *dev, str=
uct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	unsigned long val =3D simple_strtoul(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	unsigned long val;
+
+	err =3D strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
=20
 	mutex_lock(&data->update_lock);
 	data->in_beep =3D f71882fg_read8(data, F71882FG_REG_IN_BEEP);
@@ -1299,8 +1318,14 @@ static ssize_t store_temp_max(struct device *dev, st=
ruct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10) / 1000;
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 1000;
 	val =3D SENSORS_LIMIT(val, 0, 255);
=20
 	mutex_lock(&data->update_lock);
@@ -1333,10 +1358,16 @@ static ssize_t store_temp_max_hyst(struct device *d=
ev, struct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10) / 1000;
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
 	ssize_t ret =3D count;
 	u8 reg;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 1000;
=20
 	mutex_lock(&data->update_lock);
=20
@@ -1372,8 +1403,14 @@ static ssize_t store_temp_crit(struct device *dev, s=
truct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10) / 1000;
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 1000;
 	val =3D SENSORS_LIMIT(val, 0, 255);
=20
 	mutex_lock(&data->update_lock);
@@ -1427,8 +1464,12 @@ static ssize_t store_temp_beep(struct device *dev, s=
truct device_attribute
 	*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	unsigned long val =3D simple_strtoul(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	unsigned long val;
+
+	err =3D strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
=20
 	mutex_lock(&data->update_lock);
 	data->temp_beep =3D f71882fg_read8(data, F71882FG_REG_TEMP_BEEP);
@@ -1490,8 +1531,13 @@ static ssize_t store_pwm(struct device *dev,
 			 size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
 	val =3D SENSORS_LIMIT(val, 0, 255);
=20
 	mutex_lock(&data->update_lock);
@@ -1551,8 +1597,12 @@ static ssize_t store_pwm_enable(struct device *dev, =
struct device_attribute
 				*devattr, const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
=20
 	/* Special case for F8000 pwm channel 3 which only does auto mode */
 	if (data->type =3D=3D f8000 && nr =3D=3D 2 && val !=3D 2)
@@ -1626,9 +1676,14 @@ static ssize_t store_pwm_auto_point_pwm(struct devic=
e *dev,
 					const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int pwm =3D to_sensor_dev_attr_2(devattr)->index;
+	int err, pwm =3D to_sensor_dev_attr_2(devattr)->index;
 	int point =3D to_sensor_dev_attr_2(devattr)->nr;
-	long val =3D simple_strtol(buf, NULL, 10);
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
 	val =3D SENSORS_LIMIT(val, 0, 255);
=20
 	mutex_lock(&data->update_lock);
@@ -1674,10 +1729,16 @@ static ssize_t store_pwm_auto_point_temp_hyst(struc=
t device *dev,
 					      const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
 	int point =3D to_sensor_dev_attr_2(devattr)->nr;
-	long val =3D simple_strtol(buf, NULL, 10) / 1000;
 	u8 reg;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 1000;
=20
 	mutex_lock(&data->update_lock);
 	data->pwm_auto_point_temp[nr][point] =3D
@@ -1716,8 +1777,12 @@ static ssize_t store_pwm_interpolate(struct device *=
dev,
 				     const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	unsigned long val =3D simple_strtoul(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	unsigned long val;
+
+	err =3D strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
=20
 	mutex_lock(&data->update_lock);
 	data->pwm_auto_point_mapping[nr] =3D
@@ -1752,8 +1817,12 @@ static ssize_t store_pwm_auto_point_channel(struct d=
evice *dev,
 					    const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int nr =3D to_sensor_dev_attr_2(devattr)->index;
-	long val =3D simple_strtol(buf, NULL, 10);
+	int err, nr =3D to_sensor_dev_attr_2(devattr)->index;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
=20
 	switch (val) {
 	case 1:
@@ -1798,9 +1867,15 @@ static ssize_t store_pwm_auto_point_temp(struct devi=
ce *dev,
 					 const char *buf, size_t count)
 {
 	struct f71882fg_data *data =3D dev_get_drvdata(dev);
-	int pwm =3D to_sensor_dev_attr_2(devattr)->index;
+	int err, pwm =3D to_sensor_dev_attr_2(devattr)->index;
 	int point =3D to_sensor_dev_attr_2(devattr)->nr;
-	long val =3D simple_strtol(buf, NULL, 10) / 1000;
+	long val;
+
+	err =3D strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+
+	val /=3D 1000;
=20
 	if (data->type =3D=3D f71889fg)
 		val =3D SENSORS_LIMIT(val, -128, 127);
--=20
1.6.4.4


--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkunV4MACgkQZBYm/87l50JrmACguMS4waD+AoK3fSVKlxyql4fA
uqMAmwcieqPEluCBYzdApPJBJMG/rart
=bmE5
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
