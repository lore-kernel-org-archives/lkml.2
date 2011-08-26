Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1HZAeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:34:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:15629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1HZAeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:34:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="42356075"
Message-ID: <4E56EA02.7020307@intel.com>
Date: Fri, 26 Aug 2011 08:34:10 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: "rick@microway.com" <rick@microway.com>
CC: Don Zickus <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Houghton <rhoughton@microway.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
References: <201108171751.51648.rick@microway.com>    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>    <20110823171432.GA10794@redhat.com>    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>    <4E547B0F.6000001@intel.com>    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com> <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>
In-Reply-To: <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>
Content-Type: multipart/mixed;
 boundary="------------080701020304030906000802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080701020304030906000802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/25/2011 11:47 PM, rick@microway.com wrote:
> Hi Huang,
> 
> My new setup reproduced the panic. However I do not have any gar accessed
> messages on it.  The gar mapped messages are in my previous email.  Here
> is the latest call trace.  There is no GHES output prior to it:
> 

That is wired.  Can you try the patch attached?  If my guessing is
correct, there will be no panic, but something as follow will be in dmesg:

ACPI atomic read mem: addr 0xxxxx mapped to 0

Best Regards,
Huang Ying

--------------080701020304030906000802
Content-Type: text/x-patch;
 name="dbg_ghes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dbg_ghes.patch"

---
 drivers/acpi/apei/ghes.c |    6 ++++++
 drivers/acpi/atomicio.c  |    4 ++++
 2 files changed, 10 insertions(+)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -299,6 +299,9 @@ static struct ghes *ghes_new(struct acpi
 		return ERR_PTR(-ENOMEM);
 	ghes->generic = generic;
 	rc = acpi_pre_map_gar(&generic->error_status_address);
+	pr_info(GHES_PFX "gar mapped: %d, 0x%llx\n",
+		generic->error_status_address.space_id,
+		generic->error_status_address.address);
 	if (rc)
 		goto err_free;
 	error_block_length = generic->error_block_length;
@@ -398,6 +401,9 @@ static int ghes_read_estatus(struct ghes
 	u32 len;
 	int rc;
 
+	pr_err(GHES_PFX "gar accessed: %d, 0x%llx\n",
+	       g->error_status_address.space_id,
+	       g->error_status_address.address);
 	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
 		if (!silent && printk_ratelimit())
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -270,6 +270,10 @@ static int acpi_atomic_read_mem(u64 padd
 
 	rcu_read_lock();
 	addr = __acpi_ioremap_fast(paddr, width);
+	pr_err("ACPI atomic read mem: addr 0x%llx mapped to %p\n",
+	       paddr, addr);
+	if (!addr)
+		return -EIO;
 	switch (width) {
 	case 8:
 		*val = readb(addr);

--------------080701020304030906000802--
