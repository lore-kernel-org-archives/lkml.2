Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0KINqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:46:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41273 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KINqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:46:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iOC0r06EQCd4sysPBSe6x2GG4PpuuyT8yc5H+VKJ/qq1d7VCFrA4Ou9uQrT5gqeREc
         l6xxAc7Dgb1RrpxirCcty6m/bQMt9EwcU0quFCy+KVv+AT+djSd1Y274MJ7dPRpPyVM9
         gegdRnpIW6UaDitXm30d0ZCEU56VqZh/k0HF0=
Date: Tue, 9 Nov 2010 19:16:45 +0530
From: Rabin Vincent <rabin@rab.in>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 6/6] ARM: ftrace: enable function graph tracer
Message-ID: <20101109134644.GA3163@debian>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
 <1289067954-5080-6-git-send-email-rabin@rab.in>
 <AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
 <20101108091858.GP16938@pengutronix.de>
 <AANLkTinmSn1fqKv8sCCP8d0-_0HsLrhtorXvHCovOYve@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinmSn1fqKv8sCCP8d0-_0HsLrhtorXvHCovOYve@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:42:57AM +0000, Catalin Marinas wrote:
> 2010/11/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > On Sat, Nov 06, 2010 at 07:06:28PM +0000, Catalin Marinas wrote:
> >> On Saturday, November 6, 2010, Rabin Vincent <rabin@rab.in> wrote:
> >> > --- a/kernel/trace/Kconfig
> >> > +++ b/kernel/trace/Kconfig
> >> > @@ -141,6 +141,7 @@ config FUNCTION_TRACER
> >> >
> >> >  config FUNCTION_GRAPH_TRACER
> >> >         bool "Kernel Function Graph Tracer"
> >> > +       select FRAME_POINTER if ARM_UNWIND
> >>
> >> Would it be better to modify FRAME_POINTER definition in the ARM
> >> Kconfig so that it is enabled automatically when FUNCTION_GRAPH_TRACER
> >> is enabled?
> > I don't like that suggestion much because it hides the dependency.
> > Moreover a "default y if FUNCTION_GRAPH_TRACER" doesn't work if a
> > precondition for FRAME_POINTER isn't true.  Rabin's approach at least
> > generates a warning.
> 
> If a precondition for FRAME_POINTER isn't true, we should not force it
> via 'select'. We try to get rid of such warnings in the kernel.
> 
> However, on ARM the FRAME_POINTER depends on !THUMB2_KERNEL but for
> Thumb-2 kernels HAVE_FUNCTION_GRAPH_TRACER is also disabled, so there
> isn't a dependency issue here. It's more like a personal preference to
> keep the changes within the arch/arm tree.

OK, new patch below.

>From ce3856933234b0976068be8bdc46340dcf31ef6f Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 6 Nov 2010 23:03:53 +0530
Subject: [PATCHv2] ARM: ftrace: enable function graph tracer

Add the options to enable the function graph tracer on ARM.  Function
graph tracer support requires frame pointers, so exclude Thumb-2 and
also make sure FRAME_POINTER gets enabled when FUNCTION_GRAPH_TRACER is
used, since FUNCTION_TRACER doesn't "select FRAME_POINTER" when
ARM_UNWIND is used.  Therefore, with GCC 4.4.0+, you get plain function
tracing without frame pointers, but you'll need them if you want
function graph tracing.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig       |    1 +
 arch/arm/Kconfig.debug |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..c5e96ff 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 2fd0b99..eac62085 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -23,7 +23,7 @@ config STRICT_DEVMEM
 config FRAME_POINTER
 	bool
 	depends on !THUMB2_KERNEL
-	default y if !ARM_UNWIND
+	default y if !ARM_UNWIND || FUNCTION_GRAPH_TRACER
 	help
 	  If you say N here, the resulting kernel will be slightly smaller and
 	  faster. However, if neither FRAME_POINTER nor ARM_UNWIND are enabled,
-- 
1.7.2.3

