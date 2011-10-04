Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1JDP6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:58:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62676 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1JDP6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20111004145148.GA8021@manju-desktop>
References: <20110922184614.25419.84606.stgit@ponder> <20111004145148.GA8021@manju-desktop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Oct 2011 09:58:10 -0600
X-Google-Sender-Auth: 7XuSOoRKLZtNNQumuobDmbET_1E
Message-ID: <CACxGe6tXEx1A+ZuBTUdi8jjfx_hOCaX6eSpUOOhNH9us+Mnczg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 8:51 AM, G, Manjunath Kondaiah <manjugk@ti.com> wrote:
> On Thu, Sep 22, 2011 at 12:51:23PM -0600, Grant Likely wrote:
>> Hi Manjunath,
>>
>> Here's the current state of the patch.  The major think that needs to
>> be done is to convert it to use a separate workqueue as described in
>> the TODO above.  It also needs some users adapted to it.  One of the
>> gpio drivers would work; preferably one of the newer drivers that
>> doesn't have a lot of drivers depending on the early_initcall()
>> behaviour yet.
>
> I have tested this patch on omap3 beagle board by making:
> 1. omap-gpio driver init as late_initcall instead of postcore_initcall
> 2. mmc driver probe will request gpio through gpio_request and gpio driver
> returns -EDEFER_PROBE which in turn makes mmc driver to request deferral probe.
> 3. When deferral probe gets activated, it scans driver entries and it will not
> find any match for mmc driver probe.

Looks like drivers/mmc/host/omap.c is using platform_driver_probe()
instead of platform_driver_register().  Add the probe hook to the
platform_driver structure and change it to call
platform_driver_register() and it should work.  Don't forget to change
mmc_omap_probe from __init to __devinit.

g.
