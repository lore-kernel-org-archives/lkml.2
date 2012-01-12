Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2ALQm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:42:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49536 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2ALQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:42:24 -0500
Date: Thu, 12 Jan 2012 11:40:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xensource.com>
Subject: Re: linux 3.3-pre-rc1: Starting domU fails with Error: Failed to
 query current memory allocation of dom0.
Message-ID: <20120112164025.GA22773@phenom.dumpdata.com>
References: <498097597.20120112133832@eikelenboom.it>
 <20120112154613.GA10148@phenom.dumpdata.com>
 <CAPXgP1373C5SfzU-rfo5GG53dUE6dVzECSuKzX1c_FirpXQt2g@mail.gmail.com>
 <20120112161204.GC10269@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112161204.GC10269@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F0F0D6C.0032,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:12:04AM -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 12, 2012 at 05:05:34PM +0100, Kay Sievers wrote:
> > On Thu, Jan 12, 2012 at 16:46, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > > On Thu, Jan 12, 2012 at 01:38:32PM +0100, Sander Eikelenboom wrote:
> > 
> > >> Today i tried linuses tree of today (last commit is 4c4d285ad5665bfbd983b95fde8d7a477d24a361).
> > >>
> > >> It boots dom0 fine, but it fails to start any domU with: "Error: Failed to query current memory allocation of dom0."
> > >> With my previous 3.1.5 kernel everything is fine, nothing else changed in config in between.
> > > Your patch that converts the xen-balloon to use the regular device bus driver
> > > (070680218379e15c1901f4bf21b98e3cbf12b527) has some not-so-happy consequences.
> > >
> > > The toolstack (xen-tools) use:
> > >
> > > /sys/devices/system/xen_memory/xen_memory0
> > >
> > > But with the change, it is now:
> > >
> > > /sys/devices/xen_memory0/target_kb
> > 
> > Urks, seems like a mistake on my side.
> > 
> > Please try if changing:
> >   bus_unregister(&balloon_subsys);
> > to:
> >   subsys_system_register(&balloon_subsys, NULL);
> > in:
> >   drivers/xen/xen-balloon.c
> > fixes the issue.
> 
> Heh. I was *just* looking at d369a5d8fc70710236ae2d06a0e42dce483712df
> ("clocksource: convert sysdev_class to a regular subsystem") and typed up this patch
> to try it out:

Kay, are you Acking this patch? (I can send it to Linus for rc0 or rc1)

commit 4e6f161986678a25c9e76af98df928408c734a27
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Jan 12 11:35:50 2012 -0500

    xen/balloon: Move the registration from device to subsystem.
    
    With git commit 070680218379e15c1901f4bf21b98e3cbf12b527
    "xen-balloon: convert sysdev_class to a regular subsystem" we would
    end up with the attributes being put in:
    
     /sys/devices/xen_memory0/target_kb
    instead of
    /sys/devices/system/xen_memory/xen_memory0/target_kb
    
    Making the tools unable to deflate the kernel to make more space
    for launching another guest and printing:

    Error: Failed to query current memory allocation of dom0
    
    Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
    Suggested-by:  Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 3832e30..596e6a7 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -221,7 +221,7 @@ static int register_balloon(struct device *dev)
 {
 	int i, error;
 
-	error = bus_register(&balloon_subsys);
+	error = subsys_system_register(&balloon_subsys, NULL);
 	if (error)
 		return error;
 
