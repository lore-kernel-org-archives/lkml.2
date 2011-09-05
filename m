Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1IECuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:50:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:9760 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab1IECuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,330,1312182000"; 
   d="scan'208";a="48105841"
Message-ID: <4E6438DC.4010007@intel.com>
Date: Mon, 05 Sep 2011 10:50:04 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: "rick@microway.com" <rick@microway.com>
CC: Don Zickus <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Houghton <rhoughton@microway.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
References: <201108171751.51648.rick@microway.com>    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>    <20110823171432.GA10794@redhat.com>    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>    <4E547B0F.6000001@intel.com>    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>    <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>    <4E56EA02.7020307@intel.com> <50815a5ec08cdb713de8eaa92ad6e8b3.squirrel@www.microway.com>
In-Reply-To: <50815a5ec08cdb713de8eaa92ad6e8b3.squirrel@www.microway.com>
Content-Type: multipart/mixed;
 boundary="------------010006040808060302090309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010006040808060302090309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/03/2011 07:32 AM, rick@microway.com wrote:
> Hi Huang,
> 
> Sorry for the delay in my response.  Hurricane Irene delayed our testing a
> bit.
> 
> I had to switch the 5620 CPUS I had for 5670s.  After 4 days of running
> (it was usually about 2 before) I finally got this output in dmesg:
> 
> [337296.365930] GHES: gar accessed: 0, 0xbf7b9370
> [337296.365936] ACPI atomic read mem: addr 0xbf7b9370 mapped to
> ffffc90013ee8370
> 
> It is not mapped to 0 as expected, but it didn't crash now!

But I don't think this patch fixed the issue.  Maybe just hided the
issue.  Do you have time to try the new patch attached?

Best Regards,
Huang Ying


--------------010006040808060302090309
Content-Type: text/x-patch;
 name="dbg_ghes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dbg_ghes.patch"

---
 drivers/acpi/apei/ghes.c |    6 ++++++
 drivers/acpi/atomicio.c  |    2 ++
 2 files changed, 8 insertions(+)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -299,6 +299,9 @@ static struct ghes *ghes_new(struct acpi
 		return ERR_PTR(-ENOMEM);
 	ghes->generic = generic;
 	rc = acpi_pre_map_gar(&generic->error_status_address);
+	pr_info(GHES_PFX "gar mapped: %d, %#llx\n",
+		generic->error_status_address.space_id,
+		generic->error_status_address.address);
 	if (rc)
 		goto err_free;
 	error_block_length = generic->error_block_length;
@@ -398,6 +401,9 @@ static int ghes_read_estatus(struct ghes
 	u32 len;
 	int rc;
 
+	pr_err(GHES_PFX "gar accessed: %d, %#llx\n",
+	       g->error_status_address.space_id,
+	       g->error_status_address.address);
 	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
 		if (!silent && printk_ratelimit())
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -270,6 +270,8 @@ static int acpi_atomic_read_mem(u64 padd
 
 	rcu_read_lock();
 	addr = __acpi_ioremap_fast(paddr, width);
+	if (!addr)
+		panic("ACPI atomic read mem: addr %#llx is not mapped!\n", paddr);
 	switch (width) {
 	case 8:
 		*val = readb(addr);

--------------010006040808060302090309--
