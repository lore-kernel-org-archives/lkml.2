Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1AOUta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 15:49:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1AOUt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 15:49:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] ACPI: don't attempt to use hest_tab unless !acpi_pci_disabled
Date: Sat, 15 Jan 2011 21:48:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20110114181620.188e7a62@queued.net> <201101152138.11183.rjw@sisk.pl> <20110115124242.4f9ae65d@queued.net>
In-Reply-To: <20110115124242.4f9ae65d@queued.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101152148.43791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 15, 2011, Andres Salomon wrote:
> On Sat, 15 Jan 2011 21:38:10 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, January 15, 2011, Andres Salomon wrote:
> > > On Sat, 15 Jan 2011 14:01:18 +0100
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Saturday, January 15, 2011, Andres Salomon wrote:
> > > > > On Fri, 14 Jan 2011 23:24:27 -0500 (EST)
> > > > > Len Brown <lenb@kernel.org> wrote:
> > > > > 
> > > > > [...]
> > > > > > > This patch causes apei_hest_parse to check both
> > > > > > > hest_disabled and acpi_pci_disabled before continuing.
> > > > > > > With it, the XO-1 boots properly.
> > > > > > 
> > > > > > The X0-1 has no ACPI support, and thus you are running
> > > > > > with acpi_disabled=1, yes?
> > > > > 
> > > > > The XO-1 has no ACPI support, but ACPI support is enabled in the
> > > > > kernel (as the XO-1.5 does have ACPI support, and the same
> > > > > kernel is used between both) and I'm not passing any arguments
> > > > > to the kernel regarding it. The kernel's ACPI code detects that
> > > > > it's not there and disables it (the kernel message that's seen
> > > > > is "ACPI: Interpreter disabled.")
> > > > > 
> > > > > This is what sets apci_pci_disabled to 1; I'm not doing it
> > > > > manually.
> > > > 
> > > > Hmm.  Does the appended patch help instead?
> > > 
> > > Nope.  acpi_hest_init returns immediately if acpi_disabled, and thus
> > > never sets hest_disable.  You either need to set hest_disable, or
> > > ensure apei_hest_parse checks more than just hest_disable.
> > 
> > OK, so the new one below should help, right?
> 
> Yes, that looks better

OK

> (though you probably just want to use 'goto err;' instead).

Indeed.

> I can test it later today.

Cool, thanks.  Please try the version below with the 'goto'.

Rafael

---
 drivers/acpi/apei/hest.c |    6 +++---
 drivers/acpi/pci_root.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -631,11 +631,11 @@ static int acpi_pci_root_remove(struct a
 
 static int __init acpi_pci_root_init(void)
 {
+	acpi_hest_init();
+
 	if (acpi_pci_disabled)
 		return 0;
 
-	acpi_hest_init();
-
 	pci_acpi_crs_quirks();
 	if (acpi_bus_register_driver(&acpi_pci_root_driver) < 0)
 		return -ENODEV;
Index: linux-2.6/drivers/acpi/apei/hest.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/hest.c
+++ linux-2.6/drivers/acpi/apei/hest.c
@@ -201,14 +201,14 @@ void __init acpi_hest_init(void)
 	int rc = -ENODEV;
 	unsigned int ghes_count = 0;
 
-	if (acpi_disabled)
-		return;
-
 	if (hest_disable) {
 		pr_info(HEST_PFX "Table parsing disabled.\n");
 		return;
 	}
 
+	if (acpi_disabled)
+		goto err;
+
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
 	if (status == AE_NOT_FOUND) {
