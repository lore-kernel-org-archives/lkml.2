Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2BALRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:17:01 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:59302 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2BALRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:17:00 -0500
X-IronPort-AV: E=Sophos;i="4.71,601,1320624000"; 
   d="scan'208";a="10411983"
Date: Wed, 1 Feb 2012 11:18:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH v3] hvc_xen: implement multiconsole support
In-Reply-To: <20120201011318.GE32295@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.00.1202011110180.3196@kaball-desktop>
References: <1327939351-22111-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120201011318.GE32295@andromeda.dapyr.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 30, 2012 at 04:02:31PM +0000, Stefano Stabellini wrote:
> > This patch implements support for multiple consoles:
> > consoles other than the first one are setup using the traditional xenbus
> > and grant-table based mechanism.
> > We use a list to keep track of the allocated consoles, we don't
> > expect too many of them anyway.
> >
> 
> So looks good. applied to #testing. How do I test "multiple" consoles?

Interesting question :)

First of all testing a pv console alongside an emulated serial is easy:
by default xl creates a pv console for all hvm guests. So you just need
to start using it (something like console=ttyS0 console=hvc0 on a PV on
HVM guest).
You can connect to the pv console with the following command:

xl console -t pv <domain_name>


Then, in order to test multiple pv consoles, you need the toolstack to
create more than one for you (see appended patch that creates 2 pv
consoles for PV on HVM guests). If you create two pv consoles, you can
connect to the second one with the following command:

xl console -t pv -n 1 <domain_name>

BTW in the patch below I am seeting QEMU as console backend because it
is the only one that can handle multiple pv consoles.


8<----

diff --git a/tools/libxl/libxl_create.c b/tools/libxl/libxl_create.c
index e1c615f..ec2c362 100644
--- a/tools/libxl/libxl_create.c
+++ b/tools/libxl/libxl_create.c
@@ -554,14 +554,21 @@ static int do_domain_create(libxl__gc *gc, libxl_domain_config *d_config,
     switch (d_config->c_info.type) {
     case LIBXL_DOMAIN_TYPE_HVM:
     {
-        libxl_device_console console;
+        libxl_device_console console, console2;
         libxl_device_vkb vkb;
 
         ret = init_console_info(&console, 0);
         if ( ret )
             goto error_out;
+        console.consback = LIBXL_CONSOLE_BACKEND_IOEMU;
         libxl__device_console_add(gc, domid, &console, &state);
         libxl_device_console_dispose(&console);
+        ret = init_console_info(&console2, 1);
+        if ( ret )
+            goto error_out;
+        console2.consback = LIBXL_CONSOLE_BACKEND_IOEMU;
+        libxl__device_console_add(gc, domid, &console2, NULL);
+        libxl_device_console_dispose(&console2);
 
         ret = libxl_device_vkb_init(ctx, &vkb);
         if ( ret )
