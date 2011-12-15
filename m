Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1LOKSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:18:20 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42550 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758738Ab1LOKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:18:17 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 15 Dec 2011 11:18:06 +0100
Subject: RE: [PATCHv2 07/10] xshm: XSHM Configuration data handling
Thread-Topic: [PATCHv2 07/10] xshm: XSHM Configuration data handling
Thread-Index: Acy2hJjiJa6WovcaRUuJuQm1isI6MQEjHxRQ
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0E21F6D@EXDCVYMBSTM005.EQ1STM.local>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
 <1323439648-22697-8-git-send-email-sjur.brandeland@stericsson.com>
 <201112091509.41123.arnd@arndb.de>
In-Reply-To: <201112091509.41123.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBFAIVtX008317

Hi Arnd,

>> +static unsigned long xshm_start;
>> +module_param(xshm_start, ulong, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(xshm_start, "Address for memory shared by host/modem.");
>> +
>> +static unsigned long xshm_c2c_bootaddr;
>> +module_param(xshm_c2c_bootaddr, ulong, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(xshm_c2c_bootaddr, "Address given to modem (through GENI register)");
>> +
>> +static long xshm_size;
>> +module_param(xshm_size, long, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(xshm_size, "Size of SHM area");

In 9540 the C2C memory configuration is known by the secure SW executing
at early boot-time. The memory layout parameters are stored in "secure world"
(ARM TrustZone), and are passed from "secure world" to boot-loader and then to
the Linux kernel.

> That looks fragile, you should never have addresses as module arguments.
> Either the kernel should be free to pick a reasonable address and tell
> it to the modem, 

This address cannot be decided by the Host alone, as the modem firmware
depends on the memory layout.

> or the modem should pick an address and then the kernel
> needs a reliable way to find out what it is.

The modem has not started at this point in the boot process.

As I see it we are left with three alternatives for getting the Shared Memory
configuration data: Device Tree, via netlink, or as module parameters.

AFIAK 9540 is not yet supporting Device Tree so this is not an option at the moment. 
Storing this in DT would also lead to duplication of configuration data.

Another option could be to get this from user-space via netlink. As mentioned
earlier the modem is started by a "Modem Init Daemon" (MID). The MID is managing the
life-cycle and provides everything the flash and ram-less modem needs. So MID has a
set of interdependent configuration elements: boot-images for several boot stages,
file-system, Shared Memory channel configuration etc. All these data elements needs
to be consistent for a given modem image. As the MID is already managing a set
of data that has to be consistent, we could add the Shared Memory Configuration
as well. (In future the MID might even get this data from "secure world" to avoid
duplication of data)

The benefit of the current solution, passing memory configuration data as Linux-kernel
boot parameters, is that the configuration is coming from the "secure world" via
the kernel boot-loader. In this way we avoid duplicating the memory configuration
data. So I'm not sure the current solution is any worse than the alternatives.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
