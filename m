Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1L1Ngw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 08:36:52 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:57371 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1L1Ngt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 08:36:49 -0500
From: Carsten Behling <carsten.behling@garz-fricke.com>
To: Hubert Feurstein <h.feurstein@gmail.com>,
        Nikolaus Voss <n.voss@weinmann.de>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>
Date: Wed, 28 Dec 2011 14:36:44 +0100
Subject: AW: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
Thread-Topic: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
Thread-Index: AcyriE4lmXusT3tqSuS+KTzpHfrqPAZ3V8yg
Message-ID: <D99582E5322435468A77E74BB0039E7B1D18739F99@SRV02.hamburg.garz-fricke.de>
References: <cover.1322062555.git.n.voss@weinmann.de>
 <4ECFB755.6060509@gmail.com>
In-Reply-To: <4ECFB755.6060509@gmail.com>
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

I've tested this driver with the pca953x GPIO expander driver with a PCA9554.

In the case of 8 GPIO pins (my case) "i2c_smbus_read_byte_data(...)"
is called to read the registers of the GPIO expander. This results in a at91_twi_xfer with two messages. The first message is to put the register address into the IADR and the second is to read the one byte content of the register.

At the end we have a one byte read with a repeated start condition. 

I observed that reading out the GPIO status is one read delayed.
The first read to a register from the pca953x driver does not result in a RXRDY interrupt and at91_twi_read_next_byte(...) is not called.
Only the completion routine is triggered with a TXCOMP interrupt.

Additionally, I took a look at the status flags just after the control flags are set (in at91_do_twi_transfer(...), AT91_TWI_START|AT91_TWI_STOP for the one byte read). Surprisingly, the AT91_TWI_RXRDY flag is zero before the first register read and one for the following reads. According to the manual this flag should be zero after a read on AT91_TWI_RHR.

Reading the AT91_TWI_RHR before the control flags are set to be sure that the AT91_TWI_RXRDY is cleared leads to a never occurring RXRDY interrupt.

This looks very strange to me. Can anyone help?

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
Von: Hubert Feurstein [mailto:h.feurstein@gmail.com] 
Gesendet: Freitag, 25. November 2011 16:42
An: Nikolaus Voss
Cc: linux-i2c@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; ben-linux@fluff.org; Carsten Behling
Betreff: Re: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c

Hi,

I've tested this driver on a 2.6.38 kernel with several i2c clients
(temp-sensor, audio-codec, touchscreen-controller, w1-bridge,
io-expanders) and works without problems. SoC: at91sam9g45

Because of the 2.6.38 kernel, I had to skip "[PATCH v7 2/5] Replace
clk_lookup.con_id with clk_lookup.dev_id entries for twi clk" and used
instead: at91_clock_associate("twi0_clk", &at91sam9g45_twi0_device.dev,
"twi_clk");

Best Regards
Hubert

On 2011-11-23 16:35, Nikolaus Voss wrote:
> The old driver has two main deficencies:
> i)  No repeated start (Sr) condiction is possible, this makes it unusable
>     e.g. for most SMBus transfers.
> ii) I/O was done with polling/busy waiting what caused over-/underruns
>     even at light system loads and clock speeds.
> 
> The new driver overcomes these deficencies and in addition allows for
> more than one TWI interface.
> 

Tested-by: Hubert Feurstein <h.feurstein@gmail.com>
