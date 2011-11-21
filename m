Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1KUH5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 02:57:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42329 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1KUH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 02:57:39 -0500
Subject: RE: [PATCH] hv: Don't OOPS when can't init vmbus
From: Sasha Levin <levinsasha928@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA70B8E@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1321836494-4624-1-git-send-email-levinsasha928@gmail.com>
	 <6E21E5352C11B742B20C142EB499E0481AA70B8E@TK5EX14MBXC126.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 21 Nov 2011 09:55:31 +0200
Message-ID: <1321862131.3231.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 01:15 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Sasha Levin [mailto:levinsasha928@gmail.com]
> > Sent: Sunday, November 20, 2011 7:48 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Sasha Levin; Greg Kroah-Hartman; KY Srinivasan
> > Subject: [PATCH] hv: Don't OOPS when can't init vmbus
> > 
> > The hv vmbus driver was causing an OOPS since it was trying to register drivers
> > on top of the bus even if initialization of the bus has failed for some
> > reason (such as the odd chance someone would run a hv enabled kernel in a
> > non-hv environment).
> 
> I suspect this must have been the  case where the drivers were being built into the kernel?

Yup.

> 
> > 
> > The following OOPS was happening:
> > 
> > [    2.822634] kernel BUG at drivers/base/driver.c:227!
> > [    2.822734] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [    2.822734] CPU 0
> > [    2.822734] Pid: 1, comm: swapper Not tainted 3.2.0-rc2-sasha-00146-gc729049-
> > dirty #13
> > [    2.822734] RIP: 0010:[<ffffffff81769563>]  [<ffffffff81769563>]
> > driver_register+0x1f/0x104
> > [    2.822734] RSP: 0018:ffff880012499e00  EFLAGS: 00010246
> > [    2.822734] RAX: ffffffff822f9fc0 RBX: ffffffff822fa5e0 RCX: 0000000046494648
> > [    2.822734] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff822fa5e0
> > [    2.822734] RBP: ffff880012499e30 R08: 0000000000000002 R09: ffffffff8221ab98
> > [    2.822734] R10: ffff880012499c20 R11: 0000000000000000 R12:
> > 0000000000000000
> > [    2.822734] R13: ffffffff81ff810a R14: 0000000000000000 R15: 0000000000000000
> > [    2.822734] FS:  0000000000000000(0000) GS:ffff880013a00000(0000)
> > knlGS:0000000000000000
> > [    2.822734] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    2.822734] CR2: 0000000000000000 CR3: 0000000002205000 CR4:
> > 00000000000406f0
> > [    2.822734] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [    2.822734] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > 0000000000000400
> > [    2.822734] Process swapper (pid: 1, threadinfo ffff880012498000, task
> > ffff880012490000)
> > [    2.822734] Stack:
> > [    2.822734]  ffff880012499e60 ffffffff822fa5c0 0000000000000000 ffffffff81ff810a
> > [    2.822734]  0000000000000000 0000000000000000 ffff880012499e60
> > ffffffff8190f991
> > [    2.822734]  ffffffff83388110 ffffffff8274d4a8 ffffffff8269a649 0000000000000000
> > [    2.822734] Call Trace:
> > [    2.822734]  [<ffffffff8190f991>] __vmbus_driver_register+0x47/0x59
> > [    2.822734]  [<ffffffff8269a649>] ? hv_acpi_init+0x199/0x199
> > [    2.822734]  [<ffffffff8269a670>] init_hyperv_utils+0x27/0x29
> > [    2.822734]  [<ffffffff82656c02>] do_one_initcall+0x7a/0x135
> > [    2.822734]  [<ffffffff82656da7>] kernel_init+0xea/0x16f
> > [    2.822734]  [<ffffffff81b99144>] kernel_thread_helper+0x4/0x10
> > [    2.822734]  [<ffffffff81b966b8>] ? retint_restore_args+0x13/0x13
> > [    2.822734]  [<ffffffff82656cbd>] ? do_one_initcall+0x135/0x135
> > [    2.822734]  [<ffffffff81b99140>] ? gs_change+0x13/0x13
> > [    2.822734] Code: d2 74 07 48 8b 82 d0 00 00 00 c9 c3 55 48 89 e5 41 57 41 56 41 55
> > 41 54 53 48 89 fb 48 83 ec 08 48 8b 47 08 48 83 78 68 00 75 02 <0f> 0b 48 83 78 30 00
> > 74 07 48 83 7f 30 00 75 1c 48 83 78 38 00
> > [    2.822734] RIP  [<ffffffff81769563>] driver_register+0x1f/0x104
> > [    2.822734]  RSP <ffff880012499e00>
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > ---
> > 
> > btw, It would be nice if it could also get a MAINTAINERS entry.
> > 
> > I'm pretty sure Greg isn't the maintainer, but his name was on
> > top of the commit signers.
> 
> Yes; I am going to fix this very shortly.
> 
> > 
> >  drivers/hv/vmbus_drv.c |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> > index 0c048dd..d3b0b4f 100644
> > --- a/drivers/hv/vmbus_drv.c
> > +++ b/drivers/hv/vmbus_drv.c
> > @@ -62,6 +62,14 @@ struct hv_device_info {
> >  	struct hv_dev_port_info outbound;
> >  };
> > 
> > +static int vmbus_exists(void)
> > +{
> > +	if (hv_acpi_dev == NULL)
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +
> > 
> >  static void get_channel_info(struct hv_device *device,
> >  			     struct hv_device_info *info)
> > @@ -590,6 +598,10 @@ int __vmbus_driver_register(struct hv_driver
> > *hv_driver, struct module *owner, c
> > 
> >  	pr_info("registering driver %s\n", hv_driver->name);
> > 
> > +	ret = vmbus_exists();
> > +	if (ret < 0)
> > +		return ret;
> > +
> >  	hv_driver->driver.name = hv_driver->name;
> >  	hv_driver->driver.owner = owner;
> >  	hv_driver->driver.mod_name = mod_name;
> > @@ -614,6 +626,9 @@ void vmbus_driver_unregister(struct hv_driver
> > *hv_driver)
> >  {
> >  	pr_info("unregistering driver %s\n", hv_driver->name);
> > 
> > +	if (!vmbus_exists())
> > +		return;
> > +
> >  	driver_unregister(&hv_driver->driver);
> > 
> >  }
> 
> While this is harmless; I think this might be redundant. Once
> register succeeds, unregister cannot fail.

driver_unregister() is supposed to trigger a warning if you're trying to
unregister a non-registered driver. So even if it can't fail we should
avoid a possible warning.

> 
> > @@ -776,6 +791,7 @@ static int __init hv_acpi_init(void)
> > 
> >  cleanup:
> >  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> > +	hv_acpi_dev = NULL;
> >  	return ret;
> >  }
> > 
> > --
> > 1.7.8.rc1
> 
> Thanks Sasha.
> 
> Regards,
> 
> K. Y
>  
> 
> 

-- 

Sasha.

