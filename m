Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1EaJ0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:26:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab1EaJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:26:37 -0400
Date: Tue, 31 May 2011 11:26:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Paul Mundt <lethal@linux-sh.org>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 1/2] dmaengine: shdma: fix locking
In-Reply-To: <20110531065051.GA16157@linux-sh.org>
Message-ID: <Pine.LNX.4.64.1105310910160.9491@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
 <Pine.LNX.4.64.1104291908090.17813@axis700.grange>
 <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
 <Pine.LNX.4.64.1104291906140.17813@axis700.grange> <20110531065051.GA16157@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jCTfQEM9bGIrEJoiCE5AeS0N3neeeX7xDaY33dmIISt
 b3va58dLFPz4gSOw+GyvMx+SjKUCf6/4QPciSgzpMjZJ4x/wd3
 2W4w8nCxpHOMSNSTHWIqfKuSSGt2hrCxl41n0wltm5V10Uh0eM
 w1USq5xuWXqJNjH5EU/2IX3QkJTjwvd2IGhDKH7WTtzeAQCloG
 yDIjMqNyi+ts9hymrez8TKStLYwCt9TOeMVap3jWvw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Paul Mundt wrote:

> On Fri, Apr 29, 2011 at 07:09:21PM +0200, Guennadi Liakhovetski wrote:
> >  static int sh_dmae_rst(struct sh_dmae_device *shdev)
> >  {
> ..
> > +	dmaor_write(shdev, dmaor | shdev->pdata->dmaor_init);
> 
> On Fri, Apr 29, 2011 at 07:09:25PM +0200, Guennadi Liakhovetski wrote:
> > +static int sh_dmae_runtime_resume(struct device *dev)
> > +{
> > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > +
> > +	return sh_dmae_rst(shdev);
> ..
> 
> Yet in sh_dmae_probe() we have:
> 
>         shdev->pdata = pdata;
> 
>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_get_sync(&pdev->dev);
> 
> ..
> 
>         /* reset dma controller - only needed as a test */
>         err = sh_dmae_rst(shdev);
>         if (err)
>                 goto rst_err;
> 
> ..
> 
>         pm_runtime_put(&pdev->dev);
> 
>         platform_set_drvdata(pdev, shdev);
>         dma_async_device_register(&shdev->common);
> 
>         return err;
> ..
> 
> So I'm wondering how this was ever actually tested. The original sh_dmae_rst()
> call is safe due to passing along the shdev pointer with pdata initialized
> explicitly, while the runtime PM bits fetch the pointer via dev_get_drvdata()
> at a time where drvdata hasn't even been initialized yet, resulting in a rather
> predictable oops:

Ok, I tested it on ARM mainly, maybe only:-( And there the rtpm seems to 
function differently, resulting in resume not being called from probe. 
Even now, testing Linus' head (from yesterday) I'm not getting this Oops 
on ARM. So, have to test on both ARM and SH then, especially everything, 
concerning rtpm...

Thanks for spotting and fixing!
Guennadi

> 	Unable to handle kernel NULL pointer dereference at virtual address 000000c4
> 	pc = 8025adee
> 	*pde = 00000000
> 	Oops: 0000 [#1]
> 	Modules linked in:
> 
> 	Pid : 1, Comm:           swapper
> 	CPU : 0                  Not tainted  (3.0.0-rc1-00012-g9436b4a-dirty #1456)
> 
> 	PC is at sh_dmae_rst+0x28/0x86
> 	PR is at sh_dmae_rst+0x22/0x86
> 	PC  : 8025adee SP  : 9e803d10 SR  : 400080f1 TEA : 000000c4
> 	R0  : 000000c4 R1  : 0000fff8 R2  : 00000000 R3  : 00000040
> 	R4  : 000000f0 R5  : 00000000 R6  : 00000000 R7  : 804f184c
> 	R8  : 00000000 R9  : 804dd0e8 R10 : 80283204 R11 : ffffffda
> 	R12 : 000000a0 R13 : 804dd18c R14 : 9e803d10
> 	MACH: 00000000 MACL: 00008f20 GBR : 00000000 PR  : 8025ade8
> 
> 	Call trace:
> 	[<8025ae70>] sh_dmae_runtime_resume+0x24/0x34
> 	[<80283238>] pm_generic_runtime_resume+0x34/0x3c
> 	[<80283370>] rpm_callback+0x4a/0x7e
> 	[<80283efc>] rpm_resume+0x240/0x384
> 	[<80283f54>] rpm_resume+0x298/0x384
> 	[<8028428c>] __pm_runtime_resume+0x44/0x7c
> 	[<8038a358>] __ioremap_caller+0x0/0xec
> 	[<80284296>] __pm_runtime_resume+0x4e/0x7c
> 	[<8038a358>] __ioremap_caller+0x0/0xec
> 	[<80666254>] sh_dmae_probe+0x180/0x6a0
> 	[<802803ae>] platform_drv_probe+0x26/0x2e
> 
> I've fixed this up now, but I am growing rather weary of applying anything with
> runtime PM in the subject that alleges to have been tested.
> 
> The next runtime PM patch that doesn't even boot will be immediately reverted
> and have a kernel version or two to sit things out in order to try to get
> things in demonstrable functional order.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
