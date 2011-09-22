Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1IVT2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:28:47 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12079 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1IVT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:28:42 -0400
Message-ID: <4E7B8C68.2050906@cavium.com>
Date: Thu, 22 Sep 2011 12:28:40 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
References: <20110922184614.25419.84606.stgit@ponder>
In-Reply-To: <20110922184614.25419.84606.stgit@ponder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2011 19:28:41.0716 (UTC) FILETIME=[D60F7B40:01CC795D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Grant, This is sorely needed.

On 09/22/2011 11:51 AM, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
>
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.
>
> v3: - Hold off workqueue scheduling until late_initcall so that the bulk
>        of driver probes are complete before we start retrying deferred devices.
>      - Tested with simple use cases.  Still needs more testing though.
>        Using it to get rid of the gpio early_initcall madness, or to replace
>        the ASoC internal probe deferral code would be ideal.
> v2: - added locking so it should no longer be utterly broken in that regard
>      - remove device from deferred list at device_del time.
>      - Still completely untested with any real use case, but has been
>        boot tested.
>
> TODO: - Create a separate singlethread_workqueue so that drivers can't
>          mess things up by calling flush_work().
>        - Maybe this should be wrapped with a kconfig symbol so it can
>          be compiled out on systems that don't care.
>
> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman<greg@kroah.com>
> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: Dilan Lee<dilee@nvidia.com>
> Cc: Manjunath GKondaiah<manjunath.gkondaiah@linaro.org>

FWIW:

Acked-by: David Daney <david.daney@cavium.com>


> ---
>
> Hi Manjunath,
>
> Here's the current state of the patch.  The major think that needs to
> be done is to convert it to use a separate workqueue as described in
> the TODO above.  It also needs some users adapted to it.  One of the
> gpio drivers would work; preferably one of the newer drivers that
> doesn't have a lot of drivers depending on the early_initcall()
> behaviour yet.
>
> Mark Brown may also be able to suggest specific examples.
>

I know I have an example:

My MDIO and I2C bus multiplexer patches are not yet merged, but they are 
relevant to this.


Consider a Ethernet device driver, it needs to communicate with PHY 
devices and its driver cannot be be initialized until the PHY drivers 
have been initialized.

However these PHYs are on an multiplexed MDIO bus controlled by GPIO 
pins.  We cannot initialize the PHY drivers until the MDIO bus is 
initialized.

Wait there is more...  The GPIO pins controlling the MDIO bus 
multiplexer are on an I2C controlled GPIO expander and cannot be used 
until the I2C system is up and the drivers initialized.

So we have this driver initialization dependency:

Ethernet driver -> PHY/MDIO -> GPIO/I2C

We cannot really have a static initialization order because the 
relationships are board dependent and there are more levels than can be 
achieved with *_initcall().  On some boards the PHYs are directly 
connected so there is no multiplexer.  On others there is a MDIO 
multiplexer, but it is controlled by GPIO pins on the SOC and are thus 
available when the GPIO subsystem is up rather than I2C.


Without something like this patch, we have a house of cards just waiting 
to collapse.


> For everyone else; this is the current state of the patch.  I think it
> is in pretty good shape other than the TODO item above.  I'm turning
> it over to Manjunath to  polish up for merging.  I would appreciate
> any feedback.
>
> g.
>
>
>   drivers/base/base.h    |    1
>   drivers/base/core.c    |    2 +
>   drivers/base/dd.c      |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/device.h |    5 ++
>   4 files changed, 141 insertions(+), 1 deletions(-)
[...]

