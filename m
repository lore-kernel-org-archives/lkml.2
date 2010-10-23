Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0JWLYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:24:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab0JWLYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UplgsmIexCpzZCmhdPJD+pvAFsnunm+x9nJ73VibgBUSnIA9swpkFHUQWMOa+WTUfr
         72dwlXHgqkPNTv6pQaDdkqabzjiFl7Zf7dby62TaD0eUFKpmbZsrUBNOKFlCC6JcGu2w
         yT/p/BWWcRDmjQuyXjIW+SGfxh7ISaskajZnc=
Message-ID: <4CC2C5FF.5060008@suse.cz>
Date: Sat, 23 Oct 2010 13:24:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-28-git-send-email-gregkh@suse.de>
In-Reply-To: <1287771688-14805-28-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 08:21 PM, Greg Kroah-Hartman wrote:
> --- a/fs/proc/proc_tty.c
> +++ b/fs/proc/proc_tty.c
...
> @@ -137,6 +140,160 @@ static const struct file_operations proc_tty_drivers_operations = {
>  };
>  
>  /*
> + * The device ID of file descriptor 0 of the current reading
> + * task if a character device...
> + */
> +static dev_t current_dev;
> +
> +/*
> + * This is the handler for /proc/tty/consoles
> + */
> +static int show_console_dev(struct seq_file *m, void *v)
> +{
> +	const struct tty_driver *driver;
> +	struct console *con;
> +	int index, len;
> +	char flags[10];
> +	dev_t dev;
> +
> +	if (v == SEQ_START_TOKEN)
> +		return 0;
> +	con = (struct console *)v;

You don't hold the console sem now, so the console may be already gone,
right? You should hold the sem from ->start till ->stop.

> +	if (!con)
> +		return 0;
> +	driver = con->device(con, &index);

Some consoles, especially the early ones don't have con->device IIRC.
If, for some reason, they are not switched to proper ttyS* (e.g. the
port fails to init), this will crash.

> +	if (!driver)
> +		return 0;
> +	dev = MKDEV(driver->major, driver->minor_start) + index;
> +
> +	index = 0;
> +	if (con->flags & CON_ENABLED)
> +		flags[index++] = 'E';
> +	if (con->flags & CON_CONSDEV)
> +		flags[index++] = 'C';
> +	if (con->flags & CON_BOOT)
> +		flags[index++] = 'B';
> +	if (con->flags & CON_PRINTBUFFER)
> +		flags[index++] = 'p';
> +	if (con->flags & CON_BRL)
> +		flags[index++] = 'b';
> +	if (con->flags & CON_ANYTIME)
> +		flags[index++] = 'a';
> +	if (current_dev == dev)
> +		flags[index++] = '*';
> +	flags[index] = 0;
> +
> +	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> +	len = 21 - len;
> +	if (len < 1)
> +		len = 1;
> +	seq_printf(m, "%*c", len, ' ');
> +	seq_printf(m, "%c%c%c (%s)%n", con->read ? 'R' : '-',
> +			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
> +			flags, &len);
> +	len = 13 - len;
> +	if (len < 1)
> +		len = 1;
> +	seq_printf(m, "%*c%4d:%d\n", len, ' ', MAJOR(dev), MINOR(dev));
> +
> +	return 0;
> +}

regards,
-- 
js
suse labs
