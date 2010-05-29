Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0E2NDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:03:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0E2NDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z0EY3Pk/baoEwHg/mg8P62bEHLm7xbu8kypCftF/gxfMYLXjf7AZG/jviNVkuoM04u
         f1X6/2l2QOsZkpIQhk2Kqb68ZTa79SGEF85TUN+hvccc67JpowUZUQ/5Qjf1al8iTXHJ
         i5MHsHLmEQjmy77CdLBNz7o+uhoWEMPw9hohs=
Date: Sat, 29 May 2010 17:02:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] perf, x86: should perf_event_x.c being compiled
	conditionally?
Message-ID: <20100529130254.GH5322@lenovo>
References: <20100528213503.GJ20839@lenovo> <1275118737.27810.12590.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275118737.27810.12590.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 09:38:57AM +0200, Peter Zijlstra wrote:
> On Sat, 2010-05-29 at 01:35 +0400, Cyrill Gorcunov wrote:
> > Hi,
> > 
> > while was building the kernel for pretty old laptop I've noticed
> > that perf_event_x.c depends on CONFIG_CPU_SUP_ only. So I'm somehow
> > confused. Should not some additional condition being used?
> > 
> > For example if a person have Core 2 or Nehalem machine, he will
> > definitely not need p6 and p4 events (yes, they are not _that_ big
> > in size, but anyway).
> > 
> > On the other hands distro builders would prefer to have all compiled in.
> > 
> > Not sure about what is the best way to resolve this, but perhaps I'm just
> > missing some key moment?
> 
> We had to split out on the CPU_SUP_* stuff because the AMD support
> relies on symbols otherwise not present.
> 
> So fixing build dependencies is the main reason we have that.
> 
> If you want to extend it, feel free, but be sure to test the
> full .config space ;-)
> 

Thanks for explanation. I guess we may have something like below.
Note that I didn't squeeze into *.c files, only Kconfig is touched
so that we get "Processor type and features" -> "Supported Perfomance
Events" menu. All entries are "Y" by default and depends on
PERF_EVENTS && CPU_SUP_INTEL (since we have this trick for Intel
cpus only at moment). Just an idea.

	-- Cyrill
---
 arch/x86/Kconfig.cpu      |    4 ++++
 arch/x86/Kconfig.cpu.perf |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

Index: linux-2.6.git/arch/x86/Kconfig.cpu
=====================================================================
--- linux-2.6.git.orig/arch/x86/Kconfig.cpu
+++ linux-2.6.git/arch/x86/Kconfig.cpu
@@ -506,3 +506,7 @@ config CPU_SUP_UMC_32
 	  CPU might render the kernel unbootable.
 
 	  If unsure, say N.
+
+#
+# Performance event specifics
+source "arch/x86/Kconfig.cpu.perf"
Index: linux-2.6.git/arch/x86/Kconfig.cpu.perf
=====================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/Kconfig.cpu.perf
@@ -0,0 +1,31 @@
+if PERF_EVENTS && CPU_SUP_INTEL
+menu "Supported Performance Events"
+
+config PERF_EVENTS_INTEL
+	bool "Intel Architectural Performance Events"
+	default y
+	---help---
+	  Intel Architectural Performance Events (Architectural PerfMon version 2
+	  and later). Includes support for Core/Core2/Atom/Nehalem CPU families.
+
+	  If unsure say Y.
+
+config PERF_EVENTS_INTEL_NETBURST
+	bool "Netburst Performance Events"
+	default y
+	---help---
+	  Netburst family performance events (Pentium 4, old Xeons).
+
+	  If unsure say Y.
+
+config PERF_EVENTS_INTEL_P6
+	bool "P6 family Performance Events"
+	default y
+	---help---
+	  P6 family performance events (Pentium Pro, Pentium II,
+	  Pentium III, Pentium M).
+
+	  If unsure say Y.
+
+endmenu
+endif
