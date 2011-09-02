Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1IBH3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:29:13 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40555 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1IBH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:29:11 -0400
Date: Fri, 2 Sep 2011 08:29:08 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dave Young <hidave.darkstar@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb
 (v4l2_device_disconnect+0x11/0x30)
Message-ID: <20110902072908.GA523@sucs.org>
References: <20110829204846.GA14699@sucs.org>
 <CABqxG0cUx4W5JH-gX-rUe=mZ8SY0uxkrCyofPsfUDBojwWKTvQ@mail.gmail.com>
 <20110901191028.GA30301@sucs.org>
 <CABqxG0c-k0PfUEC5YDyj3G6n1iXZqSxavAMVx9rDD6PjT5wWnA@mail.gmail.com>
 <CABqxG0cf-Uk7C=XkNJtLxdWR0ROYmc-E82c-wuE2BSqhwDK3-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABqxG0cf-Uk7C=XkNJtLxdWR0ROYmc-E82c-wuE2BSqhwDK3-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Hans Verkuil.

On Fri, Sep 02, 2011 at 01:35:49PM +0800, Dave Young wrote:
> On Fri, Sep 2, 2011 at 12:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Fri, Sep 2, 2011 at 3:10 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> >> On Thu, Sep 01, 2011 at 05:02:51PM +0800, Dave Young wrote:
> >>> On Tue, Aug 30, 2011 at 4:48 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> >>> >
> >>> > I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by unplugging a
> >>> > USB webcam. See below:
> >>>
> >>> Could you try the attached patch?
> >>
> >> This patch fixed the oops but extending the sequence (enable camera,
> >> start cheese, disable camera, watch cheese pause, enable camera, quit
> >> cheese, start cheese) causes the following "poison overwritten" warning
> >> to appear:
> >
> > It seems another bug, I can reproduce this as well.
> >
> > uvc_device is freed in uvc_delete,
> >
> > struct v4l2_device vdev is the member of struct uvc_device, so vdev is
> > also freed. Later v4l2_device operations on vdev will overwrite the
> > poison memory area.
> >
> 
> Please try attached patch on top of previous one,  in this patch I
> move v4l2_device_put after vdev->release in function
> v4l2_device_release
> 
> Not sure if this is a right fix, comments?
> 
> >>
> >>
> >> [  191.240695] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
> >> [  191.277965] input: CNF7129 as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input9
> >> [  220.287366] =============================================================================
> >> [  220.287379] BUG kmalloc-512: Poison overwritten
> >> [  220.287384] -----------------------------------------------------------------------------
> >> [  220.287387]
> >> [  220.287394] INFO: 0xec90f150-0xec90f150. First byte 0x6a instead of 0x6b
> >> [  220.287410] INFO: Allocated in uvc_probe+0x54/0xd50 age=210617 cpu=0 pid=16
> >> [  220.287421]  T.974+0x29d/0x5e0
> >> [  220.287427]  kmem_cache_alloc+0x167/0x180
> >> [  220.287433]  uvc_probe+0x54/0xd50
> >> [  220.287441]  usb_probe_interface+0xd5/0x1d0
> >> [  220.287448]  driver_probe_device+0x80/0x1a0
> >> [  220.287455]  __device_attach+0x41/0x50
> >> [  220.287460]  bus_for_each_drv+0x53/0x80
> >> [  220.287466]  device_attach+0x89/0xa0
> >> [  220.287472]  bus_probe_device+0x25/0x40
> >> [  220.287478]  device_add+0x5a9/0x660
> >> [  220.287484]  usb_set_configuration+0x562/0x670
> >> [  220.287491]  generic_probe+0x36/0x90
> >> [  220.287497]  usb_probe_device+0x24/0x50
> >> [  220.287503]  driver_probe_device+0x80/0x1a0
> >> [  220.287509]  __device_attach+0x41/0x50
> >> [  220.287515]  bus_for_each_drv+0x53/0x80
> >> [  220.287522] INFO: Freed in uvc_delete+0xfe/0x110 age=22 cpu=0 pid=1645
> >> [  220.287530]  __slab_free+0x1f8/0x300
> >> [  220.287536]  kfree+0x100/0x140
> >> [  220.287541]  uvc_delete+0xfe/0x110
> >> [  220.287547]  uvc_release+0x25/0x30
> >> [  220.287555]  v4l2_device_release+0x9d/0xc0
> >> [  220.287560]  device_release+0x19/0x90
> >> [  220.287567]  kobject_release+0x3c/0x90
> >> [  220.287573]  kref_put+0x2c/0x60
> >> [  220.287578]  kobject_put+0x1d/0x50
> >> [  220.287587]  put_device+0xf/0x20
> >> [  220.287593]  v4l2_release+0x56/0x60
> >> [  220.287599]  fput+0xcc/0x220
> >> [  220.287605]  filp_close+0x44/0x70
> >> [  220.287613]  put_files_struct+0x158/0x180
> >> [  220.287619]  exit_files+0x40/0x50
> >> [  220.287626]  do_exit+0xec/0x660
> >> [  220.287632] INFO: Slab 0xef722180 objects=23 used=23 fp=0x  (null) flags=0x4080
> >> [  220.287639] INFO: Object 0xec90f060 @offset=12384 fp=0xec90cac0
> >> [  220.287642]
> >> [  220.287647] Bytes b4 0xec90f050:  6d 06 00 00 88 c8 fe ff 5a 5a 5a 5a 5a 5a 5a 5a m....ÈþÿZZZZZZZZ
> >> [  220.287681]   Object 0xec90f060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287713]   Object 0xec90f070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287746]   Object 0xec90f080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287778]   Object 0xec90f090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287811]   Object 0xec90f0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287843]   Object 0xec90f0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287876]   Object 0xec90f0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287908]   Object 0xec90f0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287941]   Object 0xec90f0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.287973]   Object 0xec90f0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288006]   Object 0xec90f100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f150:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >> [  220.288012]   Object 0xec90f250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
> >> [  220.288012]  Redzone 0xec90f260:  bb bb bb bb                                     »»»»
> >> [  220.288012]  Padding 0xec90f308:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
> >> [  220.288012] Pid: 1450, comm: metacity Not tainted 3.1.0-rc4-00131-g9e79e3e-dirty #488
> >> [  220.288012] Call Trace:
> >> [  220.288012]  [<b0192c3e>] print_trailer+0xee/0x140
> >> [  220.288012]  [<b0193157>] check_bytes_and_report+0xd7/0x160
> >> [  220.288012]  [<b0194a98>] check_object+0x1d8/0x220
> >> [  220.288012]  [<b0192fe3>] ? check_slab+0x63/0x100
> >> [  220.288012]  [<b0194f67>] alloc_debug_processing+0xb7/0x130
> >> [  220.288012]  [<b019602d>] T.974+0x29d/0x5e0
> >> [  220.288012]  [<b044c466>] ? sock_alloc_send_pskb+0x176/0x290
> >> [  220.288012]  [<b044c466>] ? sock_alloc_send_pskb+0x176/0x290
> >> [  220.288012]  [<b0198551>] ? create_object+0x191/0x240
> >> [  220.288012]  [<b01979f5>] __kmalloc_track_caller+0x1d5/0x1f0
> >> [  220.288012]  [<b044c466>] ? sock_alloc_send_pskb+0x176/0x290
> >> [  220.288012]  [<b044ff2d>] __alloc_skb+0x4d/0x140
> >> [  220.288012]  [<b044c466>] sock_alloc_send_pskb+0x176/0x290
> >> [  220.288012]  [<b055d98a>] ? __mutex_unlock_slowpath+0x9a/0x110
> >> [  220.288012]  [<b044c598>] sock_alloc_send_skb+0x18/0x20
> >> [  220.288012]  [<b04b7957>] unix_stream_sendmsg+0x2b7/0x3d0
> >> [  220.288012]  [<b0448913>] sock_aio_write+0x133/0x170
> >> [  220.288012]  [<b019b285>] do_sync_readv_writev+0x95/0xc0
> >> [  220.288012]  [<b0274328>] ? _copy_from_user+0x38/0x180
> >> [  220.288012]  [<b019b133>] ? rw_copy_check_uvector+0x73/0xf0
> >> [  220.288012]  [<b019bf1b>] do_readv_writev+0x9b/0x180
> >> [  220.288012]  [<b04487e0>] ? sock_destroy_inode+0x30/0x30
> >> [  220.288012]  [<b019c562>] ? fget_light+0xb2/0x130
> >> [  220.288012]  [<b019c576>] ? fget_light+0xc6/0x130
> >> [  220.288012]  [<b019c045>] vfs_writev+0x45/0x60
> >> [  220.288012]  [<b019c131>] sys_writev+0x41/0x80
> >> [  220.288012]  [<b055ff57>] sysenter_do_call+0x12/0x36
> >> [  220.288012]  [<b0550000>] ? rfkill_alloc+0xe0/0x110
> >> [  220.288012] FIX kmalloc-512: Restoring 0xec90f150-0xec90f150=0x6b
> >> [  220.288012]
> >> [  220.288012] FIX kmalloc-512: Marking all objects used
> >>
> >> --
> >> Sitsofe | http://sucs.org/~sits/
> >>
> >
> >
> >
> > --
> > Regards
> > Yang RuiRui
> >
> 
> 
> 
> -- 
> Regards
> Yang RuiRui



-- 
Sitsofe | http://sucs.org/~sits/
