Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2E0BMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:12:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2E0BMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:12:25 -0400
Message-Id: <20120527010435.037842943@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 80/94] x86-32, relocs: Whitelist more symbols for ld bug workaround
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit fd952815307f0f272bf49fd364a7fd2f9992bc42 upstream.

As noted in checkin:

a3e854d95 x86, relocs: Workaround for binutils 2.22.52.0.1 section bug

ld version 2.22.52.0.[12] can incorrectly promote relative symbols to
absolute, if the output section they appear in is otherwise empty.

Since checkin:

6520fe55 x86, realmode: 16-bit real-mode code support for relocs tool

we actually check for this and error out rather than silently creating
a kernel which will malfunction if relocated.

Ingo found a configuration in which __start_builtin_fw triggered the
warning.

Go through the linker script sources and look for more symbols that
could plausibly get bogusly promoted to absolute, and add them to the
whitelist.

In general, if the following error triggers:

	Invalid absolute R_386_32 relocation: <symbol>

... then we should verify that <symbol> is really meant to be
relocated, and add it and any related symbols manually to the S_REL
regexp.

Please note that 6520fe55 does not introduce the error, only the check
for the error -- without 6520fe55 this version of ld will simply
produce a corrupt kernel if CONFIG_RELOCATABLE is set on x86-32.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/tools/relocs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -60,6 +60,17 @@ static const char * const sym_regex_kern
 	"__x86_cpu_dev_(start|end)|"
 	"(__parainstructions|__alt_instructions)(|_end)|"
 	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"__(start|end)_pci_.*|"
+	"__(start|end)_builtin_fw|"
+	"__(start|stop)___ksymtab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___kcrctab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___param|"
+	"__(start|stop)___modver|"
+	"__(start|stop)___bug_table|"
+	"__tracedata_(start|end)|"
+	"__(start|stop)_notes|"
+	"__end_rodata|"
+	"__initramfs_start|"
 	"_end)$"
 };
 


