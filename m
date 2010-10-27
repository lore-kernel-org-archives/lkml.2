Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172Ab0J0Mzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:55:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48989 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0J0Mzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:55:35 -0400
From: <ilkka.koskinen@nokia.com>
To: <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <ilkka.koskinen@nokia.com>,
        <alan@lxorguk.ukuu.org.uk>, <grant.likely@secretlab.ca>
Date: Wed, 27 Oct 2010 14:55:03 +0200
Subject: RE: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Topic: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Index: Act1KDcGqGDjZsy8SJyQsi1HNG0L/gAo9LRw
Message-ID: <F80267346F10C541946CBE8909F1C39E35935F4CBC@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
 <20101026160936.GD13097@core.coreip.homeip.net>
In-Reply-To: <20101026160936.GD13097@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Oct 2010 12:55:05.0874 (UTC) FILETIME=[2D9A7720:01CB75D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

>From: ext Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Sent: 26 October, 2010 19:10
>To: Koskinen Ilkka (Nokia-MS/Tampere)
>Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; spi-
>devel-general@lists.sourceforge.net
>Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven
>vibrator
>
>Hi Ilkka,
>
>On Mon, Oct 25, 2010 at 04:31:02PM +0300, Ilkka Koskinen wrote:
>> This driver provides access to drive a vibrator connected
>> to SPI data line via Input layer's Force Feedback interface.
>>
>> Client application provides samples (data streams) to be
>> played as CUSTOM_DATA. The samples are stored in driver's
>> internal buffers.
>
>If device is able to do custom waveform can't it also do regular effects
>(constant, periodic, etc. Or is custom is actually random and you are
>doing something like rumble effect?

How about if I told about the vibration device a little? :)

The device can only accept analog signal with relatively narrow
frequency band. The bit stream consists of n-bit wide words that
are interpreted as PWM pulses. PWM pulses are used to generate
the desired waveform (close to sine wave).

One problem is that wave period needs to be symmetric in order
to avoid DC-offset. Therefore, we always have to play complete
periods. Another issue is that due to narrow frequency band,
we'd like to minimize the gap (or at least keep it quite stable)
between waves as that would affect the overall frequency once
again. Narrow band also means that the overall mechanics plays a
bigger role and probably needs more careful tuning.

Due to tuning issues, I'd prefer custom data provided by user
space. By that we would avoid compiling kernel unnecessarily.
Calculating the waveforms in the driver with help from board
specific functions sounds tempting as well, but would it be
better approach after all? 

>>
>> The driver is not able to mix the given samples. Instead, it
>> remembers the currently played sample and next one to be played.
>>
>
>Why is this driver not using the memoryless FF  library (and extends it
>to handle FF_CUSTOM effects) but rather reimplements it in the driver
>itself?

I don't know how I missed this one :( So if FF_CUSTOM is the
option to take, it makes sense to move the buffers to the
memoryless FF library.

>> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>> ---
>>  drivers/input/misc/Kconfig     |    5 +
>>  drivers/input/misc/Makefile    |    2 +-
>>  drivers/input/misc/vibra_spi.c |  429
>++++++++++++++++++++++++++++++++++++++++
>>  include/linux/spi/vibra.h      |   34 ++++
>>  4 files changed, 469 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/input/misc/vibra_spi.c
>>  create mode 100644 include/linux/spi/vibra.h
>>
>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>> index b49e233..3441832 100644
>> --- a/drivers/input/misc/Kconfig
>> +++ b/drivers/input/misc/Kconfig
>> @@ -438,4 +438,9 @@ config INPUT_ADXL34X_SPI
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called adxl34x-spi.
>>
>> +config INPUT_SPI_VIBRA
>> +	tristate "Support for SPI driven Vibra module"
>> +	help
>> +	  Support for Vibra module that is connected to OMAP SPI bus.
>> +
>
>"To compile this driver as a module". Also please keep Kconfig and
>Makefile sorted alphabetically.

I'll fix this.

Cheers, Ilkka

