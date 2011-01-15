Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AOUi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 15:38:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1AOUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 15:38:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] ACPI: don't attempt to use hest_tab unless !acpi_pci_disabled
Date: Sat, 15 Jan 2011 21:38:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20110114181620.188e7a62@queued.net> <201101151401.18846.rjw@sisk.pl> <20110115123233.2727f871@queued.net>
In-Reply-To: <20110115123233.2727f871@queued.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101152138.11183.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 15, 2011, Andres Salomon wrote:
> On Sat, 15 Jan 2011 14:01:18 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, January 15, 2011, Andres Salomon wrote:
> > > On Fri, 14 Jan 2011 23:24:27 -0500 (EST)
> > > Len Brown <lenb@kernel.org> wrote:
> > > 
> > > [...]
> > > > > This patch causes apei_hest_parse to check both hest_disabled
> > > > > and acpi_pci_disabled before continuing.  With it, the XO-1
> > > > > boots properly.
> > > > 
> > > > The X0-1 has no ACPI support, and thus you are running
> > > > with acpi_disabled=1, yes?
> > > 
> > > The XO-1 has no ACPI support, but ACPI support is enabled in the
> > > kernel (as the XO-1.5 does have ACPI support, and the same kernel
> > > is used between both) and I'm not passing any arguments to the
> > > kernel regarding it. The kernel's ACPI code detects that it's not
> > > there and disables it (the kernel message that's seen is "ACPI:
> > > Interpreter disabled.")
> > > 
> > > This is what sets apci_pci_disabled to 1; I'm not doing it manually.
> > 
> > Hmm.  Does the appended patch help instead?
> 
> Nope.  acpi_hest_init returns immediately if acpi_disabled, and thus
> never sets hest_disable.  You either need to set hest_disable, or
> ensure apei_hest_parse checks more than just hest_disable.

OK, so the new one below should help, right?

Thanks,
Rafael

---
 drivers/acpi/apei/hest.c |    4 +++-
 drivers/acpi/pci_root.c  |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

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
@@ -201,8 +201,10 @@ void __init acpi_hest_init(void)
 	int rc = -ENODEV;
 	unsigned int ghes_count = 0;
 
-	if (acpi_disabled)
+	if (acpi_disabled) {
+		hest_disable = 1;
 		return;
+	}
 
 	if (hest_disable) {
 		pr_info(HEST_PFX "Table parsing disabled.\n");
