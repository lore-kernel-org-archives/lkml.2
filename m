Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab2CMMKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:10:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab2CMMKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:10:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCHv2 1/3] misc: clean up bmp085 driver
Date: Tue, 13 Mar 2012 12:04:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Stefan Nilsson <stefan.nilsson@unixphere.com>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com> <201203062120.47953.arnd@arndb.de> <20120312225301.GA16648@skinner.xfiles.lan>
In-Reply-To: <20120312225301.GA16648@skinner.xfiles.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203131204.43036.arnd@arndb.de>
X-Provags-ID: V02:K0:dQ3sPSXYLLZnu+GSisqygvJHtz9t+ZHoKbES1vAIsgZ
 sAUOVofCR8wVbn+dwF+xjD7JbKOqwTRwyFyPeO90fKr4LobRJC
 M5AamVUDsfMWtIKzEx7UXTWd3DVDqK2hpjm1BDGYiuL8K1WY3D
 ms/Puqm3KZxJZxoklGqQONnKgyB2a/dfUADL9xHGZvteLaPCO6
 CGktXI1vgtoUMjdQttJKjxNgNKTH5DrC2cnGzPfrCc/hVDZpv6
 FFyQLTQ0XR9Zc371OT6cXmdVmI/839Ma3ajfi6uaUpKANmQiMD
 lSRLAOJUms7ltjSEDduPMoJd23xAzB3AtHVCc7Ypc19eWpNiql
 2MDvCrrgV3XQ2yOpzGIU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, Eric Andersson wrote:
> > > diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
> > > new file mode 100644
> > > index 0000000..e6fc752
> > > --- /dev/null
> > > +++ b/include/linux/i2c/bmp085.h
> > 
> > Since this file only adds platform_data, I think it should go into
> > include/linux/platform_data/, not include/linux/i2c, and it should
> > be in the same patch as the change to use the platform data when you
> > split that out.
> > 
> > Also, which platforms are actually using this driver? I could
> > not find any platform that defines a bmp085 platform_device. If this
> > is for new ARM platforms, I would rather not add platform_data at
> > all because those platforms will have to use device tree properties
> > rather than platform_data to pass initialization data.
> 
> Platform device? This is a pressure sensor connected as a peripheral
> device to the i2c bus. I don't think you will find any platform that
> uses this "by default" in the tree.
> 
> Of course I can add of_get_property() calls, but what is actually the
> long-term plan here for peripheral devices? Should they all abandon their
> platform data in favor of devicetree? 

Yes, that is definitely the plan. The current method does not scale,
because right now you have to modify the kernel sources any time you
have a slightly different combination of devices in the system, which
especially in cases of user-pluggable i2c devices is not a good
design.

> How should the callbacks in platform data be handled, in my case
> pdata->init_hw()?

This depends a lot on what the individual callback does. In my experience,
90% of these callbacks can and should just get removed because they
are not necessary and the same functionality can be expressed by generalizing
the setup procedure, e.g. by calling into the regulator, gpio, clock
or pinmux frameworks from the device probe() function.

In the few cases where this is not possible, some of the approaches
I can think of (again, case by case) include:

* educate the hardware designers so they do things in a more maintainable
  way in the future, hope that the current design goes away.

* add a special case in the driver using something like
  if (machine_is_compatible("something,weird"))
	do_weird_setup(dev);

* use auxdata for the machine to supply a platform_data structure in
  addition to the device tree.

* Don't support the board in the mainline kernel, but require the
  user to keep using a private patch (this is the status quo, because
  right now they need a private patch to add the board file).

	Arnd

