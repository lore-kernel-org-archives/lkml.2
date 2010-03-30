Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0C3Qwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:52:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1257 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0C3Qwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:52:42 -0400
Subject: Re: pr_* versus dev_*
From: Joe Perches <joe@perches.com>
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <912ec82a1003300907o7edeb73bp92d56741cfee1064@mail.gmail.com>
References: <912ec82a1003300907o7edeb73bp92d56741cfee1064@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 09:52:40 -0700
Message-ID: <1269967960.4558.162.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 19:07 +0300, Neshama Parhoti wrote:
> Which set of macros should I use in my driver ?
> 
> pr_info, pr_err, etc...  or dev_info, dev_err,    etc. ?

Possibly all of them.

> what are the advantages of the dev_* macros over the pr_* macros
> (why does it take the device pointer as an argument) ?
> 
> obviously I don't have access to my device pointer in all my functions..
> so pr_info is easier to use..
> but if it's wanted, obviously I can arrange to have my device pointer
> accessible..

You should also use dev_<level> where possible.
You should also use netdev_<level> and netif_<level> if your
device is a networking driver.
You should #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
to have a standard prefix for your driver.

Function	Benefit

pr_<level>:	Slightly shorter than printk(KERN_<LEVEL>)
		Gets a standard prefix with pr_fmt
dev_<level>:	Standardized device information:
		dev_driver_string, then dev_name
		dev_driver_string is the device's driver's name
		if it is bound to a device.  If the device is not
		bound to a device, the name of the bus it is
		attached to.  If it is not attached to a bus but
		has a class, the class name.
		If no class, you'll find an empty dance card.
netdev_<level>:	Appends struct net_device.name to dev_<level> prefix
		Use dev_<level> until alloc_netdev or alloc_etherdev
		has been called successfully.
netif_<level>:	Test network interface message level (netif_msg_<foo>)
		before calling netdev_<level>

Message logging with KERN_DEBUG levels are a bit more complicated:

These calls are optimized away and never printed unless
DEBUG is #defined or CONFIG_DYNAMIC_DEBUG is enabled.

pr_debug
dev_dbg
netdev_dbg
netif_dbg

To always have these emitted, use the appropriate printk calls

printk(KERN_DEBUG	this does not get a standard prefix
			use printk(KERN_DEBUG pr_fmt(fmt) if desired
dev_printk(KERN_DEBUG
netdev_printk(KERN_DEBUG
netif_printk(priv, msg, KERN_DEBUG

There are  _vdbg variants for even more verbose output if
VERBOSE_DEBUG is #defined.

