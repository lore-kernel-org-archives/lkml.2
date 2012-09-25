Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2IYFWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:22:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2IYFWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:22:07 -0400
Date: Tue, 25 Sep 2012 15:21:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Durgadoss R <durgadoss.r@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: manual merge of the workqueues tree with the thermal
 tree
Message-Id: <20120925152157.aca11703c79c9b1e67fbeaf7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_15_21_57_+1000_sS9iS5C2yV4YWS00"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_15_21_57_+1000_sS9iS5C2yV4YWS00
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
drivers/thermal/thermal_sys.c between commit bc3f847a193d ("Thermal:
Remove throttling logic out of thermal_sys.c") from the thermal tree and
commit 41f63c5359d1 ("workqueue: use mod_delayed_work() instead of cancel
+ queue") from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/thermal/thermal_sys.c
index 4f77d89,67789b8..0000000
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@@ -161,263 -91,6 +161,260 @@@ static void release_idr(struct idr *idr
  		mutex_unlock(lock);
  }
 =20
 +int get_tz_trend(struct thermal_zone_device *tz, int trip)
 +{
 +	enum thermal_trend trend;
 +
 +	if (!tz->ops->get_trend || tz->ops->get_trend(tz, trip, &trend)) {
 +		if (tz->temperature > tz->last_temperature)
 +			trend =3D THERMAL_TREND_RAISING;
 +		else if (tz->temperature < tz->last_temperature)
 +			trend =3D THERMAL_TREND_DROPPING;
 +		else
 +			trend =3D THERMAL_TREND_STABLE;
 +	}
 +
 +	return trend;
 +}
 +EXPORT_SYMBOL(get_tz_trend);
 +
 +struct thermal_instance *get_thermal_instance(struct thermal_zone_device =
*tz,
 +			struct thermal_cooling_device *cdev, int trip)
 +{
 +	struct thermal_instance *pos =3D NULL;
 +	struct thermal_instance *target_instance =3D NULL;
 +
 +	mutex_lock(&tz->lock);
 +	mutex_lock(&cdev->lock);
 +
 +	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
 +		if (pos->tz =3D=3D tz && pos->trip =3D=3D trip && pos->cdev =3D=3D cdev=
) {
 +			target_instance =3D pos;
 +			break;
 +		}
 +	}
 +
 +	mutex_unlock(&cdev->lock);
 +	mutex_unlock(&tz->lock);
 +
 +	return target_instance;
 +}
 +EXPORT_SYMBOL(get_thermal_instance);
 +
 +static void print_bind_err_msg(struct thermal_zone_device *tz,
 +			struct thermal_cooling_device *cdev, int ret)
 +{
 +	dev_err(&tz->device, "binding zone %s with cdev %s failed:%d\n",
 +				tz->type, cdev->type, ret);
 +}
 +
 +static void __bind(struct thermal_zone_device *tz, int mask,
 +			struct thermal_cooling_device *cdev)
 +{
 +	int i, ret;
 +
 +	for (i =3D 0; i < tz->trips; i++) {
 +		if (mask & (1 << i)) {
 +			ret =3D thermal_zone_bind_cooling_device(tz, i, cdev,
 +					THERMAL_NO_LIMIT, THERMAL_NO_LIMIT);
 +			if (ret)
 +				print_bind_err_msg(tz, cdev, ret);
 +		}
 +	}
 +}
 +
 +static void __unbind(struct thermal_zone_device *tz, int mask,
 +			struct thermal_cooling_device *cdev)
 +{
 +	int i;
 +
 +	for (i =3D 0; i < tz->trips; i++)
 +		if (mask & (1 << i))
 +			thermal_zone_unbind_cooling_device(tz, i, cdev);
 +}
 +
 +static void bind_cdev(struct thermal_cooling_device *cdev)
 +{
 +	int i, ret;
 +	const struct thermal_zone_params *tzp;
 +	struct thermal_zone_device *pos =3D NULL;
 +
 +	mutex_lock(&thermal_list_lock);
 +
 +	list_for_each_entry(pos, &thermal_tz_list, node) {
 +		if (!pos->tzp && !pos->ops->bind)
 +			continue;
 +
 +		if (!pos->tzp && pos->ops->bind) {
 +			ret =3D pos->ops->bind(pos, cdev);
 +			if (ret)
 +				print_bind_err_msg(pos, cdev, ret);
 +		}
 +
 +		tzp =3D pos->tzp;
 +		if (!tzp->tbp)
 +			return;
 +
 +		for (i =3D 0; i < tzp->num_tbps; i++) {
 +			if (tzp->tbp[i].cdev || !tzp->tbp[i].match)
 +				continue;
 +			if (tzp->tbp[i].match(pos, cdev))
 +				continue;
 +			tzp->tbp[i].cdev =3D cdev;
 +			__bind(pos, tzp->tbp[i].trip_mask, cdev);
 +		}
 +	}
 +
 +	mutex_unlock(&thermal_list_lock);
 +}
 +
 +static void bind_tz(struct thermal_zone_device *tz)
 +{
 +	int i, ret;
 +	struct thermal_cooling_device *pos =3D NULL;
 +	const struct thermal_zone_params *tzp =3D tz->tzp;
 +
 +	if (!tzp && !tz->ops->bind)
 +		return;
 +
 +	mutex_lock(&thermal_list_lock);
 +
 +	/* If there is no platform data, try to use ops->bind */
 +	if (!tzp && tz->ops->bind) {
 +		list_for_each_entry(pos, &thermal_cdev_list, node) {
 +			ret =3D tz->ops->bind(tz, pos);
 +			if (ret)
 +				print_bind_err_msg(tz, pos, ret);
 +		}
 +		goto exit;
 +	}
 +
 +	if (!tzp->tbp)
 +		goto exit;
 +
 +	list_for_each_entry(pos, &thermal_cdev_list, node) {
 +		for (i =3D 0; i < tzp->num_tbps; i++) {
 +			if (tzp->tbp[i].cdev || !tzp->tbp[i].match)
 +				continue;
 +			if (tzp->tbp[i].match(tz, pos))
 +				continue;
 +			tzp->tbp[i].cdev =3D pos;
 +			__bind(tz, tzp->tbp[i].trip_mask, pos);
 +		}
 +	}
 +exit:
 +	mutex_unlock(&thermal_list_lock);
 +}
 +
 +static void thermal_zone_device_set_polling(struct thermal_zone_device *t=
z,
 +					    int delay)
 +{
- 	cancel_delayed_work(&(tz->poll_queue));
-=20
- 	if (!delay)
- 		return;
-=20
 +	if (delay > 1000)
- 		queue_delayed_work(system_freezable_wq, &(tz->poll_queue),
- 				      round_jiffies(msecs_to_jiffies(delay)));
++		mod_delayed_work(system_freezable_wq, &tz->poll_queue,
++				 round_jiffies(msecs_to_jiffies(delay)));
++	else if (delay)
++		mod_delayed_work(system_freezable_wq, &tz->poll_queue,
++				 msecs_to_jiffies(delay));
 +	else
- 		queue_delayed_work(system_freezable_wq, &(tz->poll_queue),
- 				      msecs_to_jiffies(delay));
++		cancel_delayed_work(&tz->poll_queue);
 +}
 +
 +static void monitor_thermal_zone(struct thermal_zone_device *tz)
 +{
 +	mutex_lock(&tz->lock);
 +
 +	if (tz->passive)
 +		thermal_zone_device_set_polling(tz, tz->passive_delay);
 +	else if (tz->polling_delay)
 +		thermal_zone_device_set_polling(tz, tz->polling_delay);
 +	else
 +		thermal_zone_device_set_polling(tz, 0);
 +
 +	mutex_unlock(&tz->lock);
 +}
 +
 +static void handle_non_critical_trips(struct thermal_zone_device *tz,
 +			int trip, enum thermal_trip_type trip_type)
 +{
 +	tz->governor->throttle(tz, trip);
 +}
 +
 +static void handle_critical_trips(struct thermal_zone_device *tz,
 +				int trip, enum thermal_trip_type trip_type)
 +{
 +	long trip_temp;
 +
 +	tz->ops->get_trip_temp(tz, trip, &trip_temp);
 +
 +	/* If we have not crossed the trip_temp, we do not care. */
 +	if (tz->temperature < trip_temp)
 +		return;
 +
 +	if (tz->ops->notify)
 +		tz->ops->notify(tz, trip, trip_type);
 +
 +	if (trip_type =3D=3D THERMAL_TRIP_CRITICAL) {
 +		pr_emerg("Critical temperature reached(%d C),shutting down\n",
 +			 tz->temperature / 1000);
 +		orderly_poweroff(true);
 +	}
 +}
 +
 +static void handle_thermal_trip(struct thermal_zone_device *tz, int trip)
 +{
 +	enum thermal_trip_type type;
 +
 +	tz->ops->get_trip_type(tz, trip, &type);
 +
 +	if (type =3D=3D THERMAL_TRIP_CRITICAL || type =3D=3D THERMAL_TRIP_HOT)
 +		handle_critical_trips(tz, trip, type);
 +	else
 +		handle_non_critical_trips(tz, trip, type);
 +	/*
 +	 * Alright, we handled this trip successfully.
 +	 * So, start monitoring again.
 +	 */
 +	monitor_thermal_zone(tz);
 +}
 +
 +static void update_temperature(struct thermal_zone_device *tz)
 +{
 +	long temp;
 +	int ret;
 +
 +	mutex_lock(&tz->lock);
 +
 +	ret =3D tz->ops->get_temp(tz, &temp);
 +	if (ret) {
 +		pr_warn("failed to read out thermal zone %d\n", tz->id);
 +		return;
 +	}
 +
 +	tz->last_temperature =3D tz->temperature;
 +	tz->temperature =3D temp;
 +
 +	mutex_unlock(&tz->lock);
 +}
 +
 +void thermal_zone_device_update(struct thermal_zone_device *tz)
 +{
 +	int count;
 +
 +	update_temperature(tz);
 +
 +	for (count =3D 0; count < tz->trips; count++)
 +		handle_thermal_trip(tz, count);
 +}
 +EXPORT_SYMBOL(thermal_zone_device_update);
 +
 +static void thermal_zone_device_check(struct work_struct *work)
 +{
 +	struct thermal_zone_device *tz =3D container_of(work, struct
 +						      thermal_zone_device,
 +						      poll_queue.work);
 +	thermal_zone_device_update(tz);
 +}
 +
  /* sys I/F for thermal zone */
 =20
  #define to_thermal_zone(_dev) \

--Signature=_Tue__25_Sep_2012_15_21_57_+1000_sS9iS5C2yV4YWS00
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYT91AAoJEECxmPOUX5FEnjEP/A9tn7knqiKxLgE+K45jd63a
BSxaAFA45uz5O2Y0tTL/t8gZOOYAJ7bZIkCzE7bcQdyebfPKEnrTqnTNtugOh4h9
KnLntHxW2iout08UIeh6BuzisJ8A3FXlogB7rocLjKti/o073GFAbEQPwfm1I8jj
wVNmknmmRqvb8L928jttkDv3uL8lu4C0vGCM+YHX5+Jk6vG8zpHxYETrmjw3gRSQ
GF33X17x5rb3x/MURYcTt7BvDborSYEgukZCAjkWFC1gCltsWhrwMloBL9WTVTuu
x72HCxQ6b6j+SXHOsm4UCsdoJXVDMFloVaKvEvEk/Aqk118QCdFs4VFRv3ejXKQz
JL7Y1/6dNKrXHV9sLpbyGmVp4Ueymbxc+LIbY0J2LxdeEjwAe8xt/3RqV5mdF2r+
N+xLzvNekZCWNfWZIYpFUGSlWJ6vMLywT6BcfRfUhnouFDyx5ZP2lG+cljDWlRcN
60g9aQthbsgXeVUzm71GrkIwz1rOAkwuxA+pUk1AK3qhd5PJvSCHoUL+fNoz7Mz5
33wIM6+7kWmzU8NSKiz4V+oXtlGzDTWuzVN/6ESHOi3oOCjC3iQ81gjzhFAgiuM5
XHGhKgU89h/07hfqkDtSY4N3R4ha5WVzoBCmrWiJl+M6aDNSHKuYUzr9rq6zddhJ
iHVYiKMJ66Yxu6dY4stE
=lVEU
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_15_21_57_+1000_sS9iS5C2yV4YWS00--
