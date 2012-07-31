Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2GaRoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:44:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58385 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2GaRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:44:24 -0400
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 21:44:22 +0400
Message-ID: <CADKZ3FK6+w6=XunA5n3o0VBKTSyNncNJDJj1Q_BFSbYMb6hmuQ@mail.gmail.com>
Subject: drivers/misc/apds990x.c: might_sleep operation in interrupt handler
From: Denis Yefremov <yefremov.denis@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Axel Lin <axel.lin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt handler apds990x_irq in APDS990x sensor driver
invokes mutex_lock  that is might sleep operation.

Found by Linux Driver Verification project (linuxtesting.org)
within my participation in the GSoC 2012 program.


static irqreturn_t apds990x_irq(int irq, void *data)
{
        struct apds990x_chip *chip = data;
        u8 status;

        apds990x_read_byte(chip, APDS990X_STATUS, &status);
        apds990x_ack_int(chip, status);

        mutex_lock(&chip->mutex);
...
}

static int __devinit apds990x_probe(struct i2c_client *client,
                                const struct i2c_device_id *id)
{
...
        err = request_threaded_irq(client->irq, NULL,
                                apds990x_irq,
                                IRQF_TRIGGER_FALLING | IRQF_TRIGGER_LOW |
                                IRQF_ONESHOT,
                                "apds990x", chip);
...
}
