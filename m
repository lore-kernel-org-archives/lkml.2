Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2HAPqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:46:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49692 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2HAPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <CADKZ3FK6+w6=XunA5n3o0VBKTSyNncNJDJj1Q_BFSbYMb6hmuQ@mail.gmail.com>
References: <CADKZ3FK6+w6=XunA5n3o0VBKTSyNncNJDJj1Q_BFSbYMb6hmuQ@mail.gmail.com>
Date: Wed, 1 Aug 2012 19:46:08 +0400
Message-ID: <CADKZ3FLSWmOQL5Jm1G=yrOHDr8zfSCoqjwY3n-FAHq06xbE1ng@mail.gmail.com>
Subject: Re: drivers/misc/apds990x.c: might_sleep operation in interrupt handler
From: Denis Yefremov <yefremov.denis@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Axel Lin <axel.lin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. My mistake. In this case it seems that sleep functions can
be called from apds990x_irq, since interrupt line is disabled globally
(because of IRQF_ONESHOT). And nothing bad will happen if
you know that device can be blocked for relatively long time.

2012/7/31 Denis Yefremov <yefremov.denis@gmail.com>:
> Interrupt handler apds990x_irq in APDS990x sensor driver
> invokes mutex_lock  that is might sleep operation.
>
> Found by Linux Driver Verification project (linuxtesting.org)
> within my participation in the GSoC 2012 program.
>
>
> static irqreturn_t apds990x_irq(int irq, void *data)
> {
>         struct apds990x_chip *chip = data;
>         u8 status;
>
>         apds990x_read_byte(chip, APDS990X_STATUS, &status);
>         apds990x_ack_int(chip, status);
>
>         mutex_lock(&chip->mutex);
> ...
> }
>
> static int __devinit apds990x_probe(struct i2c_client *client,
>                                 const struct i2c_device_id *id)
> {
> ...
>         err = request_threaded_irq(client->irq, NULL,
>                                 apds990x_irq,
>                                 IRQF_TRIGGER_FALLING | IRQF_TRIGGER_LOW |
>                                 IRQF_ONESHOT,
>                                 "apds990x", chip);
> ...
> }
