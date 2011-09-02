Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1IBFfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:35:53 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:34828 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1IBFfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:35:50 -0400
X-Greylist: delayed 73978 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 01:35:50 EDT
MIME-Version: 1.0
In-Reply-To: <CABqxG0c-k0PfUEC5YDyj3G6n1iXZqSxavAMVx9rDD6PjT5wWnA@mail.gmail.com>
References: <20110829204846.GA14699@sucs.org>
	<CABqxG0cUx4W5JH-gX-rUe=mZ8SY0uxkrCyofPsfUDBojwWKTvQ@mail.gmail.com>
	<20110901191028.GA30301@sucs.org>
	<CABqxG0c-k0PfUEC5YDyj3G6n1iXZqSxavAMVx9rDD6PjT5wWnA@mail.gmail.com>
Date: Fri, 2 Sep 2011 13:35:49 +0800
Message-ID: <CABqxG0cf-Uk7C=XkNJtLxdWR0ROYmc-E82c-wuE2BSqhwDK3-g@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_disconnect+0x11/0x30)
From: Dave Young <hidave.darkstar@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: multipart/mixed; boundary=20cf30050edce6d8ac04abeebbc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30050edce6d8ac04abeebbc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 2, 2011 at 12:59 PM, Dave Young <hidave.darkstar@gmail.com> wro=
te:
> On Fri, Sep 2, 2011 at 3:10 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote=
:
>> On Thu, Sep 01, 2011 at 05:02:51PM +0800, Dave Young wrote:
>>> On Tue, Aug 30, 2011 at 4:48 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wr=
ote:
>>> >
>>> > I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by unpluggin=
g a
>>> > USB webcam. See below:
>>>
>>> Could you try the attached patch?
>>
>> This patch fixed the oops but extending the sequence (enable camera,
>> start cheese, disable camera, watch cheese pause, enable camera, quit
>> cheese, start cheese) causes the following "poison overwritten" warning
>> to appear:
>
> It seems another bug, I can reproduce this as well.
>
> uvc_device is freed in uvc_delete,
>
> struct v4l2_device vdev is the member of struct uvc_device, so vdev is
> also freed. Later v4l2_device operations on vdev will overwrite the
> poison memory area.
>

Please try attached patch on top of previous one,  in this patch I
move v4l2_device_put after vdev->release in function
v4l2_device_release

Not sure if this is a right fix, comments?

>>
>>
>> [ =C2=A0191.240695] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
>> [ =C2=A0191.277965] input: CNF7129 as /devices/pci0000:00/0000:00:1d.7/u=
sb1/1-8/1-8:1.0/input/input9
>> [ =C2=A0220.287366] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [ =C2=A0220.287379] BUG kmalloc-512: Poison overwritten
>> [ =C2=A0220.287384] ----------------------------------------------------=
-------------------------
>> [ =C2=A0220.287387]
>> [ =C2=A0220.287394] INFO: 0xec90f150-0xec90f150. First byte 0x6a instead=
 of 0x6b
>> [ =C2=A0220.287410] INFO: Allocated in uvc_probe+0x54/0xd50 age=3D210617=
 cpu=3D0 pid=3D16
>> [ =C2=A0220.287421] =C2=A0T.974+0x29d/0x5e0
>> [ =C2=A0220.287427] =C2=A0kmem_cache_alloc+0x167/0x180
>> [ =C2=A0220.287433] =C2=A0uvc_probe+0x54/0xd50
>> [ =C2=A0220.287441] =C2=A0usb_probe_interface+0xd5/0x1d0
>> [ =C2=A0220.287448] =C2=A0driver_probe_device+0x80/0x1a0
>> [ =C2=A0220.287455] =C2=A0__device_attach+0x41/0x50
>> [ =C2=A0220.287460] =C2=A0bus_for_each_drv+0x53/0x80
>> [ =C2=A0220.287466] =C2=A0device_attach+0x89/0xa0
>> [ =C2=A0220.287472] =C2=A0bus_probe_device+0x25/0x40
>> [ =C2=A0220.287478] =C2=A0device_add+0x5a9/0x660
>> [ =C2=A0220.287484] =C2=A0usb_set_configuration+0x562/0x670
>> [ =C2=A0220.287491] =C2=A0generic_probe+0x36/0x90
>> [ =C2=A0220.287497] =C2=A0usb_probe_device+0x24/0x50
>> [ =C2=A0220.287503] =C2=A0driver_probe_device+0x80/0x1a0
>> [ =C2=A0220.287509] =C2=A0__device_attach+0x41/0x50
>> [ =C2=A0220.287515] =C2=A0bus_for_each_drv+0x53/0x80
>> [ =C2=A0220.287522] INFO: Freed in uvc_delete+0xfe/0x110 age=3D22 cpu=3D=
0 pid=3D1645
>> [ =C2=A0220.287530] =C2=A0__slab_free+0x1f8/0x300
>> [ =C2=A0220.287536] =C2=A0kfree+0x100/0x140
>> [ =C2=A0220.287541] =C2=A0uvc_delete+0xfe/0x110
>> [ =C2=A0220.287547] =C2=A0uvc_release+0x25/0x30
>> [ =C2=A0220.287555] =C2=A0v4l2_device_release+0x9d/0xc0
>> [ =C2=A0220.287560] =C2=A0device_release+0x19/0x90
>> [ =C2=A0220.287567] =C2=A0kobject_release+0x3c/0x90
>> [ =C2=A0220.287573] =C2=A0kref_put+0x2c/0x60
>> [ =C2=A0220.287578] =C2=A0kobject_put+0x1d/0x50
>> [ =C2=A0220.287587] =C2=A0put_device+0xf/0x20
>> [ =C2=A0220.287593] =C2=A0v4l2_release+0x56/0x60
>> [ =C2=A0220.287599] =C2=A0fput+0xcc/0x220
>> [ =C2=A0220.287605] =C2=A0filp_close+0x44/0x70
>> [ =C2=A0220.287613] =C2=A0put_files_struct+0x158/0x180
>> [ =C2=A0220.287619] =C2=A0exit_files+0x40/0x50
>> [ =C2=A0220.287626] =C2=A0do_exit+0xec/0x660
>> [ =C2=A0220.287632] INFO: Slab 0xef722180 objects=3D23 used=3D23 fp=3D0x=
 =C2=A0(null) flags=3D0x4080
