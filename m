Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2BLAYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 19:24:41 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab2BLAYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 19:24:40 -0500
Message-ID: <4F3706C4.2070102@nod.at>
Date: Sun, 12 Feb 2012 01:24:36 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org
Subject: [PATCH] um: Use tty_port
References: <1329006070-4275-1-git-send-email-richard@nod.at>
In-Reply-To: <1329006070-4275-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8ECC595005C1879C77B26701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8ECC595005C1879C77B26701
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Whoops, I messed up the subject line.

Sorry!

Am 12.02.2012 01:21, schrieb Richard Weinberger:
> Can you please review this patch?
>=20
> Thanks,
> //richard
>=20
> ---
> From d8f5e7953def150bcc1e6a39dbbe589f1c68bcbd Mon Sep 17 00:00:00 2001
> From: Richard Weinberger <richard@nod.at>
> Date: Sun, 12 Feb 2012 01:12:49 +0100
> Subject: [PATCH] um: Use tty_port
>=20
> UML's line driver has to use tty_port.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/drivers/line.c          |  212 +++++++++++--------------------=
-------
>  arch/um/drivers/line.h          |   13 ++-
>  arch/um/drivers/ssl.c           |   16 +++-
>  arch/um/drivers/stdio_console.c |   14 ++-
>  4 files changed, 94 insertions(+), 161 deletions(-)
>=20
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index c1cf220..c789748 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -19,19 +19,29 @@ static irqreturn_t line_interrupt(int irq, void *da=
ta)
>  {
>  	struct chan *chan =3D data;
>  	struct line *line =3D chan->line;
> +	struct tty_struct *tty;
> +
> +	if (line) {
> +		tty =3D tty_port_tty_get(&line->port);
> +		chan_interrupt(&line->chan_list, &line->task, tty, irq);
> +		tty_kref_put(tty);
> +	}
> =20
> -	if (line)
> -		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
>  	return IRQ_HANDLED;
>  }
> =20
>  static void line_timer_cb(struct work_struct *work)
>  {
>  	struct line *line =3D container_of(work, struct line, task.work);
> +	struct tty_struct *tty;
> =20
> -	if (!line->throttled)
> -		chan_interrupt(&line->chan_list, &line->task, line->tty,
> +	if (!line->throttled) {
> +		tty =3D tty_port_tty_get(&line->port);
> +		chan_interrupt(&line->chan_list, &line->task, tty,
>  			       line->driver->read_irq);
> +
> +		tty_kref_put(tty);
> +	}
>  }
> =20
>  /*
> @@ -228,92 +238,6 @@ void line_set_termios(struct tty_struct *tty, stru=
ct ktermios * old)
>  	/* nothing */
>  }
> =20
> -static const struct {
> -	int  cmd;
> -	char *level;
> -	char *name;
> -} tty_ioctls[] =3D {
> -	/* don't print these, they flood the log ... */
> -	{ TCGETS,      NULL,       "TCGETS"      },
> -	{ TCSETS,      NULL,       "TCSETS"      },
> -	{ TCSETSW,     NULL,       "TCSETSW"     },
> -	{ TCFLSH,      NULL,       "TCFLSH"      },
> -	{ TCSBRK,      NULL,       "TCSBRK"      },
> -
> -	/* general tty stuff */
> -	{ TCSETSF,     KERN_DEBUG, "TCSETSF"     },
> -	{ TCGETA,      KERN_DEBUG, "TCGETA"      },
> -	{ TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
> -	{ TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
> -	{ TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
> -
> -	/* linux-specific ones */
> -	{ TIOCLINUX,   KERN_INFO,  "TIOCLINUX"   },
> -	{ KDGKBMODE,   KERN_INFO,  "KDGKBMODE"   },
> -	{ KDGKBTYPE,   KERN_INFO,  "KDGKBTYPE"   },
> -	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
> -};
> -
> -int line_ioctl(struct tty_struct *tty, unsigned int cmd,
> -				unsigned long arg)
> -{
> -	int ret;
> -	int i;
> -
> -	ret =3D 0;
> -	switch(cmd) {
> -#ifdef TIOCGETP
> -	case TIOCGETP:
> -	case TIOCSETP:
> -	case TIOCSETN:
> -#endif
> -#ifdef TIOCGETC
> -	case TIOCGETC:
> -	case TIOCSETC:
> -#endif
> -#ifdef TIOCGLTC
> -	case TIOCGLTC:
> -	case TIOCSLTC:
> -#endif
> -	/* Note: these are out of date as we now have TCGETS2 etc but this
> -	   whole lot should probably go away */
> -	case TCGETS:
> -	case TCSETSF:
> -	case TCSETSW:
> -	case TCSETS:
> -	case TCGETA:
> -	case TCSETAF:
> -	case TCSETAW:
> -	case TCSETA:
> -	case TCXONC:
> -	case TCFLSH:
> -	case TIOCOUTQ:
> -	case TIOCINQ:
> -	case TIOCGLCKTRMIOS:
> -	case TIOCSLCKTRMIOS:
> -	case TIOCPKT:
> -	case TIOCGSOFTCAR:
> -	case TIOCSSOFTCAR:
> -		return -ENOIOCTLCMD;
> -#if 0
> -	case TCwhatever:
> -		/* do something */
> -		break;
> -#endif
> -	default:
> -		for (i =3D 0; i < ARRAY_SIZE(tty_ioctls); i++)
> -			if (cmd =3D=3D tty_ioctls[i].cmd)
> -				break;
> -		if (i =3D=3D ARRAY_SIZE(tty_ioctls)) {
> -			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
> -			       __func__, tty->name, cmd);
> -		}
> -		ret =3D -ENOIOCTLCMD;
> -		break;
> -	}
> -	return ret;
> -}
> -
>  void line_throttle(struct tty_struct *tty)
>  {
>  	struct line *line =3D tty->driver_data;
> @@ -343,7 +267,7 @@ static irqreturn_t line_write_interrupt(int irq, vo=
id *data)
>  {
>  	struct chan *chan =3D data;
>  	struct line *line =3D chan->line;
> -	struct tty_struct *tty =3D line->tty;
> +	struct tty_struct *tty =3D tty_port_tty_get(&line->port);
>  	int err;
> =20
>  	/*
> @@ -354,6 +278,9 @@ static irqreturn_t line_write_interrupt(int irq, vo=
id *data)
>  	spin_lock(&line->lock);
>  	err =3D flush_buffer(line);
>  	if (err =3D=3D 0) {
> +		tty_kref_put(tty);
> +
> +		spin_unlock(&line->lock);
>  		return IRQ_NONE;
>  	} else if (err < 0) {
>  		line->head =3D line->buffer;
> @@ -365,9 +292,12 @@ static irqreturn_t line_write_interrupt(int irq, v=
oid *data)
>  		return IRQ_NONE;
> =20
>  	tty_wakeup(tty);
> +	tty_kref_put(tty);
>  	return IRQ_HANDLED;
>  }
> =20
> +static const struct tty_port_operations line_port_ops;
> +
>  int line_setup_irq(int fd, int input, int output, struct line *line, v=
oid *data)
>  {
>  	const struct line_driver *driver =3D line->driver;
> @@ -404,27 +334,27 @@ int line_setup_irq(int fd, int input, int output,=
 struct line *line, void *data)
>   * first open or last close.  Otherwise, open and close just return.
>   */
> =20
> -int line_open(struct line *lines, struct tty_struct *tty)
> +int line_open(struct tty_struct *tty, struct file *filp)
>  {
> -	struct line *line =3D &lines[tty->index];
> -	int err =3D -ENODEV;
> +	struct line *line =3D tty->driver_data;
> +	return tty_port_open(&line->port, tty, filp);
> +}
> =20
> -	spin_lock(&line->count_lock);
> -	if (!line->valid)
> -		goto out_unlock;
> +int line_install(struct tty_driver *driver, struct tty_struct *tty, st=
ruct line *line)
> +{
> +	int ret =3D tty_init_termios(tty);
> =20
> -	err =3D 0;
> -	if (line->count++)
> -		goto out_unlock;
> +	if (ret)
> +		return ret;
> =20
> -	BUG_ON(tty->driver_data);
> +	tty_driver_kref_get(driver);
> +	tty->count++;
>  	tty->driver_data =3D line;
> -	line->tty =3D tty;
> +	driver->ttys[tty->index] =3D tty;
> =20
> -	spin_unlock(&line->count_lock);
> -	err =3D enable_chan(line);
> -	if (err) /* line_close() will be called by our caller */
> -		return err;
> +	ret =3D enable_chan(line);
> +	if (ret)
> +		return ret;
> =20
>  	INIT_DELAYED_WORK(&line->task, line_timer_cb);
> =20
> @@ -437,48 +367,36 @@ int line_open(struct line *lines, struct tty_stru=
ct *tty)
>  			 &tty->winsize.ws_col);
> =20
>  	return 0;
> -
> -out_unlock:
> -	spin_unlock(&line->count_lock);
> -	return err;
>  }
> =20
>  static void unregister_winch(struct tty_struct *tty);
> =20
> -void line_close(struct tty_struct *tty, struct file * filp)
> +void line_cleanup(struct tty_struct *tty)
>  {
>  	struct line *line =3D tty->driver_data;
> =20
> -	/*
> -	 * If line_open fails (and tty->driver_data is never set),
> -	 * tty_open will call line_close.  So just return in this case.
> -	 */
> -	if (line =3D=3D NULL)
> -		return;
> -
> -	/* We ignore the error anyway! */
> -	flush_buffer(line);
> -
> -	spin_lock(&line->count_lock);
> -	BUG_ON(!line->valid);
> -
> -	if (--line->count)
> -		goto out_unlock;
> -
> -	line->tty =3D NULL;
> -	tty->driver_data =3D NULL;
> -
> -	spin_unlock(&line->count_lock);
> -
>  	if (line->sigio) {
>  		unregister_winch(tty);
>  		line->sigio =3D 0;
>  	}
> =20
> -	return;
> +	tty->driver_data =3D NULL;
> +}
> +
> +void line_close(struct tty_struct *tty, struct file * filp)
> +{
> +	struct line *line =3D tty->driver_data;
> +
> +	if (!line)
> +		return;
> +
> +	tty_port_close(&line->port, tty, filp);
> +}
> =20
> -out_unlock:
> -	spin_unlock(&line->count_lock);
> +void line_hangup(struct tty_struct *tty)
> +{
> +	struct line *line =3D tty->driver_data;
> +	tty_port_hangup(&line->port);
>  }
> =20
>  void close_lines(struct line *lines, int nlines)
> @@ -495,13 +413,6 @@ static int setup_one_line(struct line *lines, int =
n, char *init, int init_prio,
>  	struct line *line =3D &lines[n];
>  	int err =3D -EINVAL;
> =20
> -	spin_lock(&line->count_lock);
> -
> -	if (line->count) {
> -		*error_out =3D "Device is already open";
> -		goto out;
> -	}
> -
>  	if (line->init_pri <=3D init_prio) {
>  		line->init_pri =3D init_prio;
>  		if (!strcmp(init, "none"))
> @@ -512,8 +423,7 @@ static int setup_one_line(struct line *lines, int n=
, char *init, int init_prio,
>  		}
>  	}
>  	err =3D 0;
> -out:
> -	spin_unlock(&line->count_lock);
> +
>  	return err;
>  }
> =20
> @@ -598,6 +508,7 @@ int line_get_config(char *name, struct line *lines,=
 unsigned int num, char *str,
>  	struct line *line;
>  	char *end;
>  	int dev, n =3D 0;
> +	struct tty_struct *tty;
> =20
>  	dev =3D simple_strtoul(name, &end, 0);
>  	if ((*end !=3D '\0') || (end =3D=3D name)) {
> @@ -612,13 +523,15 @@ int line_get_config(char *name, struct line *line=
s, unsigned int num, char *str,
> =20
>  	line =3D &lines[dev];
> =20
> -	spin_lock(&line->count_lock);
> +	tty =3D tty_port_tty_get(&line->port);
> +
>  	if (!line->valid)
>  		CONFIG_CHUNK(str, size, n, "none", 1);
> -	else if (line->tty =3D=3D NULL)
> +	else if (tty =3D=3D NULL)
>  		CONFIG_CHUNK(str, size, n, line->init_str, 1);
>  	else n =3D chan_config_string(&line->chan_list, str, size, error_out)=
;
> -	spin_unlock(&line->count_lock);
> +
> +	tty_kref_put(tty);
> =20
>  	return n;
>  }
> @@ -678,8 +591,8 @@ struct tty_driver *register_lines(struct line_drive=
r *line_driver,
>  	}
> =20
>  	for(i =3D 0; i < nlines; i++) {
> -		if (!lines[i].valid)
> -			tty_unregister_device(driver, i);
> +		tty_port_init(&lines[i].port);
> +		lines[i].port.ops =3D &line_port_ops;
>  	}
> =20
>  	mconsole_register_dev(&line_driver->mc);
> @@ -805,7 +718,6 @@ void register_winch_irq(int fd, int tty_fd, int pid=
, struct tty_struct *tty,
>  				   .pid  	=3D pid,
>  				   .tty 	=3D tty,
>  				   .stack	=3D stack });
> -
>  	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
>  			   IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
>  			   "winch", winch) < 0) {
> diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
> index 63df3ca..54adfc6 100644
> --- a/arch/um/drivers/line.h
> +++ b/arch/um/drivers/line.h
> @@ -31,9 +31,8 @@ struct line_driver {
>  };
> =20
>  struct line {
> -	struct tty_struct *tty;
> -	spinlock_t count_lock;
> -	unsigned long count;
> +	struct tty_port port;
> +
>  	int valid;
> =20
>  	char *init_str;
> @@ -59,15 +58,17 @@ struct line {
>  };
> =20
>  #define LINE_INIT(str, d) \
> -	{ .count_lock =3D	__SPIN_LOCK_UNLOCKED((str).count_lock), \
> -	  .init_str =3D	str,	\
> +	{ .init_str =3D	str,	\
>  	  .init_pri =3D	INIT_STATIC, \
>  	  .valid =3D	1, \
>  	  .lock =3D	__SPIN_LOCK_UNLOCKED((str).lock), \
>  	  .driver =3D	d }
> =20
>  extern void line_close(struct tty_struct *tty, struct file * filp);
> -extern int line_open(struct line *lines, struct tty_struct *tty);
> +extern int line_open(struct tty_struct *tty, struct file *filp);
> +extern int line_install(struct tty_driver *driver, struct tty_struct *=
tty, struct line *line);
> +extern void line_cleanup(struct tty_struct *tty);
> +extern void line_hangup(struct tty_struct *tty);
>  extern int line_setup(struct line *lines, unsigned int sizeof_lines,
>  		      char *init, char **error_out);
>  extern int line_write(struct tty_struct *tty, const unsigned char *buf=
,
> diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
> index 9d8c20a..89e4e75 100644
> --- a/arch/um/drivers/ssl.c
> +++ b/arch/um/drivers/ssl.c
> @@ -92,6 +92,7 @@ static int ssl_remove(int n, char **error_out)
>  			   error_out);
>  }
> =20
> +#if 0
>  static int ssl_open(struct tty_struct *tty, struct file *filp)
>  {
>  	int err =3D line_open(serial_lines, tty);
> @@ -103,7 +104,6 @@ static int ssl_open(struct tty_struct *tty, struct =
file *filp)
>  	return err;
>  }
> =20
> -#if 0
>  static void ssl_flush_buffer(struct tty_struct *tty)
>  {
>  	return;
> @@ -124,8 +124,16 @@ void ssl_hangup(struct tty_struct *tty)
>  }
>  #endif
> =20
> +static int ssl_install(struct tty_driver *driver, struct tty_struct *t=
ty)
> +{
> +	if (tty->index < NR_PORTS)
> +		return line_install(driver, tty, &serial_lines[tty->index]);
> +	else
> +		return -ENODEV;
> +}
> +
>  static const struct tty_operations ssl_ops =3D {
> -	.open 	 		=3D ssl_open,
> +	.open 	 		=3D line_open,
>  	.close 	 		=3D line_close,
>  	.write 	 		=3D line_write,
>  	.put_char 		=3D line_put_char,
> @@ -134,9 +142,11 @@ static const struct tty_operations ssl_ops =3D {
>  	.flush_buffer 		=3D line_flush_buffer,
>  	.flush_chars 		=3D line_flush_chars,
>  	.set_termios 		=3D line_set_termios,
> -	.ioctl 	 		=3D line_ioctl,
>  	.throttle 		=3D line_throttle,
>  	.unthrottle 		=3D line_unthrottle,
> +	.install		=3D ssl_install,
> +	.cleanup		=3D line_cleanup,
> +	.hangup			=3D line_hangup,
>  #if 0
>  	.stop 	 		=3D ssl_stop,
>  	.start 	 		=3D ssl_start,
> diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_co=
nsole.c
> index 088776f..014f3ee 100644
> --- a/arch/um/drivers/stdio_console.c
> +++ b/arch/um/drivers/stdio_console.c
> @@ -97,7 +97,7 @@ static int con_remove(int n, char **error_out)
> =20
>  static int con_open(struct tty_struct *tty, struct file *filp)
>  {
> -	int err =3D line_open(vts, tty);
> +	int err =3D line_open(tty, filp);
>  	if (err)
>  		printk(KERN_ERR "Failed to open console %d, err =3D %d\n",
>  		       tty->index, err);
> @@ -105,6 +105,14 @@ static int con_open(struct tty_struct *tty, struct=
 file *filp)
>  	return err;
>  }
> =20
> +static int con_install(struct tty_driver *driver, struct tty_struct *t=
ty)
> +{
> +	if (tty->index < MAX_TTYS)
> +		return line_install(driver, tty, &vts[tty->index]);
> +	else
> +		return -ENODEV;
> +}
> +
>  /* Set in an initcall, checked in an exitcall */
>  static int con_init_done =3D 0;
> =20
> @@ -118,9 +126,11 @@ static const struct tty_operations console_ops =3D=
 {
>  	.flush_buffer 		=3D line_flush_buffer,
>  	.flush_chars 		=3D line_flush_chars,
>  	.set_termios 		=3D line_set_termios,
> -	.ioctl 	 		=3D line_ioctl,
>  	.throttle 		=3D line_throttle,
>  	.unthrottle 		=3D line_unthrottle,
> +	.cleanup		=3D line_cleanup,
> +	.install		=3D con_install,
> +	.hangup			=3D line_hangup,
>  };
> =20
>  static void uml_console_write(struct console *console, const char *str=
ing,



--------------enig8ECC595005C1879C77B26701
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPNwbEAAoJEN9758yqZn9elFYH/0TofjVGzIhDWb3CzxOdGnSN
n+kml0T4g2xdhq1+tkSgxDzJNNLafyzmyTi0pc52EFeGvQq1rMivhbMsotUhrSkZ
jEdk4o6OBcD+o98WQNeRPnzAiRqgG1nfwq9tXyaFBcDI4jLje75MOJXS+c9gwJhY
u30tFkZy5jRt1tQTavh0gCsUfnJ4VTWy06aEWS8q9zUD83uK39blpAJugnmfDB84
clAwEWSgy6UgcnYy5YnDRC1vdQtEWuzJq5DiKwEQfXj/tYaVbmBOjhQf0XDU62C0
/Ft0EWfTZRM4weqQfaeq7lNNIiT+oNVhe094h8Mg4KRMQTH54P8G7XT9IPtwhB4=
=E9vl
-----END PGP SIGNATURE-----

--------------enig8ECC595005C1879C77B26701--
