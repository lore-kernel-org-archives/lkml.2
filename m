Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0GWE4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:56:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41417 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0GWE4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:56:20 -0400
MIME-Version: 1.0
X-Originating-IP: [192.163.20.232]
In-Reply-To: <20100722125348.e4cd696f.randy.dunlap@oracle.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
	<20100722125348.e4cd696f.randy.dunlap@oracle.com>
Date: Fri, 23 Jul 2010 10:26:18 +0530
Message-ID: <AANLkTil64PBJ4FNNSftkXvy6ZjhoDc96rTH0csqAfU34@mail.gmail.com>
Subject: Re: [PATCH 0/3] drivers:staging:ti-st: patches
From: Pavan Savoy <pavan_savoy@sify.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

On Fri, Jul 23, 2010 at 1:23 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 22 Jul 2010 05:32:04 -0500 pavan_savoy@ti.com wrote:
>
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> The following patches cleanup bit of a mess and also adds functionality to protocol drivers.
>> with the 3rd patch now providing context to even the protocol drivers, the single device limit
>> or support for multiple devices would be easier to implement.
>>
>> These patches depend on the previously submitted
>> 0001-drivers-staging-ti-st-make-use-of-linux-err-codes.patch
>> commit d39d49b393d94f4137cee4f64526a4695352f183
>>
>> Pavan Savoy (3):
>>   drivers:staging:ti-st: smarten, reduce logs
>>   drivers:staging:ti-st: cleanup code comments
>>   drivers:staging:ti-st: give proto drivers context
>>
>>  drivers/staging/ti-st/bt_drv.c  |   23 +++++---
>>  drivers/staging/ti-st/st.h      |   52 +++++++++--------
>>  drivers/staging/ti-st/st_core.c |  118 +++++++++++++++++++--------------------
>>  drivers/staging/ti-st/st_core.h |   74 +++++++++++++++++--------
>>  drivers/staging/ti-st/st_kim.c  |   73 ++++++++++++++----------
>>  drivers/staging/ti-st/st_kim.h  |   77 ++++++++++++++++---------
>>  drivers/staging/ti-st/st_ll.c   |    4 +-
>>  drivers/staging/ti-st/st_ll.h   |    9 +++-
>>  8 files changed, 255 insertions(+), 175 deletions(-)
>
> Hi,
>
> I have reported this error a few times.  Where is the patch for it??
>
> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!


Yes, on one of the earlier patch sets, I had mentioned that the ST
driver being a platform device, needs definition in any of the
arch/XX/mach-XX/board-XX.c or devices.c or somewhere...

and hence it is in that board-XX.c file that the symbol
st_get_plat_device needs to be exported, the reason for that being,

ST driver being both a TTY ldisc driver and platform driver, in TTY
contexts it would need to refer to platform driver's data. So it does
a st_get_plat_device which returns the platform device structure, and
then does a dev_getdrvdata from it.

here's a snippet of code ...
/*
 * ST related functions related functions
 */
#include <linux/platform_device.h>

long gpios[] = { 55, -1, -1 };
static struct platform_device ti_st_device = {
        .name           = "kim",
        .id             = -1,
        .dev.platform_data      = &gpios,
};

struct platform_device *st_get_plat_device(void)
{
        return &ti_st_device;
}
EXPORT_SYMBOL(st_get_plat_device);

static __init int add_ti_st_device(void)
{
        platform_device_register(&ti_st_device);
        dev_info(&ti_st_device.dev,"registered platform TI ST device\n");

        return 0;
}
device_initcall(add_ti_st_device);


We have that in our local trees in arch/arm/mach-omap2/board-sdp4430.c

>
> thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
