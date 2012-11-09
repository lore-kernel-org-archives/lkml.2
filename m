Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2KITe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:34:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40691 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2KITeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:34:25 -0500
Date: Fri, 9 Nov 2012 11:34:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?ISO-8859-15?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings (Patch v3)
In-Reply-To: <20121108143408.77033416@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1211091133310.3733@eggly.anvils>
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk> <20121106164214.GA18246@redhat.com> <20121106173845.4a50d661@pyramind.ukuu.org.uk>
 <509A665C.3030603@gmail.com> <20121107160232.18e83ee9@pyramind.ukuu.org.uk> <87625h9yoe.fsf@nemi.mork.no> <20121108143408.77033416@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-366972020-1352489670=:3733"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-366972020-1352489670=:3733
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 8 Nov 2012, Alan Cox wrote:
> commit f35b3fbf24c4e4debb6a7a864b09854ccc2a22e7
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Wed Nov 7 16:35:08 2012 +0000
>=20
>     fb: Rework locking to fix lock ordering on takeover
>    =20
>     Adjust the console layer to allow a take over call where the caller a=
lready
>     holds the locks. Make the fb layer lock in order.
>    =20
>     This s partly a band aid, the fb layer is terminally confused about t=
he
>     locking rules it uses for its notifiers it seems.
>    =20
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

This version works for me too - thanks.
Hugh

