Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1A0OvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:51:10 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:42159 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1A0OvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:51:09 -0500
Date: Thu, 27 Jan 2011 15:48:43 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: linux-kernel@vger.kernel.org, stable@kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        mingo@redhat.com, mingo@elte.hu
Subject: [PATCH] xen: convert p2m to a 3 level tree - partial revert
Message-ID: <20110127144843.GA23746@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Durning work on Xen memory hotplug I discoverd that
2.6.38-rc2 does not boot on domU. After some investigation
it appeared that 58e05027b530ff081ecea68e38de8d59db8f87e0
commit changed CONFIG_XEN_MAX_DOMAIN_MEMORY constant value
to 128. This change does not allow to boot kernel on domU
with small memory size (I could confirm that it is even
not possible to boot kernel on domU with 2 GiB). Guest
crash silently without any warning. Durning further
research I found out that there is another commit published
recently (8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b) which attempts
to fix this issue, however, it does not work on my platform.
I decided to reenable CONFIG_XEN_MAX_DOMAIN_MEMORY option in
kernel config and enable users to choose resonable values for
their machines until better fix will be published. I think this
solution is good because allow users to boot domU with newest
kernel and allow developers to continue their work without
time presure which could lead to new bugs.

This patch applies cleanly to current Linus' kernel tree.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 5b54892..a234b9a 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -29,12 +29,15 @@ config XEN_PVHVM
 	depends on X86_LOCAL_APIC
 
 config XEN_MAX_DOMAIN_MEMORY
-       int
-       default 128
+       int "Maximum allowed size of a domain in gigabytes"
+       default 8 if X86_32
+       default 32 if X86_64
        depends on XEN
        help
-         This only affects the sizing of some bss arrays, the unused
-         portions of which are freed.
+         The pseudo-physical to machine address array is sized
+         according to the maximum possible memory size of a Xen
+         domain.  This array uses 1 page per gigabyte, so there's no
+         need to be too stingy here.
 
 config XEN_SAVE_RESTORE
        bool
-- 
1.5.6.5
