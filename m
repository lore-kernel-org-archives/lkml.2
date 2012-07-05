Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2GENS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:18:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63516 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <4FE28A4D.7060302@linux.intel.com>
References: <4FE28A4D.7060302@linux.intel.com>
Date: Thu, 5 Jul 2012 15:18:56 +0200
Message-ID: <CACRpkdbq+EPO8xZRgL3d3XNZMAKKB_i5BZJjYF1T2HTu3Up=yg@mail.gmail.com>
Subject: Re: RFC: pca953 new platform specific changes
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Miao <eric.miao@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 4:43 AM, Darren Hart <dvhart@linux.intel.com> wrote:

> I'm working on support for a device which combines a pair of PCA9555
> gpio chips with an LIS331DLH accelerometer on an I2C bus.

What we usually do in these cases is create a root device of MFD
class (see drivers/mfd/* for examples) which spawns children, in this
case two PCA9555 and one LIS331DLH devices. The MFD device
typically gets to funnel all requests to (e.g.) read and write registers
on the subdevices.

Now since IIUC, the PCA9555 already has a driver which sits directly
on I2C, and I think my friend Srinidhi is working on a IIO driver for
the LIS331DLH (maybe I confused named, tell me if I misunderstood)
and each of these may be parked directly on top of I2C, they need
different bus backends.

In the pca953x the register reads/writes are already nicely split off
into functions named pca953x_read_reg()/pca953x_write_reg()
so as a first step split out the I2C bus adoption and whatever
goes into that layer as a separate file named
drivers/gpio/gpio-pca953x-i2c.c[.h].

Then as a second step abstract the register read+write functions
totally and have the I2C portions fill in a vtable when calling up
to the main driver, so the main portion of the driver has no clue
it is sitting on I2C, this is all abstracted away and hidden.

Then as a third step add your MFD backend which provides an
MFD funnel to the same functions by providing another set
of functions to the vtable, that will not talk to the I2C bus but to
your MFD funnel, so instead of probing to the I2C bus, it will
probe from an MFD cell instatiated from the MFD funnel driver.

Yours,
Linus Walleij
