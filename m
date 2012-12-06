Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2LFJa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:30:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57178 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2LFJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:30:26 -0500
Date: Thu, 6 Dec 2012 10:30:19 +0100
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Wen Congyang <wency@cn.fujitsu.com>,
        Wen Congyang <wencongyang@gmail.com>, isimatu.yasuaki@jp.fujitsu.com,
        lenb@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 3/3] acpi_memhotplug: Allow eject to proceed on
 rebind scenario
Message-ID: <20121206093019.GA4584@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
 <9212118.3s2xH6uJDI@vostro.rjw.lan>
 <1354136568.26955.312.camel@misato.fc.hp.com>
 <4042591.gpFk7OYmph@vostro.rjw.lan>
 <1354150952.26955.377.camel@misato.fc.hp.com>
 <1354151742.26955.385.camel@misato.fc.hp.com>
 <20121129110451.GA639@dhcp-192-168-178-175.profitbricks.localdomain>
 <1354211051.26955.435.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354211051.26955.435.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Thu, Nov 29, 2012 at 10:44:11AM -0700, Toshi Kani wrote:
> On Thu, 2012-11-29 at 12:04 +0100, Vasilis Liaskovitis wrote:
> 
> Yes, that's what I had in mind along with device_lock().  I think the
> lock is necessary to close the window.
> http://www.spinics.net/lists/linux-mm/msg46973.html
> 
> But as I mentioned in other email, I prefer option 3 with
> suppress_bind_attrs.  So, yes, please take a look to see how it works
> out.

I tested the suppress_bind_attrs and it works by simply setting it to true
before driver registration e.g. 

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -783,7 +783,8 @@ int acpi_bus_register_driver(struct acpi_driver *driver)
 	driver->drv.name = driver->name;
 	driver->drv.bus = &acpi_bus_type;
 	driver->drv.owner = driver->owner;
-
+    if (!strcmp(driver->class, "memory"))
+        driver->drv.suppress_bind_attrs = true;
 	ret = driver_register(&driver->drv);
 	return ret;
 }

No bind/unbind sysfs files are created when using this, as expected.
I assume we only want to suppress for acpi_memhotplug
(class=ACPI_MEMORY_DEVICE_CLASS i.e. "memory") devices.

Is there agreement on what acpi_bus_trim behaviour and rollback (if any) we
want to have for the current ACPI framework (partial trim or full trim on
failure)?

thanks,

- Vasilis

