Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1ADLQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:16:35 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23967 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1ADLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:16:33 -0500
X-IronPort-AV: E=Sophos;i="4.60,271,1291611600"; 
   d="scan'208";a="129480239"
Subject: Re: [patch] xenfb: fix xenfb suspend/resume race
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Joe Jin <joe.jin@oracle.com>, "jeremy@goop.org" <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>
In-Reply-To: <20101230164051.GC24313@dumpdata.com>
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>
	 <20101230164051.GC24313@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 11:15:33 +0000
Message-ID: <1294139733.3831.141.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 16:40 +0000, Konrad Rzeszutek Wilk wrote:
> On Thu, Dec 30, 2010 at 08:56:16PM +0800, Joe Jin wrote:
> > Hi,
> 
> Joe,
> 
> Patch looks good, however..
> 
> I am unclear from your description whether the patch fixes
> the problem (I would presume so). Or does it take a long time
> to hit this race?

I also don't see how the patch relates to the stack trace.

Is the issue is that xenfb_send_event is called between xenfb_resume
(which tears down the state, including evtchn->irq binding) and the
probe/connect of the new fb?

I suspect xenfb_resume should set info->update_wanted to 0. This will
defer updates until we have successfully reconnected.

Otherwise, since xenfb_resume also calls xenfb_connect I presume the
call of xenfb_send_event is asynchronous. Which would suggest that some
other locking is missing.

Ian.


