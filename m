Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2JOQOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:14:23 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:24596 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2JOQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:14:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,588,1344211200"; 
   d="scan'208";a="15176276"
Message-ID: <1350317658.18058.84.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: add quirk for Xen
 3.4 and shutdown watches.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 15 Oct 2012 17:14:18 +0100
In-Reply-To: <1350317146.18058.83.camel@zakaz.uk.xensource.com>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
	 <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
	 <1350317146.18058.83.camel@zakaz.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 17:05 +0100, Ian Campbell wrote:
> 
> > +static bool xen_strict_xenbus_quirk()
> > +{
> > +     uint32_t eax, ebx, ecx, edx, base;
> > +
> > +     base = xen_cpuid_base();
> > +     cpuid(base + 1, &eax, &ebx, &ecx, &edx);
> 
> This breaks on ARM because this is an x86 specific function. Can we
> ifdef it or properly wrap it in an arch interface please. 

Quick-n-dirty fix. 

8<----------------------------

>From fe19515d8f7bed49c4474f475e6a8cbbdc5eb3f2 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 15 Oct 2012 17:06:47 +0100
Subject: [PATCH] xen: fix build on ARM

xen_strict_xenbus_quirk is x86 specific.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/xenbus/xenbus_xs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 48220e1..b46ad11 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -619,6 +619,8 @@ static struct xenbus_watch *find_watch(const char *token)
 
 	return NULL;
 }
+
+#ifdef CONFIG_X86
 /*
  * Certain older XenBus toolstack cannot handle reading values that are
  * not populated. Some Xen 3.4 installation are incapable of doing this
@@ -637,6 +639,10 @@ static bool xen_strict_xenbus_quirk()
 	return false;
 
 }
+#else
+static bool xen_strict_xenbus_quirk(void) { return false; }
+#endif
+
 static void xs_reset_watches(void)
 {
 	int err, supported = 0;
-- 
1.7.2.5



