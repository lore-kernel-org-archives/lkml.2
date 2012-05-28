Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2E1Dgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52184 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab2E1D3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:43 -0400
Message-Id: <20120528031218.870211329@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 116/117] x86-32, relocs: Whitelist more symbols for ld bug workaround
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/tools/relocs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b43cfcd..b8f7c65 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -60,6 +60,17 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
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
 


