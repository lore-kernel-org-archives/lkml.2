Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2BLNBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 08:01:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33534 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2BLNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 08:01:13 -0500
Message-ID: <4F37B815.8060701@suse.cz>
Date: Sun, 12 Feb 2012 14:01:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120129 Thunderbird/10.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] um: Use tty_port
References: <1329006070-4275-1-git-send-email-richard@nod.at> <4F3706C4.2070102@nod.at>
In-Reply-To: <4F3706C4.2070102@nod.at>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 01:24 AM, Richard Weinberger wrote:
>> @@ -228,92 +238,6 @@ void line_set_termios(struct tty_struct *tty, struct ktermios * old)
>>  	/* nothing */
>>  }
>>  
>> -static const struct {
>> -	int  cmd;
>> -	char *level;
>> -	char *name;
>> -} tty_ioctls[] = {
>> -	/* don't print these, they flood the log ... */
>> -	{ TCGETS,      NULL,       "TCGETS"      },
>> -	{ TCSETS,      NULL,       "TCSETS"      },
>> -	{ TCSETSW,     NULL,       "TCSETSW"     },
>> -	{ TCFLSH,      NULL,       "TCFLSH"      },
>> -	{ TCSBRK,      NULL,       "TCSBRK"      },
>> -
>> -	/* general tty stuff */
>> -	{ TCSETSF,     KERN_DEBUG, "TCSETSF"     },
>> -	{ TCGETA,      KERN_DEBUG, "TCGETA"      },
>> -	{ TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
>> -	{ TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
>> -	{ TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
>> -
>> -	/* linux-specific ones */
>> -	{ TIOCLINUX,   KERN_INFO,  "TIOCLINUX"   },
>> -	{ KDGKBMODE,   KERN_INFO,  "KDGKBMODE"   },
>> -	{ KDGKBTYPE,   KERN_INFO,  "KDGKBTYPE"   },
>> -	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
>> -};
>> -
>> -int line_ioctl(struct tty_struct *tty, unsigned int cmd,
>> -				unsigned long arg)
>> -{
>> -	int ret;
>> -	int i;
>> -
>> -	ret = 0;
>> -	switch(cmd) {
>> -#ifdef TIOCGETP
>> -	case TIOCGETP:
>> -	case TIOCSETP:
>> -	case TIOCSETN:
>> -#endif
>> -#ifdef TIOCGETC
>> -	case TIOCGETC:
>> -	case TIOCSETC:
>> -#endif
>> -#ifdef TIOCGLTC
>> -	case TIOCGLTC:
>> -	case TIOCSLTC:
>> -#endif
>> -	/* Note: these are out of date as we now have TCGETS2 etc but this
>> -	   whole lot should probably go away */
>> -	case TCGETS:
>> -	case TCSETSF:
>> -	case TCSETSW:
>> -	case TCSETS:
>> -	case TCGETA:
>> -	case TCSETAF:
>> -	case TCSETAW:
>> -	case TCSETA:
>> -	case TCXONC:
>> -	case TCFLSH:
>> -	case TIOCOUTQ:
>> -	case TIOCINQ:
>> -	case TIOCGLCKTRMIOS:
>> -	case TIOCSLCKTRMIOS:
>> -	case TIOCPKT:
>> -	case TIOCGSOFTCAR:
>> -	case TIOCSSOFTCAR:
>> -		return -ENOIOCTLCMD;
>> -#if 0
>> -	case TCwhatever:
>> -		/* do something */
>> -		break;
>> -#endif
>> -	default:
>> -		for (i = 0; i < ARRAY_SIZE(tty_ioctls); i++)
>> -			if (cmd == tty_ioctls[i].cmd)
>> -				break;
>> -		if (i == ARRAY_SIZE(tty_ioctls)) {
>> -			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
>> -			       __func__, tty->name, cmd);
>> -		}
>> -		ret = -ENOIOCTLCMD;
>> -		break;
>> -	}
>> -	return ret;
>> -}
>> -
>>  void line_throttle(struct tty_struct *tty)
>>  {
>>  	struct line *line = tty->driver_data;
>> @@ -343,7 +267,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>>  {
>>  	struct chan *chan = data;
>>  	struct line *line = chan->line;
>> -	struct tty_struct *tty = line->tty;
>> +	struct tty_struct *tty = tty_port_tty_get(&line->port);
>>  	int err;
>>  
>>  	/*
>> @@ -354,6 +278,9 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>>  	spin_lock(&line->lock);
>>  	err = flush_buffer(line);
>>  	if (err == 0) {
>> +		tty_kref_put(tty);
>> +
>> +		spin_unlock(&line->lock);

This and the ioctl change above fullfils the subject of the patch in no
way. Do this fix and the cleanup above separately, please.

>> @@ -404,27 +334,27 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
>>   * first open or last close.  Otherwise, open and close just return.
>>   */
>>  
>> -int line_open(struct line *lines, struct tty_struct *tty)
>> +int line_open(struct tty_struct *tty, struct file *filp)
>>  {
>> -	struct line *line = &lines[tty->index];
>> -	int err = -ENODEV;
>> +	struct line *line = tty->driver_data;
>> +	return tty_port_open(&line->port, tty, filp);
>> +}
>>  
>> -	spin_lock(&line->count_lock);
>> -	if (!line->valid)
>> -		goto out_unlock;
>> +int line_install(struct tty_driver *driver, struct tty_struct *tty, struct line *line)

As it stands, it should be tty_port->ops->activate, not
tty->ops->install. Yes, you can still set driver_data and check for
multiple opens in install. Then use also tty_standard_install.

>> +{
>> +	int ret = tty_init_termios(tty);
>>  
>> -	err = 0;
>> -	if (line->count++)
>> -		goto out_unlock;
>> +	if (ret)
>> +		return ret;
>>  
>> -	BUG_ON(tty->driver_data);
>> +	tty_driver_kref_get(driver);
>> +	tty->count++;
>>  	tty->driver_data = line;
>> -	line->tty = tty;
>> +	driver->ttys[tty->index] = tty;
>>  
>> -	spin_unlock(&line->count_lock);
>> -	err = enable_chan(line);
>> -	if (err) /* line_close() will be called by our caller */
>> -		return err;
>> +	ret = enable_chan(line);
>> +	if (ret)
>> +		return ret;
>>  
>>  	INIT_DELAYED_WORK(&line->task, line_timer_cb);
>>  
>> @@ -437,48 +367,36 @@ int line_open(struct line *lines, struct tty_struct *tty)
>>  			 &tty->winsize.ws_col);
>>  
>>  	return 0;
>> -
>> -out_unlock:
>> -	spin_unlock(&line->count_lock);
>> -	return err;
>>  }
...
>> +void line_close(struct tty_struct *tty, struct file * filp)
>> +{
>> +	struct line *line = tty->driver_data;
>> +
>> +	if (!line)
>> +		return;

Unless you set tty->driver_data to NULL somewhere, this can never
happen. If you do, why -- this tends to be racy?

>> +	tty_port_close(&line->port, tty, filp);
>> +}
...
>> --- a/arch/um/drivers/ssl.c
>> +++ b/arch/um/drivers/ssl.c
>> @@ -92,6 +92,7 @@ static int ssl_remove(int n, char **error_out)
>>  			   error_out);
>>  }
>>  
>> +#if 0

Hmm, remove unused code instead.

>>  static int ssl_open(struct tty_struct *tty, struct file *filp)
>>  {
>>  	int err = line_open(serial_lines, tty);
...
>> @@ -124,8 +124,16 @@ void ssl_hangup(struct tty_struct *tty)
>>  }
>>  #endif
>>  
>> +static int ssl_install(struct tty_driver *driver, struct tty_struct *tty)
>> +{
>> +	if (tty->index < NR_PORTS)

Do you register more than NR_PORTS when allocating tty_driver? If not,
this test is always true. But presumably you won't need this hook anyway.

>> +		return line_install(driver, tty, &serial_lines[tty->index]);
>> +	else
>> +		return -ENODEV;
>> +}

thanks,
-- 
js
suse labs
