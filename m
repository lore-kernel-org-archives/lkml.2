Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1EQM0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:26:20 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:47357 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab1EQM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:26:18 -0400
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 08:26:18 EDT
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: linux-kernel@vger.kernel.org
Subject: i80 (Intel 8080-like) command interface to LCDs - how to implement
Date: Tue, 17 May 2011 13:59:40 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.32-5-686; KDE/4.4.4; i686; ; )
Cc: linux-fbdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171359.43658.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to find the best way on implementing an i80 interface (especially 
the command mode) between a s3c2416 and an AUO-K1900 (epaper controller).

On the host side it is usable at least in all Samsung SoCs following the 
S3C2443 and on the device side I've found, apart from the K1900, for example 
the ili9320 and STM32F10xxx displays controllers using this interface.

It looks a bit like a cross between SPI and I2C but fits neither category - at 
least for my understanding.

pins/pins consist of:
CS ... chip-select
RS ... control or data register select
WE ... write enable
RE ... read enable
D0-Dn ... data 0-n for variing values of n
(I've seen up to 18 data bits)


commands can look like:
(* set command mode)
* set chip-select

* set RS to control (mostly low)
* set WE to high
* write command to D
* unset WE
* set RS to data

* set WE
* write data to D
* unset WE
* set WE
* write data to D
* unset WE
...
* set RE
* read data from D
* unset RE
...
* unset chip-select
(* unset command mode)

the fourth possible state (read-control) is also used by the ili9320.

looks a lot like an i2c-transfer, i.e. something like
{
  { WC, 6001 }, //for write-control
  { WD, 576 }, //for write-data
  { WD, 12 }, //for write-data
  { RD, *buf } //for read-data
}
could represent the above command-sequence.


So, is this a new bus type or does it fit somehow into spi or i2c or some other 
bus-type I don't know yet? Or, does code for i80 exist somewhere I haven't 
looked yet?

Thanks in advance
Heiko
