Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1I1WpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab1I1WpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220141.125634098@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [150/244] xen: use maximum reservation to limit amount of usable RAM
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit d312ae878b6aed3912e1acaaf5d0b2a9d08a4f11 upstream.

Use the domain's maximum reservation to limit the amount of extra RAM
for the memory balloon. This reduces the size of the pages tables and
the amount of reserved low memory (which defaults to about 1/32 of the
total RAM).

On a system with 8 GiB of RAM with the domain limited to 1 GiB the
kernel reports:

Before:

Memory: 627792k/4472000k available

After:

Memory: 549740k/11132224k available

A increase of about 76 MiB (~1.5% of the unused 7 GiB).  The reserved
low memory is also reduced from 253 MiB to 32 MiB.  The total
additional usable RAM is 329 MiB.

For dom0, this requires at patch to Xen ('x86: use 'dom0_mem' to limit
the number of pages for dom0') (c/s 23790)

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/setup.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -185,6 +185,19 @@ static unsigned long __init xen_set_iden
 					PFN_UP(start_pci), PFN_DOWN(last));
 	return identity;
 }
+
+static unsigned long __init xen_get_max_pages(void)
+{
+	unsigned long max_pages = MAX_DOMAIN_PAGES;
+	domid_t domid = DOMID_SELF;
+	int ret;
+
+	ret = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
+	if (ret > 0)
+		max_pages = ret;
+	return min(max_pages, MAX_DOMAIN_PAGES);
+}
+
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
@@ -293,6 +306,12 @@ char * __init xen_memory_setup(void)
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
+	extra_limit = xen_get_max_pages();
+	if (extra_limit >= max_pfn)
+		extra_pages = extra_limit - max_pfn;
+	else
+		extra_pages = 0;
+
 	extra_pages += xen_return_unused_memory(xen_start_info->nr_pages, &e820);
 
 	/*