> 
> > 
> > when do migration test, we hit the panic as below:
> > <1>BUG: unable to handle kernel paging request at 0000000b819fdb98
> > <1>IP: [<ffffffff812a588f>] notify_remote_via_irq+0x13/0x34
> > <4>PGD 94b10067 PUD 0
> > <0>Oops: 0000 [#1] SMP
> > <0>last sysfs file: /sys/class/misc/autofs/dev
> > <4>CPU 3
> > <4>Modules linked in: autofs4(U) hidp(U) nfs(U) fscache(U) nfs_acl(U)
> > auth_rpcgss(U) rfcomm(U) l2cap(U) bluetooth(U) rfkill(U) lockd(U) sunrpc(U)
> > nf_conntrack_netbios_ns(U) ipt_REJECT(U) nf_conntrack_ipv4(U)
> > nf_defrag_ipv4(U) xt_state(U) nf_conntrack(U) iptable_filter(U) ip_tables(U)
> > ip6t_REJECT(U) xt_tcpudp(U) ip6table_filter(U) ip6_tables(U) x_tables(U)
> > ipv6(U) parport_pc(U) lp(U) parport(U) snd_seq_dummy(U) snd_seq_oss(U)
> > snd_seq_midi_event(U) snd_seq(U) snd_seq_device(U) snd_pcm_oss(U)
> > snd_mixer_oss(U) snd_pcm(U) snd_timer(U) snd(U) soundcore(U)
> > snd_page_alloc(U) joydev(U) xen_netfront(U) pcspkr(U) xen_blkfront(U)
> > uhci_hcd(U) ohci_hcd(U) ehci_hcd(U)
> > Pid: 18, comm: events/3 Not tainted 2.6.32
> > RIP: e030:[<ffffffff812a588f>]  [<ffffffff812a588f>]
> > ify_remote_via_irq+0x13/0x34
> > RSP: e02b:ffff8800e7bf7bd0  EFLAGS: 00010202
> > RAX: ffff8800e61c8000 RBX: ffff8800e62f82c0 RCX: 0000000000000000
> > RDX: 00000000000001e3 RSI: ffff8800e7bf7c68 RDI: 0000000bfffffff4
> > RBP: ffff8800e7bf7be0 R08: 00000000000001e2 R09: ffff8800e62f82c0
> > R10: 0000000000000001 R11: ffff8800e6386110 R12: 0000000000000000
> > R13: 0000000000000007 R14: ffff8800e62f82e0 R15: 0000000000000240
> > FS:  00007f409d3906e0(0000) GS:ffff8800028b8000(0000)
> > GS:0000000000000000
> > CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000b819fdb98 CR3: 000000003ee3b000 CR4: 0000000000002660
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process events/3 (pid: 18, threadinfo ffff8800e7bf6000, task
> > f8800e7bf4540)
> > Stack:
> >  0000000000000200 ffff8800e61c8000 ffff8800e7bf7c00 ffffffff812712c9
> > <0> ffffffff8100ea5f ffffffff81438d80 ffff8800e7bf7cd0 ffffffff812714ee
> > <0> 0000000000000000 ffffffff81270568 000000000000e030 0000000000010202
> > Call Trace:
> >  [<ffffffff812712c9>] xenfb_send_event+0x5c/0x5e
> >  [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff812714ee>] xenfb_refresh+0x1b1/0x1d7
> >  [<ffffffff81270568>] ? sys_imageblit+0x1ac/0x458
> >  [<ffffffff81271786>] xenfb_imageblit+0x2f/0x34
> >  [<ffffffff8126a3e5>] soft_cursor+0x1b5/0x1c8
> >  [<ffffffff8126a137>] bit_cursor+0x4b6/0x4d7
> >  [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff81269c81>] ? bit_cursor+0x0/0x4d7
> >  [<ffffffff812656b7>] fb_flashcursor+0xff/0x111
> >  [<ffffffff812655b8>] ? fb_flashcursor+0x0/0x111
> >  [<ffffffff81071812>] worker_thread+0x14d/0x1ed
> >  [<ffffffff81075a8c>] ? autoremove_wake_function+0x0/0x3d
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff810716c5>] ? worker_thread+0x0/0x1ed
> >  [<ffffffff810756e3>] kthread+0x6e/0x76
> >  [<ffffffff81012dea>] child_rip+0xa/0x20
> >  [<ffffffff81011fd1>] ? int_ret_from_sys_call+0x7/0x1b
> >  [<ffffffff8101275d>] ? retint_restore_args+0x5/0x6
> >  [<ffffffff81012de0>] ? child_rip+0x0/0x20
> > Code: 6b ff 0c 8b 87 a4 db 9f 81 66 85 c0 74 08 0f b7 f8 e8 3b ff ff ff c9
> > c3 55 48 89 e5 48 83 ec 10 0f 1f 44 00 00 89 ff 48 6b ff 0c <8b> 87 a4 db 9f
> > 81 66 85 c0 74 14 48 8d 75 f0 0f b7 c0 bf 04 00
> > RIP  [<ffffffff812a588f>] notify_remote_via_irq+0x13/0x34
> >  RSP <ffff8800e7bf7bd0>
> > CR2: 0000000b819fdb98
> > ---[ end trace 098b4b74827595d0 ]---
> > Kernel panic - not syncing: Fatal exception
> > Pid: 18, comm: events/3 Tainted: G      D    2.6.32
> > Call Trace:
> >  [<ffffffff812a029e>] ? card_probe+0x99/0x123
> >  [<ffffffff81056a96>] panic+0xa5/0x162
> >  [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff81079824>] ? down_trylock+0x30/0x38
> >  [<ffffffff812a029e>] ? card_probe+0x99/0x123
> >  [<ffffffff8105744c>] ? console_unblank+0x23/0x6f
> >  [<ffffffff81056763>] ? print_oops_end_marker+0x23/0x25
> >  [<ffffffff812a029e>] ? card_probe+0x99/0x123
> >  [<ffffffff81439c76>] oops_end+0xb7/0xc7
> >  [<ffffffff810366de>] no_context+0x1f1/0x200
> >  [<ffffffff812a029e>] ? card_probe+0x99/0x123
> >  [<ffffffff81036931>] __bad_area_nosemaphore+0x183/0x1a6
> >  [<ffffffff812af119>] ? extract_buf+0xbd/0x134
> >  [<ffffffff81030c7b>] ? pvclock_clocksource_read+0x47/0x9e
> >  [<ffffffff810369de>] bad_area_nosemaphore+0x13/0x15
> >  [<ffffffff8143b0ed>] do_page_fault+0x147/0x26c
> >  [<ffffffff81439185>] page_fault+0x25/0x30
> >  [<ffffffff812a588f>] ? notify_remote_via_irq+0x13/0x34
> >  [<ffffffff812712c9>] xenfb_send_event+0x5c/0x5e
> >  [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff812714ee>] xenfb_refresh+0x1b1/0x1d7
> >  [<ffffffff81270568>] ? sys_imageblit+0x1ac/0x458
> >  [<ffffffff81271786>] xenfb_imageblit+0x2f/0x34
> >  [<ffffffff8126a3e5>] soft_cursor+0x1b5/0x1c8
> >  [<ffffffff8126a137>] bit_cursor+0x4b6/0x4d7
> >  [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff81269c81>] ? bit_cursor+0x0/0x4d7
> >  [<ffffffff812656b7>] fb_flashcursor+0xff/0x111
> >  [<ffffffff812655b8>] ? fb_flashcursor+0x0/0x111
> >  [<ffffffff81071812>] worker_thread+0x14d/0x1ed
> >  [<ffffffff81075a8c>] ? autoremove_wake_function+0x0/0x3d
> >  [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
> >  [<ffffffff810716c5>] ? worker_thread+0x0/0x1ed
> >  [<ffffffff810756e3>] kthread+0x6e/0x76
> >  [<ffffffff81012dea>] child_rip+0xa/0x20
> >  [<ffffffff81011fd1>] ? int_ret_from_sys_call+0x7/0x1b
> >  [<ffffffff8101275d>] ? retint_restore_args+0x5/0x6
> >  [<ffffffff81012de0>] ? child_rip+0x0/0x20
> >  [<ffffffff81012de0>] ? child_rip+0x0/0x20
> > 
> > Check the source found this maybe caused by kernel tried to used not ready
> > xenfb when resume.
> > 
> > Below is the potential fix, please reivew it
> > 
> > Signed-off-by: Joe Jin <joe.jin@oracle.com>
> > Cc: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > 
> > ---
> >  xen-fbfront.c |   19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> > index dc72563..367fb1c 100644
> > --- a/drivers/video/xen-fbfront.c
> > +++ b/drivers/video/xen-fbfront.c
> > @@ -561,26 +561,24 @@ static void xenfb_init_shared_page(struct xenfb_info *info,
> >  static int xenfb_connect_backend(struct xenbus_device *dev,
> >  				 struct xenfb_info *info)
> >  {
> > -	int ret, evtchn;
> > +	int ret, evtchn, irq;
> >  	struct xenbus_transaction xbt;
> >  
> >  	ret = xenbus_alloc_evtchn(dev, &evtchn);
> >  	if (ret)
> >  		return ret;
> > -	ret = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
> > +	irq = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
> >  					0, dev->devicetype, info);
> > -	if (ret < 0) {
> > +	if (irq < 0) {
> >  		xenbus_free_evtchn(dev, evtchn);
> >  		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
> > -		return ret;
> > +		return irq;
> >  	}
> > -	info->irq = ret;
> > -
> >   again:
> >  	ret = xenbus_transaction_start(&xbt);
> >  	if (ret) {
> >  		xenbus_dev_fatal(dev, ret, "starting transaction");
> > -		return ret;
> > +		goto unbind_irq;
> >  	}
> >  	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
> >  			    virt_to_mfn(info->page));
> > @@ -602,15 +600,20 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
> >  		if (ret == -EAGAIN)
> >  			goto again;
> >  		xenbus_dev_fatal(dev, ret, "completing transaction");
> > -		return ret;
> > +		goto unbind_irq;
> >  	}
> >  
> >  	xenbus_switch_state(dev, XenbusStateInitialised);
> > +	info->irq = irq;
> >  	return 0;
> >  
> >   error_xenbus:
> >  	xenbus_transaction_end(xbt, 1);
> >  	xenbus_dev_fatal(dev, ret, "writing xenstore");
> > + unbind_irq:
> > +	printk(KERN_ERR "xenfb_connect_backend failed!\n");
> > +	unbind_from_irqhandler(irq, info);
> > +	xenbus_free_evtchn(dev, evtchn);
> >  	return ret;
> >  }
> >  
> > 
> > 
> > -- 
> > Oracle <http://www.oracle.com>
> > Joe Jin | Team Leader, Software Development | +8610.8278.6295
> > ORACLE | Linux and Virtualization
> > Incubator Building 2-A ZPark | Beijing China, 100094
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


