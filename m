Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2KXWd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 17:33:29 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:36131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2KXWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 17:33:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via .sys_notify
Date: Sat, 24 Nov 2012 23:37:59 +0100
Message-ID: <9351429.9B119055GG@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1534747.XBnkTFzSlv@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com> <1352406227-32629-2-git-send-email-toshi.kani@hp.com> <1534747.XBnkTFzSlv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 24, 2012 11:01:56 PM Rafael J. Wysocki wrote:
> On Thursday, November 08, 2012 01:23:44 PM Toshi Kani wrote:
> > Added a new .sys_notify interface, which allows ACPI drivers to
> > register their system-level (ex. hotplug) notify handlers through
> > their acpi_driver table.  This removes redundant ACPI namespace
> > walks from ACPI drivers for faster booting.
> > 
> > The global notify handler acpi_bus_notify() is called for all
> > system-level ACPI notifications, which then calls an appropriate
> > driver's handler if any.  ACPI drivers no longer need to register
> > or unregister driver's handler to each ACPI device object.  It also
> > supports dynamic ACPI namespace with LoadTable & Unload opcode
> > without any modification in ACPI drivers.
> > 
> > Added a common system notify handler acpi_bus_sys_notify(), which
> > allows ACPI drivers to set it to .sys_notify when this function is
> > fully implemented.
> 
> I don't really understand this.
> 
> > It removes functional conflict between driver's
> > notify handler and the global notify handler acpi_bus_notify().
> > 
> > Note that the changes maintain backward compatibility for ACPI
> > drivers.  Any drivers registered their hotplug handler through the
> > existing interfaces, such as acpi_install_notify_handler() and
> > register_acpi_bus_notifier(), will continue to work as before.
> 
> I really wouldn't like to add new callbacks to struct acpi_device_ops, because
> I'd like that whole thing to go away entirely eventually, along with struct
> acpi_driver.
> 
> Moreover, in this particular case, it really is not useful to have to define
> a struct acpi_driver so that one can register for receiving system
> notifications from ACPI.  It would be really nice if non-ACPI drivers, such
> as PCI or platform, could do that too.

Which they do by using acpi_install_notify_handler() directly.

> Besides, acpi_os_execute_deferred() is always run on CPU0, because of some
> SMI-related peculiarity, which is not very efficient as far as the events
> handling is concerned, but we can improve the situation a bit by queing the
> execution of the registered handlers in a different workqueue.  Maybe it's
> worth considering if we're going to change this code anyway?

Well, perhaps we really don't need to change it after all?  Maybe we can just
switch everyone to using acpi_install_notify_handler() and then we can just
drop that code entirely?

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