>> [ =C2=A0220.287639] INFO: Object 0xec90f060 @offset=3D12384 fp=3D0xec90c=
ac0
>> [ =C2=A0220.287642]
>> [ =C2=A0220.287647] Bytes b4 0xec90f050: =C2=A06d 06 00 00 88 c8 fe ff 5=
a 5a 5a 5a 5a 5a 5a 5a m....=C3=88=C3=BE=C3=BFZZZZZZZZ
>> [ =C2=A0220.287681] =C2=A0 Object 0xec90f060: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287713] =C2=A0 Object 0xec90f070: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287746] =C2=A0 Object 0xec90f080: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287778] =C2=A0 Object 0xec90f090: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287811] =C2=A0 Object 0xec90f0a0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287843] =C2=A0 Object 0xec90f0b0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287876] =C2=A0 Object 0xec90f0c0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287908] =C2=A0 Object 0xec90f0d0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287941] =C2=A0 Object 0xec90f0e0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.287973] =C2=A0 Object 0xec90f0f0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288006] =C2=A0 Object 0xec90f100: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f110: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f120: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f130: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f140: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f150: =C2=A06a 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f160: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f170: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f180: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f190: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1a0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1b0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1c0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1d0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1e0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f1f0: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f200: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f210: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f220: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f230: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f240: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ =C2=A0220.288012] =C2=A0 Object 0xec90f250: =C2=A06b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=C2=A5
>> [ =C2=A0220.288012] =C2=A0Redzone 0xec90f260: =C2=A0bb bb bb bb =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=BB=C2=BB=C2=BB=C2=BB
>> [ =C2=A0220.288012] =C2=A0Padding 0xec90f308: =C2=A05a 5a 5a 5a 5a 5a 5a=
 5a =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ZZZZZZZZ
