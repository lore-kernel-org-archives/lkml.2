Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2BNDZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:25:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2BNDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:25:51 -0500
Date: Tue, 14 Feb 2012 14:25:40 +1100
From: NeilBrown <neilb@suse.de>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is
 not empty.
Message-ID: <20120214142540.04de41df@notabene.brown>
In-Reply-To: <1327112659-31145-1-git-send-email-arve@android.com>
References: <1327112659-31145-1-git-send-email-arve@android.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y+2oHrFEcRwe_6A.wbJvyv5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/y+2oHrFEcRwe_6A.wbJvyv5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jan 2012 18:24:16 -0800 Arve Hj=C3=B8nnev=C3=A5g <arve@android.c=
om> wrote:

> Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
> queue is not empty. This allows userspace code to process input
> events while the device appears to be asleep.
>=20
> Signed-off-by: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>

This is exactly the sort of "feature creep" that I worried about in my reply
to Rafael's recent "autosleep" patches.

A particular issue here:  This patch allows any process that can open an
input device to keep the device awake - by not reading an event that has
arrived (whether due to incompetence or malice).

So either we would need strict controls on who can open /dev/input/eventX,
or be happy that any process can disable suspend.
Or add some extra feature-creep to provide access control.

(or just keep this stuff out of the kernel and let a user-space daemon make
those decisions).

NeilBrown


