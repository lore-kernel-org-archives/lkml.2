Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1JKLnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:43:07 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:38448 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1JKLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:43:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, zdevai@gmail.com,
        linus.walleij@linaro.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH RFC] IIO: Proof of concept in kernel interface.
Date: Tue, 11 Oct 2011 12:43:02 +0100
Message-Id: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Given I keep blithely stating it would be easy to add an in kernel
interface to IIO, I thought I'd better actually prove it.

There are numerous holes / questions raised by this example.

1) We need a foolproof way of getting the right instance of
a given device.  This PoC does it by part name (unique on my
test board but far from it in general).
The snag as ever is the complexity of getting a reliable reference
to an i2c or spi part.  Basically it's the same problem fudged
over in the regulator framework.

2) Callbacks for triggered read.  Not done here and given the flexibility
of IIO triggers it's not obvious how to do it.  Most other subsystems
pretty much assume they will get a stream of data and do not control
what causes it to appear.  With IIO I we'll either need in kernel control
of this (fiddly as it really isn't that generalizable), assume
sane default settings or have a userspace daemon to set it up.

3) How much hand holding to do.  Right now it gives raw access to the device,
equivalent to what the IIO core has.  Is it worth doing error checking utility
functions such as

int iio_consumer_read_data(struct iio_dev *indio_dev, int channel, enum iio_type type);
which would do stuff like verify the channel exists and that it
is the right sort of channel. Can also use this to 'hide' the
struct iio_dev etc from the consumer drivers.

If people are happy with the general form and we nail the
association problem, I'll write a general hwmon interface
to do simple hardware monitoring from an adc channel.
For now I'd keep it completely trivial and avoid events etc.

So comments welcome,

This sits on a couple of patches that haven't gone upstream yet, so
best bet is probably

https://github.com/jic23/linux-iio/tree/inkern

which also has the dummy driver for anyone who wants to play
and doesn't have hardware.


Jonathan Cameron (1):
  staging:iio:proof of concept in kernel interface.

 drivers/staging/iio/Kconfig             |    5 ++++
 drivers/staging/iio/Makefile            |    3 ++
 drivers/staging/iio/iio.h               |    5 ++++
 drivers/staging/iio/industrialio-core.c |   38 ++++++++++++++++++++++++++++
 drivers/staging/iio/inkern.c            |   41 +++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/inkern.c

-- 
1.7.3.4

