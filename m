Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707Ab1ETBfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:35:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab1ETBfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:35:04 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=pJ5yP7gRbZIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=MeVYgdFwPMIIkXEnZCgA:9 a=fyxMjYPW38FCaKpujKoA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=fvALLuF9yr0A11ON:21 a=ybrB_wvXb61_qH5J:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] extable: Make sure all archs define _sdata
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "JamesE.J.Bottomley" <jejb@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 19 May 2011 21:34:58 -0400
Message-ID: <1305855298.1465.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I get an Acked-by (or comment) from the following Maintainers:

  alpha
  m32r
  m68k
  mips
  parisc

Ingo has discovered that one of my patches broke the builds of these
architectures. Although he added a quick fix, this patch supplies the
proper fix and touches the affected architectures. Please review and Ack
(or NACK with guidance) this patch.

-- Steve

A new utility function is used to determine if a passed in address is
part of core kernel data or not. It may or may not return true for RO
data, but this utility must work for RW data. Thus both _sdata and
_edata must be defined and continuous, without .init sections that may
later be freed and replaced by volatile memory (memory that can be
freed).

This utility function is used to determine if data is safe from ever
being freed. Thus it should return true for all RW global data that is
not in a module or has been allocated, or false otherwise.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
----
 arch/alpha/kernel/vmlinux.lds.S   |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    1 +
 arch/m68k/kernel/vmlinux-std.lds  |    2 ++
 arch/m68k/kernel/vmlinux-sun3.lds |    1 +
 arch/mips/kernel/vmlinux.lds.S    |    1 +
 arch/parisc/kernel/vmlinux.lds.S  |    3 +++
 kernel/extable.c                  |   12 +++++++++++-
 7 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 433be2a..3d890a9 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -46,6 +46,7 @@ SECTIONS
 	__init_end = .;
 	/* Freed after init ends here */
 
+	_sdata = .;	/* Start of rw data section */
 	_data = .;
 	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index c194d64..cf95aec 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -44,6 +44,7 @@ SECTIONS
   EXCEPTION_TABLE(16)
   NOTES
 
+  _sdata = .;			/* Start of data section */
   RODATA
   RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
   _edata = .;			/* End of data section */
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 878be5f..d099359 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -25,6 +25,8 @@ SECTIONS
 
   EXCEPTION_TABLE(16)
 
+  _sdata = .;			/* Start of data section */
+
   RODATA
 
   RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE)
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 1ad6b7a..8080469 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -25,6 +25,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   EXCEPTION_TABLE(16) :data
+  _sdata = .;			/* Start of rw data section */
   RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE) :data
   /* End of data goes *here* so that freeing init code works properly. */
   _edata = .;
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 832afbb..60b8af3 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -65,6 +65,7 @@ SECTIONS
 	NOTES :text :note
 	.dummy : { *(.dummy) } :text
 
+	_sdata = .;			/* Start of data section */
 	RODATA
 
 	/* writeable */
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 8f1e4ef..2d9a5c7 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -69,6 +69,9 @@ SECTIONS
 	/* End of text section */
 	_etext = .;
 
+	/* Start of data section */
+	_sdata = .;
+
 	RODATA
 
 	/* writeable */
diff --git a/kernel/extable.c b/kernel/extable.c
index d44aac0..5339705 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -72,9 +72,19 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+/**
+ * core_kernel_data - tell if addr points to kernel data
+ * @addr: address to test
+ *
+ * Returns true if @addr passed in is from the core kernel data
+ * section.
+ *
+ * Note: On some archs it may return true for core RODATA, and false
+ *  for others. But will always be true for core RW data.
+ */
 int core_kernel_data(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext &&
+	if (addr >= (unsigned long)_sdata &&
 	    addr < (unsigned long)_edata)
 		return 1;
 	return 0;


