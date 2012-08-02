Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2HBKVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:21:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2HBKVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:21:13 -0400
Date: Thu, 2 Aug 2012 11:25:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sjur =?ISO-8859-1?B?QnLmbmRlbGFuZA==?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com
Subject: Re: [RESEND PATCHv5 09/11] modem_shm: Character device for SHM
 channel access.
Message-ID: <20120802112542.6ae3dd8f@pyramind.ukuu.org.uk>
In-Reply-To: <1327999726-8774-10-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
	<1327999726-8774-10-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 09:48:44 +0100
Sjur Brændeland <sjur.brandeland@stericsson.com> wrote:

> Add a character device implementation for the SHM stream channels.
> The character device provides asynchronous IO and ring-buffer handling.
> The device copies data directly from the Shared Memory area into
> user-land buffers.

What is the use case for this - it seems a little odd that it's not using
the tty layer so won't work with all the normal modem apps as anyone
would expect and want ?


> +static unsigned int shmchr_chrpoll(struct file *filp, poll_table *waittab)
> +{
> +	struct shmchr_char_dev *dev = filp->private_data;
> +	unsigned int mask = 0;
> +
> +	if (dev == NULL) {
> +		mdev_dbg(dev, "private_data not set!\n");
> +		return -EBADFD;
> +	}

How can this occur. If it can't occur why check ? BUG_ON() would
certainly be better to as you'd get a trace and it would get captured not
silently ignored and problems never detected.

An if.. dbg sequence to end users is basically "silently pretend we
didn't break and hope", which isn't ideal at all.


> +
> +	/* I want to be alone on dev (except status and queue). */
> +	if (mutex_lock_interruptible(&dev->mutex)) {
> +		mdev_dbg(dev, "mutex_lock_interruptible got signalled\n");
> +		mask |= POLLERR;
> +		goto out_unlocked;

That's very odd behaviour for poll() and may confuse apps. Can the mutex
ever be held for a long time ?

