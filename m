Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2K2QzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:55:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36213 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2K2QzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:55:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
Date: Thu, 29 Nov 2012 17:59:59 +0100
Message-ID: <3859273.SNWgJH0Fv3@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B75488.3090904@redhat.com>
References: <50A513A8.9010404@redhat.com> <2444442.WEaJk5cR6y@vostro.rjw.lan> <50B75488.3090904@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 01:26:48 PM Zdenek Kabelac wrote:
> Dne 29.11.2012 11:59, Rafael J. Wysocki napsal(a):
> > On Thursday, November 29, 2012 11:13:10 AM Zdenek Kabelac wrote:
> >> Dne 28.11.2012 20:07, Linus Torvalds napsal(a):
> >>> whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.
> >>
> >> Tested also this patch with this result:
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=51071#c8
> >>
> >> So while it's made it pass suspend/resume, it's not really usable
> >> as docking then.
> >
> > This just makes acpi_ns_lookup() always return acpi_gbl_root_node
> > for things looked up by acpi_ns_get_node() as far as I can say.
> >
> > Hmm.
> >
> > If my theory correct, the patch below should catch the bug.  Can you please
> > test it?
> >
> 
> Ok now crashing right after 'undock' button press:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51071#c10

And that's because I made a mistake in the patch.  We're currently testing
the appended one and it's showing that the added WARN_ON_ONCE() actually
triggers, so the theory appears to be correct.

I think we can debug this further in the Bugzilla.

Thanks,
Rafael


---
 drivers/acpi/scan.c            |    2 ++
 drivers/pnp/pnpacpi/rsparser.c |    3 +++
 2 files changed, 5 insertions(+)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -707,6 +707,8 @@ static void acpi_device_unregister(struc
 
 	acpi_device_remove_files(device);
 	device_unregister(&device->dev);
+
+	device->handle = ERR_PTR(-ENODEV);
 }
 
 /* --------------------------------------------------------------------------
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
