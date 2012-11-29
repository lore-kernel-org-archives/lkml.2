Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2K2Kyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:54:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36001 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2K2Kys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:54:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
Date: Thu, 29 Nov 2012 11:59:33 +0100
Message-ID: <2444442.WEaJk5cR6y@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B73536.9060408@redhat.com>
References: <50A513A8.9010404@redhat.com> <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com> <50B73536.9060408@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 11:13:10 AM Zdenek Kabelac wrote:
> Dne 28.11.2012 20:07, Linus Torvalds napsal(a):
> > whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.
> 
> Tested also this patch with this result:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51071#c8
> 
> So while it's made it pass suspend/resume, it's not really usable
> as docking then.

This just makes acpi_ns_lookup() always return acpi_gbl_root_node
for things looked up by acpi_ns_get_node() as far as I can say.

Hmm.

If my theory correct, the patch below should catch the bug.  Can you please
test it?

Rafael


---
 drivers/acpi/scan.c            |    1 +
 drivers/pnp/pnpacpi/rsparser.c |    3 +++
 2 files changed, 4 insertions(+)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -704,6 +704,7 @@ static void acpi_device_unregister(struc
 	mutex_unlock(&acpi_device_lock);
 
 	acpi_detach_data(device->handle, acpi_bus_data_handler);
+	device->handle = ERR_PTR(-ENODEV);
 
 	acpi_device_remove_files(device);
 	device_unregister(&device->dev);
Index: linux/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux/drivers/pnp/pnpacpi/rsparser.c
@@ -611,6 +611,9 @@ int pnpacpi_build_resource_template(stru
 	int res_cnt = 0;
 	acpi_status status;
 
+	if (WARN_ON_ONCE(IS_ERR(handle)))
+		return PTR_ERR(handle);
+
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {



-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
