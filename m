Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2IMATO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:19:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab2ILXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 106/108] x86, microcode, AMD: Fix broken ucode patch size check
Date: Wed, 12 Sep 2012 16:29:44 -0700
Message-Id: <20120912232501.617772157@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 36bf50d7697be18c6bfd0401e037df10bff1e573 upstream.

This issue was recently observed on an AMD C-50 CPU where a patch of
maximum size was applied.

Commit be62adb49294 ("x86, microcode, AMD: Simplify ucode verification")
added current_size in get_matching_microcode(). This is calculated as
size of the ucode patch + 8 (ie. size of the header). Later this is
compared against the maximum possible ucode patch size for a CPU family.
And of course this fails if the patch has already maximum size.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-1-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_amd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -143,11 +143,12 @@ static int get_matching_microcode(int cp
 				  unsigned int *current_size)
 {
 	struct microcode_header_amd *mc_hdr;
-	unsigned int actual_size;
+	unsigned int actual_size, patch_size;
 	u16 equiv_cpu_id;
 
 	/* size of the current patch we're staring at */
-	*current_size = *(u32 *)(ucode_ptr + 4) + SECTION_HDR_SIZE;
+	patch_size = *(u32 *)(ucode_ptr + 4);
+	*current_size = patch_size + SECTION_HDR_SIZE;
 
 	equiv_cpu_id = find_equiv_id();
 	if (!equiv_cpu_id)
@@ -174,7 +175,7 @@ static int get_matching_microcode(int cp
 	/*
 	 * now that the header looks sane, verify its size
 	 */
-	actual_size = verify_ucode_size(cpu, *current_size, leftover_size);
+	actual_size = verify_ucode_size(cpu, patch_size, leftover_size);
 	if (!actual_size)
 		return 0;
 


