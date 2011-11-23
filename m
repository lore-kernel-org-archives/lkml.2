Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1KWOV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:21:58 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:48616 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1KWOV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:21:56 -0500
From: Carsten Behling <carsten.behling@garz-fricke.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 15:21:52 +0100
Subject: AW: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcypMG7f1j3pt+VZTlOvrrSAA2wmYwAAZ+ewACQAp5AAAcQnEAACUzcA
Message-ID: <D99582E5322435468A77E74BB0039E7B1D1655C047@SRV02.hamburg.garz-fricke.de>
References: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
 <D99582E5322435468A77E74BB0039E7B1D1655BFBB@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D349@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B40D349@wm021.weinmann.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try to use the at24 eeprom driver on top of this driver.

This EEPROM (24c32) works with two address bytes.

Writing results in a call to at91_twi_xfer() with num=1.
In this case the internal address register is not used and the address is sent out within the buffer.

Reading results in a call to at91_twi_xfer() with num=2.
In this case the internal address register is used.

However the MSB of the internal address resides in msg->buf[0] and the LSB resides in msg->buf[1] of the first message.

As a result the code:

+		for (i = 0; i < msg->len; ++i) {
+			internal_address |= ((unsigned)msg->buf[i]) << (8 * i);
+			int_addr_flag += AT91_TWI_IADRSZ_1;
+		}
+		at91_twi_write(dev, AT91_TWI_IADR, internal_address);

constructs an internal address in a wrong byte order.

Example: Try to read from address 0x100:

msg[0]->buf[0] = 0x1; 
msg[0]->buf[1] = 0x0;

results in

internal_address = 0x1;

I think it must be:

+		for (i = 0; i < msg->len; ++i) {
+			internal_address |= ((unsigned)msg->buf[msg->len-1-i]) << (8 * i);
+			int_addr_flag += AT91_TWI_IADRSZ_1;
+		}
+		at91_twi_write(dev, AT91_TWI_IADR, internal_address);

... or the at24 eeprom driver constructs the wrong internal address ...

Mit freundlichen Grüßen / Best regards
Carsten Behling

Development Engineer
Garz & Fricke GmbH
Tempowerkring 2, 21079 Hamburg - Germany
Amtsgericht Hamburg HRB 60514
Geschäftsführer: Manfred Garz, Matthias Fricke
Phone: +49 (0) 40 791 899 - 56
Fax:    +49 40 / 791 899 - 39
www.garz-fricke.com 

 


-----Ursprüngliche Nachricht-----
Von: Voss, Nikolaus [mailto:N.Voss@weinmann.de] 
Gesendet: Mittwoch, 23. November 2011 11:29
An: Carsten Behling
Cc: 'linux-i2c@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org'
Betreff: RE: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver

Hi,

Carsten Behling wrote on 2011-11-23:

>> this case is already catched in at91_do_twi_transfer():
> 
> Sorry, I did not found this code in your patch.
> (http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg06556.html):
> 
>> +       if (is_read) {
>> +               if (!dev->buf_len)

yes, this won't work for buf_len == 1. It is corrected in
https://lkml.org/lkml/2011/11/18/223 which I held back for some time
as it should have been just a feature extension. I was not aware it
also fixed the buf_len = 1 bug. Sorry for that...

(Explanation: in the first implementation I immediately decremented
buf_len, so buf_len == 1 could not occur. Later I removed that but
did not fully fold it into the base patch.)

Thanks,
Niko

