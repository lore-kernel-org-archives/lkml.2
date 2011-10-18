Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1JROxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:53:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab1JROxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:53:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Date: Tue, 18 Oct 2011 16:53:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, Greg KH <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <201110181605.12512.arnd@arndb.de> <20111018141520.GA10054@totoro>
In-Reply-To: <20111018141520.GA10054@totoro>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110181653.09425.arnd@arndb.de>
X-Provags-ID: V02:K0:9X9mjWOSIj3SH4VRhNctgNJw05KijlK7q0CzVY/3OpE
 upzzh0Agr5jOZxw9zDAzTZ98oErMek5RoAA0QogUUg4r9APwIw
 4r0mn4NL9ZTkBeTMlcw1zLkqQav6j+oZTzwfhHUzk4o05UZoc1
 DYgE2clWH+NlvxLi8tS34XWIb/bp+1dF/hfxpx8nKhj9H48TwX
 pB2OTP8lMqg/sWvs6op5H/gPyP4yRmon526FTtbD51ZWSr7pNA
 +NEMSCYIBdVyPZajBltGcXe8foDcAXkY7cdqLHZg0JaC2UYEVI
 XLQS7b/YOjJke0nIjcAGSRd/nOgMyTkjf6dIp8ilB7+7muJSSt
 DHsQfn+ao4ADAvmaFAK0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011, Jamie Iles wrote:
> I can't think of a system where it make sense to have this as a loadable 
> module so can't we just register the bus_type and never unregister it 
> like the platform and spi busses for example?

Good point. At least if we disallow unregistering soc_devices as I
suggested, there is certainly no point making the bus itself modular.

> Also, (and I'm right at the edge of my knowledge here!) wouldn't you 
> also need to add reference counting of the module when 
> creating/destroying a soc device to prevent the module and bus 
> disappearing whilst you had devices with a reference to it?

No, that's not necessary in a case like this: The bus module remains
pinned by the reference of the module calling it on each exported
symbol that is referenced. The reference counting is only needed
if driver module provides function pointers to the bus module
that might be in the middle of getting called while the driver is
removed. We have this case with the ux500_get_process function
that may be called through sysfs, so that would be a bug if the
code calling device_create_file() was in a module.

	Arnd
