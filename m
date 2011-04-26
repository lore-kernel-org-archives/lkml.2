Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1DZKvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:51:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53668 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754311Ab1DZKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:51:23 -0400
Date: Tue, 26 Apr 2011 11:52:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jimmy Chen (=?big5?B?s6+lw7lG?=) <jimmy.chen@moxa.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <wim@iguana.be>
Subject: Re: [PATCH 2/2] watchdog: add real function on MOXA V2100 watchdog
 driver
Message-ID: <20110426115222.1a994107@lxorguk.ukuu.org.uk>
In-Reply-To: <ECB3782BB8F03341905DD923270296115F6ADB@mhqms01.moxa.com>
References: <ECB3782BB8F03341905DD923270296115F6AD9@mhqms01.moxa.com>
	<ECB3782BB8F03341905DD923270296115F6ADB@mhqms01.moxa.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	superio_set_logic_device(7);    /* logic device 7 */
> +	superio_set_reg((swtd_ack_time/1000), 0x73);    /* Reg:F6,30 sec */
> +}

If the time is configurable then you want to support that ideally.

> +static void swtd_reboot(void *unused)

No - the watchdog driver needs to deal with hardware reboot, randomly
trying to exec things which may not even be where you expect isn't safe.
User space watchdog daemons can manage their own shutdown just fine. The
watchdog is there to catch the actual hang case.


> +	superio_set_reg(1000/1000, 0x73);
> +
> +	return NOTIFY_OK;
> +
> +	spin_unlock_bh(&swtd_lock);

Wrong order - your lock is left locked !


> +static struct miscdevice wdt_miscdev = {
> +	.minor = MOXA_WATCHDOG_MINOR,
> +	.name = "swtd",
> +	.fops = &moxa_swtd_fops,
> +};

This should use the standard watchdog device


> +moxa_swtd_init_err3:
> +	remove_proc_entry("driver/swtd", NULL);
> +moxa_swtd_init_err2:
> +	if (timer_pending(&timer_swtd))
> +		del_timer(&timer_swtd);

del_timer_sync to ensure it has run

You also need to sort out locking.

There is also no test to ensure the hardware is present so the driver
isn't safe to load on any PC hardware

Is there a magic signature to detect the hardware ?

Alan
