Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2IWBns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:43:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33699 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2IWBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:43:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
References: <20120913095623.GB28508@moon>
	<20120913135131.5b251797@pyramind.ukuu.org.uk>
	<20120913125401.GK19956@moon>
	<20120913172507.5039e3c6@pyramind.ukuu.org.uk>
	<20120922180639.GC11610@moon>
Date: Sat, 22 Sep 2012 18:43:37 -0700
In-Reply-To: <20120922180639.GC11610@moon> (Cyrill Gorcunov's message of "Sat,
	22 Sep 2012 22:06:39 +0400")
Message-ID: <87txupfr92.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18HzXwUGQU+9nZ6gyDf4SbGmaO1eQ3Nfx8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Cyrill Gorcunov <gorcunov@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't know where this conversation comes from but putting ptys in
sysfs in combination with the newinstance mount option is completely
broken unless the device name and device number duplication is handled,
which I don't see here.

Cyrill Gorcunov <gorcunov@openvz.org> writes:
>
> Guys, you mean something like below? Look, I must admit I'm not really
> sure if I've done all locking right, and there is no need for additional
> kref counting on tty_struct. Could you please check if it looks more-less
> sane (I've tested it but still...)
>
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: tty, pty: Add pty_state attribute to fetch tty flags
>
> For checkpoint/restore we need to know if tty has
> exclusive or packet mode set, as well as if pty
> is currently locked (just to be able to restore
> this characteristics).
>
> To serve this the pty_state attribute is introduced
> for pty devices. A typical output looks like
>
>  | [root@neptune ~]# cat /sys/devices/virtual/tty/ptmp0/pty_state
>  | locked: 0 exclusive: 0 packet: 0
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Jiri Slaby <jslaby@suse.cz>
> CC: Pavel Emelyanov <xemul@parallels.com>
> ---
>  drivers/tty/pty.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
>
> Index: tty.git/drivers/tty/pty.c
> ===================================================================
> --- tty.git.orig/drivers/tty/pty.c
> +++ tty.git/drivers/tty/pty.c
> @@ -283,6 +283,46 @@ done:
>  	return 0;
>  }
>  
> +static ssize_t pty_show_state(struct device *dev,
> +			      struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct tty_struct *tty = dev_get_drvdata(dev);
> +	int locked, exclusive, packet;
> +
> +	tty_lock(tty);
> +	locked = test_bit(TTY_PTY_LOCK, &tty->flags);
> +	exclusive = test_bit(TTY_EXCLUSIVE, &tty->flags);
> +	packet = tty->packet;
> +	tty_unlock(tty);
> +
> +	return snprintf(buf, PAGE_SIZE, "locked: %d exclusive: %d packet: %d\n",
> +			locked, exclusive, packet);
> +}
> +
> +static DEVICE_ATTR(pty_state, S_IRUSR | S_IRGRP, pty_show_state, NULL);
> +
> +static struct attribute *pty_state_dev_attrs[] = {
> +	&dev_attr_pty_state.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group pty_dev_attr_group = {
> +	.attrs = pty_state_dev_attrs,
> +};
> +
> +static const struct attribute_group *pty_dev_attr_groups[] = {
> +	&pty_dev_attr_group,
> +	NULL,
> +};
> +
> +static int pty_register_attr(struct tty_driver *driver, struct tty_struct *tty)
> +{
> +	struct device *dev = tty_register_device_attr(driver, tty->index, tty->dev,
> +						      (void *)tty, pty_dev_attr_groups);
> +	return PTR_RET(dev);
> +}
> +
>  /**
>   *	pty_common_install		-	set up the pty pair
>   *	@driver: the pty driver
> @@ -351,7 +391,9 @@ static int pty_common_install(struct tty
>  
>  	tty_driver_kref_get(driver);
>  	tty->count++;
> -	return 0;
> +
> +	return pty_register_attr(driver, tty);
> +
>  err_free_termios:
>  	if (legacy)
>  		tty_free_termios(tty);
> @@ -368,6 +410,7 @@ err:
>  
>  static void pty_cleanup(struct tty_struct *tty)
>  {
> +	tty_unregister_device(tty->driver, tty->index);
>  	kfree(tty->port);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
