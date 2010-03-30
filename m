Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab0C3Xxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:53:34 -0400
Received: from kroah.org ([198.145.64.141]:45731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab0C3XT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:27 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:31 2010
Message-Id: <20100330224731.222946982@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [017/156] x86_64, cpa: Dont work hard in preserving kernel 2M mappings when using 4K already
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 281ff33b7c1b1ba2a5f9b03425e5f692a94913fa upstream.

We currently enforce the !RW mapping for the kernel mapping that maps
holes between different text, rodata and data sections. However, kernel
identity mappings will have different RWX permissions to the pages mapping to
text and to the pages padding (which are freed) the text, rodata sections.
Hence kernel identity mappings will be broken to smaller pages. For 64-bit,
kernel text and kernel identity mappings are different, so we can enable
protection checks that come with CONFIG_DEBUG_RODATA, as well as retain 2MB
large page mappings for kernel text.

Konrad reported a boot failure with the Linux Xen paravirt guest because of
this. In this paravirt guest case, the kernel text mapping and the kernel
identity mapping share the same page-table pages. Thus forcing the !RW mapping
for some of the kernel mappings also cause the kernel identity mappings to be
read-only resulting in the boot failure. Linux Xen paravirt guest also
uses 4k mappings and don't use 2M mapping.

Fix this issue and retain large page performance advantage for native kernels
by not working hard and not enforcing !RW for the kernel text mapping,
if the current mapping is already using small page mapping.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1266522700.2909.34.camel@sbs-t61.sc.intel.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -291,8 +291,29 @@ static inline pgprot_t static_protection
 	 */
 	if (kernel_set_to_readonly &&
 	    within(address, (unsigned long)_text,
-		   (unsigned long)__end_rodata_hpage_align))
-		pgprot_val(forbidden) |= _PAGE_RW;
+		   (unsigned long)__end_rodata_hpage_align)) {
+		unsigned int level;
+
+		/*
+		 * Don't enforce the !RW mapping for the kernel text mapping,
+		 * if the current mapping is already using small page mapping.
+		 * No need to work hard to preserve large page mappings in this
+		 * case.
+		 *
+		 * This also fixes the Linux Xen paravirt guest boot failure
+		 * (because of unexpected read-only mappings for kernel identity
+		 * mappings). In this paravirt guest case, the kernel text
+		 * mapping and the kernel identity mapping share the same
+		 * page-table pages. Thus we can't really use different
+		 * protections for the kernel text and identity mappings. Also,
+		 * these shared mappings are made of small page mappings.
+		 * Thus this don't enforce !RW mapping for small page kernel
+		 * text mapping logic will help Linux Xen parvirt guest boot
+		 * aswell.
+		 */
+		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
+			pgprot_val(forbidden) |= _PAGE_RW;
+	}
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));