>=20
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index f87d7e8..77bf205 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -2984,7 +2984,7 @@ int __init vty_init(const struct file_operations *c=
onsole_fops)
> =20
>  static struct class *vtconsole_class;
> =20
> -static int bind_con_driver(const struct consw *csw, int first, int last,
> +static int do_bind_con_driver(const struct consw *csw, int first, int la=
st,
>  =09=09=09   int deflt)
>  {
>  =09struct module *owner =3D csw->owner;
> @@ -2995,7 +2995,7 @@ static int bind_con_driver(const struct consw *csw,=
 int first, int last,
>  =09if (!try_module_get(owner))
>  =09=09return -ENODEV;
> =20
> -=09console_lock();
> +=09WARN_CONSOLE_UNLOCKED();
> =20
>  =09/* check if driver is registered */
>  =09for (i =3D 0; i < MAX_NR_CON_DRIVER; i++) {
> @@ -3080,11 +3080,22 @@ static int bind_con_driver(const struct consw *cs=
w, int first, int last,
> =20
>  =09retval =3D 0;
>  err:
> -=09console_unlock();
>  =09module_put(owner);
>  =09return retval;
>  };
> =20
> +
> +static int bind_con_driver(const struct consw *csw, int first, int last,
> +=09=09=09   int deflt)
> +{
> +=09int ret;
> +=09
> +=09console_lock();
> +=09ret =3D do_bind_con_driver(csw, first, last, deflt);
> +=09console_unlock();
> +=09return ret;
> +}
> +=09
>  #ifdef CONFIG_VT_HW_CONSOLE_BINDING
>  static int con_is_graphics(const struct consw *csw, int first, int last)
>  {
> @@ -3196,9 +3207,9 @@ int unbind_con_driver(const struct consw *csw, int =
first, int last, int deflt)
>  =09if (!con_is_bound(csw))
>  =09=09con_driver->flag &=3D ~CON_DRIVER_FLAG_INIT;
> =20
> -=09console_unlock();
>  =09/* ignore return value, binding should not fail */
> -=09bind_con_driver(defcsw, first, last, deflt);
> +=09do_bind_con_driver(defcsw, first, last, deflt);
> +=09console_unlock();
>  err:
>  =09module_put(owner);
>  =09return retval;
> @@ -3489,28 +3500,18 @@ int con_debug_leave(void)
>  }
>  EXPORT_SYMBOL_GPL(con_debug_leave);
> =20
> -/**
> - * register_con_driver - register console driver to console layer
> - * @csw: console driver
> - * @first: the first console to take over, minimum value is 0
> - * @last: the last console to take over, maximum value is MAX_NR_CONSOLE=
S -1
> - *
> - * DESCRIPTION: This function registers a console driver which can later
> - * bind to a range of consoles specified by @first and @last. It will
> - * also initialize the console driver by calling con_startup().
> - */
> -int register_con_driver(const struct consw *csw, int first, int last)
> +static int do_register_con_driver(const struct consw *csw, int first, in=
t last)
>  {
>  =09struct module *owner =3D csw->owner;
>  =09struct con_driver *con_driver;
>  =09const char *desc;
>  =09int i, retval =3D 0;
> =20
> +=09WARN_CONSOLE_UNLOCKED();
> +
>  =09if (!try_module_get(owner))
>  =09=09return -ENODEV;
> =20
> -=09console_lock();
> -
>  =09for (i =3D 0; i < MAX_NR_CON_DRIVER; i++) {
>  =09=09con_driver =3D &registered_con_driver[i];
> =20
> @@ -3563,10 +3564,29 @@ int register_con_driver(const struct consw *csw, =
int first, int last)
>  =09}
> =20
>  err:
> -=09console_unlock();
>  =09module_put(owner);
>  =09return retval;
>  }
> +
> +/**
> + * register_con_driver - register console driver to console layer
> + * @csw: console driver
> + * @first: the first console to take over, minimum value is 0
> + * @last: the last console to take over, maximum value is MAX_NR_CONSOLE=
S -1
> + *
> + * DESCRIPTION: This function registers a console driver which can later
> + * bind to a range of consoles specified by @first and @last. It will
> + * also initialize the console driver by calling con_startup().
> + */
> +int register_con_driver(const struct consw *csw, int first, int last)
> +{
> +=09int retval;
> +=09
> +=09console_lock();
> +=09retval =3D do_register_con_driver(csw, first, last);
> +=09console_unlock();
> +=09return retval;
> +}
>  EXPORT_SYMBOL(register_con_driver);
> =20
>  /**
> @@ -3622,6 +3642,29 @@ EXPORT_SYMBOL(unregister_con_driver);
>   *
>   *      take_over_console is basically a register followed by unbind
>   */
> +int do_take_over_console(const struct consw *csw, int first, int last, i=
nt deflt)
> +{
> +=09int err;
> +
> +=09err =3D do_register_con_driver(csw, first, last);
> +=09/* if we get an busy error we still want to bind the console driver
> +=09 * and return success, as we may have unbound the console driver
> +=09=A0* but not unregistered it.
> +=09*/
> +=09if (err =3D=3D -EBUSY)
> +=09=09err =3D 0;
> +=09if (!err)
> +=09=09do_bind_con_driver(csw, first, last, deflt);
> +
> +=09return err;
> +}
> +/*
> + *=09If we support more console drivers, this function is used
> + *=09when a driver wants to take over some existing consoles
> + *=09and become default driver for newly opened ones.
> + *
> + *      take_over_console is basically a register followed by unbind
> + */
>  int take_over_console(const struct consw *csw, int first, int last, int =
deflt)
>  {
>  =09int err;
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.=
c
> index fdefa8f..c75f8ce 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -529,6 +529,34 @@ static int search_for_mapped_con(void)
>  =09return retval;
>  }
> =20
> +static int do_fbcon_takeover(int show_logo)
> +{
> +=09int err, i;
> +
> +=09if (!num_registered_fb)
> +=09=09return -ENODEV;
> +
> +=09if (!show_logo)
> +=09=09logo_shown =3D FBCON_LOGO_DONTSHOW;
> +
> +=09for (i =3D first_fb_vc; i <=3D last_fb_vc; i++)
> +=09=09con2fb_map[i] =3D info_idx;
> +
> +=09err =3D do_take_over_console(&fb_con, first_fb_vc, last_fb_vc,
> +=09=09=09=09fbcon_is_default);
> +
> +=09if (err) {
> +=09=09for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
> +=09=09=09con2fb_map[i] =3D -1;
> +=09=09}
> +=09=09info_idx =3D -1;
> +=09} else {
> +=09=09fbcon_has_console_bind =3D 1;
> +=09}
> +
> +=09return err;
> +}
> +
>  static int fbcon_takeover(int show_logo)
>  {
>  =09int err, i;
> @@ -3115,7 +3143,7 @@ static int fbcon_fb_registered(struct fb_info *info=
)
>  =09=09}
> =20
>  =09=09if (info_idx !=3D -1)
> -=09=09=09ret =3D fbcon_takeover(1);
> +=09=09=09ret =3D do_fbcon_takeover(1);
>  =09} else {
>  =09=09for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
>  =09=09=09if (con2fb_map_boot[i] =3D=3D idx)
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 3ff0105..564ebe9 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1650,7 +1650,9 @@ static int do_register_framebuffer(struct fb_info *=
fb_info)
>  =09event.info =3D fb_info;
>  =09if (!lock_fb_info(fb_info))
>  =09=09return -ENODEV;
> +        console_lock();
>  =09fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> +        console_unlock();
>  =09unlock_fb_info(fb_info);
>  =09return 0;
>  }
> @@ -1853,11 +1855,8 @@ int fb_new_modelist(struct fb_info *info)
>  =09err =3D 1;
> =20
>  =09if (!list_empty(&info->modelist)) {
> -=09=09if (!lock_fb_info(info))
> -=09=09=09return -ENODEV;
>  =09=09event.info =3D info;
>  =09=09err =3D fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
> -=09=09unlock_fb_info(info);
>  =09}
> =20
>  =09return err;
> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> index a55e366..ef476b0 100644
> --- a/drivers/video/fbsysfs.c
> +++ b/drivers/video/fbsysfs.c
> @@ -177,6 +177,8 @@ static ssize_t store_modes(struct device *device,
>  =09if (i * sizeof(struct fb_videomode) !=3D count)
>  =09=09return -EINVAL;
> =20
> +=09if (!lock_fb_info(fb_info))
> +=09=09return -ENODEV;
>  =09console_lock();
>  =09list_splice(&fb_info->modelist, &old_list);
>  =09fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
> @@ -188,6 +190,7 @@ static ssize_t store_modes(struct device *device,
>  =09=09fb_destroy_modelist(&old_list);
> =20
>  =09console_unlock();
> +=09unlock_fb_info(fb_info);
> =20
>  =09return 0;
>  }
> diff --git a/include/linux/console.h b/include/linux/console.h
> index dedb082..4ef4307 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -78,6 +78,7 @@ int con_is_bound(const struct consw *csw);
>  int register_con_driver(const struct consw *csw, int first, int last);
>  int unregister_con_driver(const struct consw *csw);
>  int take_over_console(const struct consw *sw, int first, int last, int d=
eflt);
> +int do_take_over_console(const struct consw *sw, int first, int last, in=
t deflt);
>  void give_up_console(const struct consw *sw);
>  #ifdef CONFIG_HW_CONSOLE
>  int con_debug_enter(struct vc_data *vc);
>=20
--8323584-366972020-1352489670=:3733--
