Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161347Ab2CPOTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:19:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33353 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031183Ab2CPOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:18:43 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garret <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/3] x86, efi: Only close open files in error path
Date: Fri, 16 Mar 2012 14:18:35 +0000
Message-Id: <1331907517-3985-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The loop at the 'close_handles' label in handle_ramdisks() should be
using 'i', which represents the number of initrd files that were
successfully opened, not 'nr_initrds' which is the number of initrd=
arguments passed on the command line.

Currently, if we execute the loop to close all file handles and we
failed to open any initrds we'll try to call the close function on a
garbage pointer, causing the machine to hang.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..fb810ce 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -674,7 +674,7 @@ free_initrd_total:
 	low_free(initrd_total, initrd_addr);
 
 close_handles:
-	for (k = j; k < nr_initrds; k++)
+	for (k = j; k < i; k++)
 		efi_call_phys1(fh->close, initrds[k].handle);
 free_initrds:
 	efi_call_phys1(sys_table->boottime->free_pool, initrds);
-- 
1.7.4.4