> ---
>  drivers/input/evdev.c |   63 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/input.h |    3 ++
>  2 files changed, 66 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 76457d5..e212757 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -43,6 +43,7 @@ struct evdev_client {
>  	unsigned int tail;
>  	unsigned int packet_head; /* [future] position of the first element of =
next packet */
>  	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
> +	struct wakeup_source *wakeup_source;
>  	struct fasync_struct *fasync;
>  	struct evdev *evdev;
>  	struct list_head node;
> @@ -75,10 +76,14 @@ static void evdev_pass_event(struct evdev_client *cli=
ent,
>  		client->buffer[client->tail].value =3D 0;
> =20
>  		client->packet_head =3D client->tail;
> +		if (client->wakeup_source)
> +			__pm_relax(client->wakeup_source);
>  	}
> =20
>  	if (event->type =3D=3D EV_SYN && event->code =3D=3D SYN_REPORT) {
>  		client->packet_head =3D client->head;
> +		if (client->wakeup_source)
> +			__pm_stay_awake(client->wakeup_source);
>  		kill_fasync(&client->fasync, SIGIO, POLL_IN);
>  	}
> =20
> @@ -255,6 +260,10 @@ static int evdev_release(struct inode *inode, struct=
 file *file)
>  	mutex_unlock(&evdev->mutex);
> =20
>  	evdev_detach_client(evdev, client);
> +	if (client->wakeup_source) {
> +		__pm_relax(client->wakeup_source);
> +		wakeup_source_unregister(client->wakeup_source);
> +	}
>  	kfree(client);
> =20
>  	evdev_close_device(evdev);
> @@ -373,6 +382,9 @@ static int evdev_fetch_next_event(struct evdev_client=
 *client,
>  	if (have_event) {
>  		*event =3D client->buffer[client->tail++];
>  		client->tail &=3D client->bufsize - 1;
> +		if (client->wakeup_source &&
> +		    client->packet_head =3D=3D client->tail)
> +			__pm_relax(client->wakeup_source);
>  	}
> =20
>  	spin_unlock_irq(&client->buffer_lock);
> @@ -623,6 +635,48 @@ static int evdev_handle_set_keycode_v2(struct input_=
dev *dev, void __user *p)
>  	return input_set_keycode(dev, &ke);
>  }
> =20
> +static int evdev_enable_suspend_block(struct evdev *evdev,
> +				      struct evdev_client *client)
> +{
> +	struct wakeup_source *ws;
> +	char name[28];
> +
> +	if (client->wakeup_source)
> +		return 0;
> +
> +	snprintf(name, sizeof(name), "%s-%d",
> +		 dev_name(&evdev->dev), task_tgid_vnr(current));
> +
> +	ws =3D wakeup_source_register(name);
> +	if (!ws)
> +		return -ENOMEM;
> +
> +	spin_lock_irq(&client->buffer_lock);
> +	client->wakeup_source =3D ws;
> +	if (client->packet_head !=3D client->tail)
> +		__pm_stay_awake(client->wakeup_source);
> +	spin_unlock_irq(&client->buffer_lock);
> +	return 0;
> +}
> +
> +static int evdev_disable_suspend_block(struct evdev *evdev,
> +				       struct evdev_client *client)
> +{
> +	struct wakeup_source *ws;
> +
> +	spin_lock_irq(&client->buffer_lock);
> +	ws =3D client->wakeup_source;
> +	client->wakeup_source =3D NULL;
> +	spin_unlock_irq(&client->buffer_lock);
> +
> +	if (ws) {
> +		__pm_relax(ws);
> +		wakeup_source_unregister(ws);
> +	}
> +
> +	return 0;
> +}
> +
>  static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  			   void __user *p, int compat_mode)
>  {
> @@ -696,6 +750,15 @@ static long evdev_do_ioctl(struct file *file, unsign=
ed int cmd,
> =20
>  	case EVIOCSKEYCODE_V2:
>  		return evdev_handle_set_keycode_v2(dev, p);
> +
> +	case EVIOCGSUSPENDBLOCK:
> +		return put_user(!!client->wakeup_source, ip);
> +
> +	case EVIOCSSUSPENDBLOCK:
> +		if (p)
> +			return evdev_enable_suspend_block(evdev, client);
> +		else
> +			return evdev_disable_suspend_block(evdev, client);
>  	}
> =20
>  	size =3D _IOC_SIZE(cmd);
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 3862e32..daf0177 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -129,6 +129,9 @@ struct input_keymap_entry {
> =20
>  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
> =20
> +#define EVIOCGSUSPENDBLOCK	_IOR('E', 0x91, int)			/* get suspend block e=
nable */
> +#define EVIOCSSUSPENDBLOCK	_IOW('E', 0x91, int)			/* set suspend block e=
nable */
> +
>  /*
>   * Device properties and quirks
>   */


--Sig_/y+2oHrFEcRwe_6A.wbJvyv5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTznUNDnsnt1WYoG5AQLGMhAAq9iwC9Xgbik4dBP1DdBTgqziW0v3nzrG
UXkEaySjuzw3xza8ElNYEcdTZO5Q0h3jDK0yL02VeuefQ0oUGCBhCm8v7ZNdh76i
HKDKE/Sd2/tmh5eDERVX+QrBbkWx2jcagP+C31fT5YFK8PLZGTTeMa4QDIwlaNKG
Vv52hNYifvX+wCoByBJkGjVAS2tlUgAqHTz9zXZx/20L15BTkz/lfyreiUic2DS6
UOvMP3ik4OSg+kECer88kLetWceaE783TF07saw2S14/8Uj+AVKRD2fT4oz2P8WD
MFEOuRTBUt4hD/DcUQ6FJtzNjP3NEijKx0mov/pvJokogEV+S8IlR8WB6gNSys6o
lo4+FuxNwUk65ZpKloIOA1imA0ekDcfDV/TxFwb7RkW3eXPm4oiTBnnLw2b3g1EC
pRR6AbDoZA/4IvIEXc2NX++QKabng+x7F7ewDjqbOEqublxHxocfdL3rMhAhk0O6
FtXdIkq7kajQIn5rPTJFMo1A1HsOvUAxIIPwSbVOfklv0y9Z+7W5DOSFT6/y2xIp
8Nzc8kEwtEP/Q710GSxTUL4jd1Erjq9x6HLIgrpFJSldq6fZ2ts1IoVQrjiynkHu
YnOUt82UbGnbGHxjDxY82bRosx5xzgUU806vWIs3h3I27G8pcuIj3AK2YJQqRf6m
9l2ZbDZ6sAc=
=d7Ow
-----END PGP SIGNATURE-----

--Sig_/y+2oHrFEcRwe_6A.wbJvyv5--
