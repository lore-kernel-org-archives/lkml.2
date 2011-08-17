Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1HQI0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:26:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1HQI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:26:05 -0400
Message-ID: <4E4B7B18.2080108@gmail.com>
Date: Wed, 17 Aug 2011 10:26:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] TTY: pty, fix pty counting
References: <1312981168-17039-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1312981168-17039-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, any comments on this?

On 08/10/2011 02:59 PM, Jiri Slaby wrote:
> tty_operations->remove is normally called like:
> queue_release_one_tty
>  ->tty_shutdown
>    ->tty_driver_remove_tty
>      ->tty_operations->remove
> 
> However tty_shutdown() is called from queue_release_one_tty() only if
> tty_operations->shutdown is NULL. But for pty, it is not.
> pty_unix98_shutdown() is used there as ->shutdown.
> 
> So tty_operations->remove of pty (i.e. pty_unix98_remove()) is never
> called. This results in invalid pty_count. I.e. what can be seen in
> /proc/sys/kernel/pty/nr.
> 
> I see this was already reported at:
>   https://lkml.org/lkml/2009/11/5/370
> But it was not fixed since then.
> 
> This patch is kind of a hackish way. The problem lies in ->install. We
> allocate there another tty (so-called tty->link). So ->install is
> called once, but ->remove twice, for both tty and tty->link. The fix
> here is to count both tty and tty->link and divide the count by 2 for
> user.
> 
> And to have ->remove called, let's make tty_driver_remove_tty() global
> and call that from pty_unix98_shutdown() (tty_operations->shutdown).
> 
> While at it, let's document that when ->shutdown is defined,
> tty_shutdown() is not called.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  drivers/tty/pty.c          |   17 +++++++++++++++--
>  drivers/tty/tty_io.c       |    3 +--
>  include/linux/tty.h        |    2 ++
>  include/linux/tty_driver.h |    3 +++
>  4 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index 98b6e3b..e809e9d 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -446,8 +446,19 @@ static inline void legacy_pty_init(void) { }
>  int pty_limit = NR_UNIX98_PTY_DEFAULT;
>  static int pty_limit_min;
>  static int pty_limit_max = NR_UNIX98_PTY_MAX;
> +static int tty_count;
>  static int pty_count;
>  
> +static inline void pty_inc_count(void)
> +{
> +	pty_count = (++tty_count) / 2;
> +}
> +
> +static inline void pty_dec_count(void)
> +{
> +	pty_count = (--tty_count) / 2;
> +}
> +
>  static struct cdev ptmx_cdev;
>  
>  static struct ctl_table pty_table[] = {
> @@ -542,6 +553,7 @@ static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver,
>  
>  static void pty_unix98_shutdown(struct tty_struct *tty)
>  {
> +	tty_driver_remove_tty(tty->driver, tty);
>  	/* We have our own method as we don't use the tty index */
>  	kfree(tty->termios);
>  }
> @@ -588,7 +600,8 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
>  	 */
>  	tty_driver_kref_get(driver);
>  	tty->count++;
> -	pty_count++;
> +	pty_inc_count(); /* tty */
> +	pty_inc_count(); /* tty->link */
>  	return 0;
>  err_free_mem:
>  	deinitialize_tty_struct(o_tty);
> @@ -602,7 +615,7 @@ err_free_tty:
>  
>  static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
>  {
> -	pty_count--;
> +	pty_dec_count();
>  }
>  
>  static const struct tty_operations ptm_unix98_ops = {
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 150e4f7..4f1fc81 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1295,8 +1295,7 @@ static int tty_driver_install_tty(struct tty_driver *driver,
>   *
>   *	Locking: tty_mutex for now
>   */
> -static void tty_driver_remove_tty(struct tty_driver *driver,
> -						struct tty_struct *tty)
> +void tty_driver_remove_tty(struct tty_driver *driver, struct tty_struct *tty)
>  {
>  	if (driver->ops->remove)
>  		driver->ops->remove(driver, tty);
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 6d5eceb..a7720a4 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -421,6 +421,8 @@ extern void tty_driver_flush_buffer(struct tty_struct *tty);
>  extern void tty_throttle(struct tty_struct *tty);
>  extern void tty_unthrottle(struct tty_struct *tty);
>  extern int tty_do_resize(struct tty_struct *tty, struct winsize *ws);
> +extern void tty_driver_remove_tty(struct tty_driver *driver,
> +				  struct tty_struct *tty);
>  extern void tty_shutdown(struct tty_struct *tty);
>  extern void tty_free_termios(struct tty_struct *tty);
>  extern int is_current_pgrp_orphaned(void);
> diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
> index 9deeac8..ecdaeb9 100644
> --- a/include/linux/tty_driver.h
> +++ b/include/linux/tty_driver.h
> @@ -47,6 +47,9 @@
>   *
>   * 	This routine is called synchronously when a particular tty device
>   *	is closed for the last time freeing up the resources.
> + *	Note that tty_shutdown() is not called if ops->shutdown is defined.
> + *	This means one is responsible to take care of calling ops->remove (e.g.
> + *	via tty_driver_remove_tty) and releasing tty->termios.
>   *
>   *
>   * void (*cleanup)(struct tty_struct * tty);


-- 
js