>> [ =C2=A0220.288012] Pid: 1450, comm: metacity Not tainted 3.1.0-rc4-0013=
1-g9e79e3e-dirty #488
>> [ =C2=A0220.288012] Call Trace:
>> [ =C2=A0220.288012] =C2=A0[<b0192c3e>] print_trailer+0xee/0x140
>> [ =C2=A0220.288012] =C2=A0[<b0193157>] check_bytes_and_report+0xd7/0x160
>> [ =C2=A0220.288012] =C2=A0[<b0194a98>] check_object+0x1d8/0x220
>> [ =C2=A0220.288012] =C2=A0[<b0192fe3>] ? check_slab+0x63/0x100
>> [ =C2=A0220.288012] =C2=A0[<b0194f67>] alloc_debug_processing+0xb7/0x130
>> [ =C2=A0220.288012] =C2=A0[<b019602d>] T.974+0x29d/0x5e0
>> [ =C2=A0220.288012] =C2=A0[<b044c466>] ? sock_alloc_send_pskb+0x176/0x29=
0
>> [ =C2=A0220.288012] =C2=A0[<b044c466>] ? sock_alloc_send_pskb+0x176/0x29=
0
>> [ =C2=A0220.288012] =C2=A0[<b0198551>] ? create_object+0x191/0x240
>> [ =C2=A0220.288012] =C2=A0[<b01979f5>] __kmalloc_track_caller+0x1d5/0x1f=
0
>> [ =C2=A0220.288012] =C2=A0[<b044c466>] ? sock_alloc_send_pskb+0x176/0x29=
0
>> [ =C2=A0220.288012] =C2=A0[<b044ff2d>] __alloc_skb+0x4d/0x140
>> [ =C2=A0220.288012] =C2=A0[<b044c466>] sock_alloc_send_pskb+0x176/0x290
>> [ =C2=A0220.288012] =C2=A0[<b055d98a>] ? __mutex_unlock_slowpath+0x9a/0x=
110
>> [ =C2=A0220.288012] =C2=A0[<b044c598>] sock_alloc_send_skb+0x18/0x20
>> [ =C2=A0220.288012] =C2=A0[<b04b7957>] unix_stream_sendmsg+0x2b7/0x3d0
>> [ =C2=A0220.288012] =C2=A0[<b0448913>] sock_aio_write+0x133/0x170
>> [ =C2=A0220.288012] =C2=A0[<b019b285>] do_sync_readv_writev+0x95/0xc0
>> [ =C2=A0220.288012] =C2=A0[<b0274328>] ? _copy_from_user+0x38/0x180
>> [ =C2=A0220.288012] =C2=A0[<b019b133>] ? rw_copy_check_uvector+0x73/0xf0
>> [ =C2=A0220.288012] =C2=A0[<b019bf1b>] do_readv_writev+0x9b/0x180
>> [ =C2=A0220.288012] =C2=A0[<b04487e0>] ? sock_destroy_inode+0x30/0x30
>> [ =C2=A0220.288012] =C2=A0[<b019c562>] ? fget_light+0xb2/0x130
>> [ =C2=A0220.288012] =C2=A0[<b019c576>] ? fget_light+0xc6/0x130
>> [ =C2=A0220.288012] =C2=A0[<b019c045>] vfs_writev+0x45/0x60
>> [ =C2=A0220.288012] =C2=A0[<b019c131>] sys_writev+0x41/0x80
>> [ =C2=A0220.288012] =C2=A0[<b055ff57>] sysenter_do_call+0x12/0x36
>> [ =C2=A0220.288012] =C2=A0[<b0550000>] ? rfkill_alloc+0xe0/0x110
>> [ =C2=A0220.288012] FIX kmalloc-512: Restoring 0xec90f150-0xec90f150=3D0=
x6b
>> [ =C2=A0220.288012]
>> [ =C2=A0220.288012] FIX kmalloc-512: Marking all objects used
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
>>
>
>
>
> --
> Regards
> Yang RuiRui
>



--=20
Regards
Yang RuiRui

--20cf30050edce6d8ac04abeebbc4
Content-Type: application/octet-stream; name="vdev.diff"
Content-Disposition: attachment; filename="vdev.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gs2qwvwi0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1kZXYuYyBiL2RyaXZlcnMvbWVk
aWEvdmlkZW8vdjRsMi1kZXYuYwppbmRleCA5OGNlZTE5Li41NDFkYmEzIDEwMDY0NAotLS0gYS9k
cml2ZXJzL21lZGlhL3ZpZGVvL3Y0bDItZGV2LmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby92
NGwyLWRldi5jCkBAIC0xNzIsMTMgKzE3MiwxNCBAQCBzdGF0aWMgdm9pZCB2NGwyX2RldmljZV9y
ZWxlYXNlKHN0cnVjdCBkZXZpY2UgKmNkKQogCQltZWRpYV9kZXZpY2VfdW5yZWdpc3Rlcl9lbnRp
dHkoJnZkZXYtPmVudGl0eSk7CiAjZW5kaWYKIAorCS8qIERlY3JlYXNlIHY0bDJfZGV2aWNlIHJl
ZmNvdW50ICovCisJaWYgKHZkZXYtPnY0bDJfZGV2KQorCQl2NGwyX2RldmljZV9wdXQodmRldi0+
djRsMl9kZXYpOworCiAJLyogUmVsZWFzZSB2aWRlb19kZXZpY2UgYW5kIHBlcmZvcm0gb3RoZXIK
IAkgICBjbGVhbnVwcyBhcyBuZWVkZWQuICovCiAJdmRldi0+cmVsZWFzZSh2ZGV2KTsKIAotCS8q
IERlY3JlYXNlIHY0bDJfZGV2aWNlIHJlZmNvdW50ICovCi0JaWYgKHZkZXYtPnY0bDJfZGV2KQot
CQl2NGwyX2RldmljZV9wdXQodmRldi0+djRsMl9kZXYpOwogfQogCiBzdGF0aWMgc3RydWN0IGNs
YXNzIHZpZGVvX2NsYXNzID0gewo=
--20cf30050edce6d8ac04abeebbc4--
