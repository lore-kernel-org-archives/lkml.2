Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0DVTk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:40:57 -0400
Received: from kroah.org ([198.145.64.141]:41377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0DVT3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:30 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.825534147@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Dave Airlie <airlied@redhat.com>
Subject: [151/197] agp/hp: fixup hp agp after ACPI changes
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

commit 67fe63b0715ccfaefa0af8a6e705c5470ee5cada upstream.

Commit 15b8dd53f5ffa changed the string in info->hardware_id from a static
array to a pointer and added a length field.  But instead of changing
"sizeof(array)" to "length", we changed it to "sizeof(length)" (== 4),
which corrupts the string we're trying to null-terminate.

We no longer even need to null-terminate the string, but we *do* need to
check whether we found a HID.  If there's no HID, we used to have an empty
array, but now we have a null pointer.

The combination of these defects causes this oops:

  Unable to handle kernel NULL pointer dereference (address 0000000000000003)
  modprobe[895]: Oops 8804682956800 [1]
  ip is at zx1_gart_probe+0xd0/0xcc0 [hp_agp]

  http://marc.info/?l=linux-ia64&m=126264484923647&w=2

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Émeric Maschino <emeric.maschino@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/hp-agp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -488,9 +488,8 @@ zx1_gart_probe (acpi_handle obj, u32 dep
 	handle = obj;
 	do {
 		status = acpi_get_object_info(handle, &info);
-		if (ACPI_SUCCESS(status)) {
+		if (ACPI_SUCCESS(status) && (info->valid & ACPI_VALID_HID)) {
 			/* TBD check _CID also */
-			info->hardware_id.string[sizeof(info->hardware_id.length)-1] = '\0';
 			match = (strcmp(info->hardware_id.string, "HWP0001") == 0);
 			kfree(info);
 			if (match) {


