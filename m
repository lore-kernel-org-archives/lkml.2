Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1HVVLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:11:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab1HVVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:11:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rick Warner <rick@microway.com>
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call trace included
Date: Mon, 22 Aug 2011 23:13:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
References: <201108171751.51648.rick@microway.com> <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
In-Reply-To: <201108221651.35654.rick@microway.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108222313.26769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, August 22, 2011, Rick Warner wrote:
...
> Hi Rafael,
> 
> Thanks for the off-list help in getting you this info.
> 
> I had already rebuilt the kernel using the change I mentioned earlier (test on 
> !&g->error_status_address) since the call trace I got.
> 
> I luckily still had a copy of the kernel and modules I built previously using 
> just your patch, so I undid my change to the ghes.c source, leaving just your 
> patch but not mine so it would match the ghes.ko module I ran on.  This is the 
> output of gdb on that ghes.ko now:
> 
> (gdb) l *ghes_read_estatus+0x38
> 0x258 is in ghes_read_estatus (drivers/acpi/apei/ghes.c:296).
> warning: Source file is more recent than executable.
> 291             int rc;
> 292             if (!g)
> 293                     return -EINVAL;
> 294
> 295             rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
> 296             if (rc) {
> 297                     if (!silent && printk_ratelimit())
> 298                             pr_warning(FW_WARN GHES_PFX
> 299     "Failed to read error status block address for hardware error source: 
> %d.\n",
> 300                                        g->header.source_id);
> 
> The warning about the source being newer is because of the reverted change in 
> the ghes.c source mentioned above.

OK, since &buf_addr cannot be NULL, perhaps ghes is.  Please check if the
appended patch makes a difference.

Thanks,
Rafael

---
 drivers/acpi/apei/ghes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/drivers/acpi/apei/ghes.c
===================================================================
--- linux.orig/drivers/acpi/apei/ghes.c
+++ linux/drivers/acpi/apei/ghes.c
@@ -393,11 +393,16 @@ static void ghes_copy_tofrom_phys(void *
 
 static int ghes_read_estatus(struct ghes *ghes, int silent)
 {
-	struct acpi_hest_generic *g = ghes->generic;
+	struct acpi_hest_generic *g;
 	u64 buf_paddr;
 	u32 len;
 	int rc;
 
+	if (!ghes || !ghes->generic)
+		return -EINVAL;
+
+	g = ghes->generic;
+
 	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
 		if (!silent && printk_ratelimit())
