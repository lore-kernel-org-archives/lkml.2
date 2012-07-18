Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2GRAuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:50:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11042 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2GRAuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:50:15 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-1c-500608455b1e
Message-id: <50060845.8090100@samsung.com>
Date: Wed, 18 Jul 2012 09:50:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MAX77693: Fix bug of interrupt handlding for MAX77693
 devices
References: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
 <20120716133636.GA22600@sirena.org.uk> <5004A409.9000002@samsung.com>
 <20120717191451.GK4477@opensource.wolfsonmicro.com>
In-reply-to: <20120717191451.GK4477@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jAV1XDrYAg+ZGbYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxYN5u1oJd/BV/j4s1MF7l6WLk5JAQMJG4fewPG4QtJnHh3nog
	m4tDSGARo8Si7i9MIAkhgS4miVXTI0BsXgEtids3frB0MXJwsAioSrw7CdbLBhTe/+IGG0hY
	VCBC4lc/B0S1oMSPyffAqkWAVv2+XwkSZhbIk3i67yBYp7BApMSHme1MEFsPMUpcu3ERLMEp
	4CCx9uQ6RogGHYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHHrPpHcwrmqwOMQowMGoxMOr8Jk1QIg1say4MhfoGg5mJRFewedAId6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4rwm3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYySk+uXPjfUlUpa
	ljxdPK++jkWg4MbSuwUJJanBDA38u/eq3nPirHIrF/V8tLpg+hPfySqyfnalvV7NH15ut1rj
	+DjlF88fFofko/yX7zAVMwplvwz5wJnOOM+M6fSXtmwJu1unPO8uaXwc981lZnKE4a8X300m
	JpSUJLe36bPVSz6oO+23SImlOCPRUIu5qDgRAKWWbME5AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 04:14 AM, Mark Brown wrote:

> On Tue, Jul 17, 2012 at 08:30:17AM +0900, Chanwoo Choi wrote:
>> On 07/16/2012 10:36 PM, Mark Brown wrote:
>>> On Mon, Jul 16, 2012 at 06:41:05PM +0900, Chanwoo Choi wrote:
> 
>>>> This patch fix bug related to interrupt handling for MAX77693 devices.
>>>> - Unmask interrupt masking bit for charger/flash/muic to revolve
>>>> that interrupt isn't happened when external connector is attached.
> 
>>> Shouldn't this be happening when the IRQ is requested?
> 
>> The interrupt isn't happened when external connector is attached
>> because muic interrupt of MAX77693 is masked on INTSRC_MASK(
>> Interrupt Source Mask) register. So, I should set zero to muic interrupt
>> masking bit of INTSRC_MASK before requesting IRQ.
> 
> Right, but normally that unmasking happens in the unmask() callback of
> the irq_chip which is called when the interrupt is requested.  Why isn't
> that working here?


As previous reply, Maxim MAX77693 has INTSRC_MASK(Interrput Source Mask,
0x23)
which mask or unmask Charger/Top/Flash/MUIC interrupt. And MAX77693 has
additional 'Interrupt Source Mask' for sub interrupt of each
Charger/Top/Flash/MUIC device.
In case of MUIC device, MUIC device has 16 sub interrupts and then MUIC
device need
separate Interrupt Source Mask(0x1,0x2,0x3) which is included in
register map of
MUIC i2c device and isn't equal to INTSRC_MASK(0x23). As you said,
unmasking sub interrupt of MUIC is happened in unmask() callback using
separate Interrupt Source Mask(0x1, 0x2, 0x3).

The MAX77693 mfd driver handle only INTSRC_MASK(0x23) to activate
Charger/Top/Flash/MUIC interrupt which isn't equal to sub interrupt of
each device before requesting
IRQ. If mfd driver wouldn't unmask Charger/Top/Flash/MUIC interrupt of
INTSRC_MASK(0x23),
it mean that Charger/Top/Flash/MUIC interrupt is inactive state and mfd
driver can't get the any interrupt.

Thank you,
Chanwoo Choi





