Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2FXTuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 15:50:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:40372 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2FXTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 15:50:09 -0400
Message-ID: <4FE76F6C.1090300@linutronix.de>
Date: Sun, 24 Jun 2012 21:50:04 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
In-Reply-To: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 12:55 PM, Andrzej Pietrasiewicz wrote:
> $ echo 1>   /cfg/usb-function-gadget/G1/connect
> $ file.img>  /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/file

connect should be available at UDC level which triggers the
pull-up/down of the UDC. The gadget itself should be configured once
and made available / bound to the UDC. And you may have more
than once UDC at a time within a single a system.

> Each function, after creating its corresponding directory
> (/cfg/usb-function-gadget/G1/C1/F1), must be "personalized" by storing
> its name in the "name" attribute. After that it is possible to create
> a child item of the same name ("f_mass_storage" here). The common code
> handles everything from top of the hierarchy up to the function directory.
> Under the function directory a function-specific stuff provided by each
> function is used. The function-specific code is abstracted by the above
> mentioned struct ufg_fn. In the example, the mass storage function is
> supplied with one LUN.

The hierarchy looks good. C1 vs config1 is just taste.

> The "connect" attribute's store method calls the ufg_gadget_bind function,
> which registers the composite gadget, then walks the configfs hierarchy
> rooted at the above mentioned subsystem and does USB configurations and
> functions registration.


> This is a work in progress. There might be issues.
>
> I would like to ask some questions. All answers in general, and answers
> from linux-usb and Felipe and Greg KH in particular, are welcome.
>
> 1. Generally, is this the right way to go?
In the big picture I think, yes. I think you should start a little
different. We need to be able to load multiple gadgets at a time.
Therefore I would suggest to first rip the global variables out of
composite. It is probably also possible to do it after configfs is in
but I think doing it first would be less work.

> 2. Using configfs like this calls for an interface between the generic
>     configfs-related code and function-specific code. I suggested the
>     struct ufg_fn. What do you think?
> 3. Should some parameters still be available through sysfs?
We have for udc level some things like connect, power level and Felipe
planned a poll interface for connect/disconnect notifications. This is
one side. On the gadget it should configure a custom gadget as detailed
as possible / required. What kind of options would you like to export 
via sysfs? Currently I can't think of any.

> 4. Do we need module parameters for USB descriptors like iManufacturer
>     and similar?
No. No modules parameters at all. With one exception: Currently we set
those things via modprobe. As a for compatibility interface I guess we
have to keep this. In the end I would like have f_mass_storage gone as 
it. We would have a new gadget_storage which provides only the function 
and relies on configfs module and nothing else. The replacement
g_mass_storage would simply be a small module which takes the
iManufacturer parameters and others and configures the gadget the way
the old gadget did i.e. without echo this and echo that.

> 5. I assumed that the configfs entities are contained in the structures
>     used for configuring the USB functions, e.g. a struct config_group in
>     struct fsg_common, or a struct config_item in a struct fsg_lun. This
>     has implications that the lifetime of the structures is controlled by
>     userspace through configfs, which, in turn, has influence on how
>     the USB functions are implemented. Even though it seems natural,
>     there are some issues. For example an extension to configfs was required
>     in order to disable deleting the luns while the gadget is connected.
>     Is this the right approach? If not, then are there any alternatives?

Joel might be a help here. I had the same problem with my uas gadget
and I ignored it for now. I think it should be possible to forbid
unlink / rename / create at certain states of gadget. For instance it
should not be possible to change a single thing while the gadget is
connected.

Sebastian
