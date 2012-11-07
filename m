Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2KGP75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:59:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40921 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2KGP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:59:56 -0500
Date: Wed, 7 Nov 2012 10:47:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/generic: Disable fallback build on
 ARM.
Message-ID: <20121107154701.GA18615@phenom.dumpdata.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
 <1352239982-17389-2-git-send-email-konrad.wilk@oracle.com>
 <1352272794.12977.17.camel@hastur.hellion.org.uk>
 <509A2C2402000078000A6EB9@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509A2C2402000078000A6EB9@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 08:38:44AM +0000, Jan Beulich wrote:
> >>> On 07.11.12 at 08:19, Ian Campbell <ian.campbell@citrix.com> wrote:
> > On Tue, 2012-11-06 at 22:13 +0000, Konrad Rzeszutek Wilk wrote:
> >> As there is no need for it (the fallback code is for older
> >> hypervisors and they won't run under ARM), 
> > 
> > I think more specifically they won't run on anything other than x86.
> > 
> > [...]
> >> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> >> index 46de6cd..273d2b9 100644
> >> --- a/drivers/xen/Makefile
> >> +++ b/drivers/xen/Makefile
> >> @@ -1,8 +1,8 @@
> >>  ifneq ($(CONFIG_ARM),y)
> >> -obj-y	+= manage.o balloon.o
> >> +obj-y	+= manage.o balloon.o fallback.o
> >>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> >>  endif
> > 
> > I think :
> >   obj-$(CONFIG_X86) += fallback.o
> > would better reflect what is going on here.
> 
> Yes please.


>From 6bf926ddd44ddc67edbeb28d4069f207f2c6e07e Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 6 Nov 2012 15:49:27 -0500
Subject: [PATCH 1/2] xen/generic: Disable fallback build on ARM.

As there is no need for it (the fallback code is for older
hypervisors and they only run under x86), and also b/c
we get:

drivers/xen/fallback.c: In function 'xen_event_channel_op_compat':
drivers/xen/fallback.c:10:19: error: storage size of 'op' isn't known
drivers/xen/fallback.c:15:2: error: implicit declaration of function '_hypercall1' [-Werror=implicit-function-declaration]
drivers/xen/fallback.c:15:19: error: expected expression before 'int'
drivers/xen/fallback.c:18:7: error: 'EVTCHNOP_close' undeclared (first use in this function)
drivers/xen/fallback.c:18:7: note: each undeclared identifier is reported only once for each function it appears in
.. and more

[v1: Moved the enablement to be covered by CONFIG_X86 per Ian's suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 46de6cd..7435470 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -2,7 +2,8 @@ ifneq ($(CONFIG_ARM),y)
 obj-y	+= manage.o balloon.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
-obj-y	+= grant-table.o features.o events.o fallback.o
+obj-$(CONFIG_X86)			+= fallback.o
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
-- 
1.7.7.6


> 
> Jan
