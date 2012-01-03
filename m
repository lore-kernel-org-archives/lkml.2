Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2ACMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:25:58 -0500
Received: from smtp-out-229.synserver.de ([212.40.185.229]:1050 "EHLO
	smtp-out-228.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668Ab2ACMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:25:56 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32502
Message-ID: <4F02F3FD.4010306@metafoo.de>
Date: Tue, 03 Jan 2012 13:26:37 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: Re: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device
 tree support
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>	<4F02C50E.9030904@metafoo.de> <CAJuYYwR8hnxJSfaXo4=RWCZ1HQZ1PHci+jY3K5b9ktWXryN0vA@mail.gmail.com>
In-Reply-To: <CAJuYYwR8hnxJSfaXo4=RWCZ1HQZ1PHci+jY3K5b9ktWXryN0vA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 12:54 PM, Thomas Abraham wrote:
> Hi Lars,
> 
> On 3 January 2012 14:36, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 01/02/2012 06:54 AM, Thomas Abraham wrote:
>>> The platform-lcd driver depends on platform-specific callbacks to setup the
>>> lcd panel. These callbacks are supplied using driver's platform data. But
>>> for adding device tree support for platform-lcd driver, providing such
>>> callbacks is not possible (without using auxdata).
>>>
>>> Since the callbacks are usually lcd panel specific, it is possible to include
>>> the lcd panel specific setup and control functionality in the platform-lcd
>>> driver itself, thereby eliminating the need for supplying platform specific
>>> callbacks to the driver. The platform-lcd driver can include support for
>>> multiple lcd panels.
>>>
>>> This patchset removes the need for platform data for platform-lcd driver and
>>> adds support which can be used to implement lcd panel specific functionality
>>> in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
>>> to the platform-lcd driver which is then used on the Exynos4 based Origen board.
>>> This currently breaks build for other users of platform-lcd driver. Those can be
>>> fixed if this approach is acceptable.
>>
>> The whole approach looks rather backwards to me. The exact purpose of the
>> platform_lcd driver is to redirect the lcd driver callbacks to board code.
>> So by removing this support you not only break all the existing driver but
>> also create a driver which does nothing. Then you add another layer of
>> abstraction to implement custom drivers in this driver. A better approach in
>> my opinion is to simply implement these drivers as first level LCD drivers.
>> So leave the platform-lcd driver as it is and just add a gpio (or maybe
>> regulator) lcd driver instead.
> 
> The existing platform-lcd driver mostly depends on the platform
> callbacks for lcd panel power controls. Looking at the current users
> of platform-lcd driver, a majority of the users of platform-lcd driver
> use a gpio to enable/disable the display/power. The gpio is controlled
> by the platform callbacks which the platform-lcd driver calls.
> 
> Hence, it is possible to extend the platform-lcd driver to include the
> functionality of managing the gpio for lcd control. The platform code
> is only expected to provide a gpio number to the platform-lcd driver.
> This allows consolidation of the all the different platform callbacks
> that use a gpio for simple enable/disable of the lcd display.
> 
> But there are other users of platform-lcd that do lot more than just
> control a single gpio. For such cases, it is possible to reuse the
> existing infrastructure of platform-lcd driver and extend it to handle
> such lcd panel specific functionality.
> 
> The main advantages that I see here is the consolidation of platform
> specific callbacks into the driver which inturn allows adding device
> tree support without depending on platform data which have pointers to
> platform specific functions. In the next version of this patchset, it
> will be ensured that no platform breaks due to this change.

Consolidation of the different implementations which use a GPIO to control
the LCD state is a good idea. But as I wrote above in this series you added
more or less another layer of abstraction. Namely introducing the
platform-lcd driver as a intermediate layer between the actual driver and
the LCD framework. But the layer is so thin that all it does is to call the
plat_lcd_driver_data callback from the lcd_ops callback. There is really no
point in doing this since you can setup the lcd_ops callbacks directly. Also
following your approach we would end up with a bunch of unrelated LCD
drivers in the platform-lcd driver module. The platform-lcd driver is so
generic that basically any LCD driver could be implemented on-top of it, but
this does not mean it has to.

As said before, writing a plain LCD driver which implements the GPIO
handling and leaving the platform-lcd driver as it is, is in my opinion a
better approach.



