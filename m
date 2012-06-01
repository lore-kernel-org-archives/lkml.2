Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab2FATL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43186 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab2FATL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:11:27 -0400
Date: Fri, 1 Jun 2012 12:11:06 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-30dc0d0fe5d08396dbdaa2d70972149131340960@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com
In-Reply-To: <1331907517-3985-2-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-2-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Only close open files in error path
Git-Commit-ID: 30dc0d0fe5d08396dbdaa2d70972149131340960
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 01 Jun 2012 12:11:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30dc0d0fe5d08396dbdaa2d70972149131340960
Gitweb:     http://git.kernel.org/tip/30dc0d0fe5d08396dbdaa2d70972149131340960
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Thu, 15 Mar 2012 19:13:25 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 1 Jun 2012 09:11:10 -0700

x86, efi: Only close open files in error path

The loop at the 'close_handles' label in handle_ramdisks() should be
using 'i', which represents the number of initrd files that were
successfully opened, not 'nr_initrds' which is the number of initrd=
arguments passed on the command line.

Currently, if we execute the loop to close all file handles and we
failed to open any initrds we'll try to call the close function on a
garbage pointer, causing the machine to hang.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1331907517-3985-2-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/eboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c14e76..52a4e66 100644
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
