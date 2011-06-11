Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1FKMNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1FKMNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:13:53 -0400
Message-ID: <4DF35BF4.4050002@redhat.com>
Date: Sat, 11 Jun 2011 09:13:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
References: <201104252323.20420.linux@rainbow-software.org> <201104262240.40497.linux@rainbow-software.org> <4DBFD919.3090409@redhat.com> <201105031837.13881.linux@rainbow-software.org>
In-Reply-To: <201105031837.13881.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans de G.,

Em 26-04-2011 08:54, Hans de Goede escreveu:
> If you could give it a shot that would be great. I've some hardware to
> test this with (although I've never actually tested that hardware), so
> I can hopefully pick things up if you cannot finish things before you
> need to return the hardware.

As Ondrej couldn't work on that while he was with the hardware, could you
please try to address this issue?

Thanks,
Mauro


Em 03-05-2011 13:37, Ondrej Zary escreveu:
> On Tuesday 03 May 2011 12:29:45 Mauro Carvalho Chehab wrote:
>> Em 26-04-2011 17:40, Ondrej Zary escreveu:
>>> On Tuesday 26 April 2011 14:33:20 Hans Verkuil wrote:
>>>
>>> After digging in the code for hours, I'm giving this up. It's not worth
>>> it.
>>>
>>> The ISOC_MODE_YUV422 mode works as V4L2_PIX_FMT_YVYU with VLC and
>>> mplayer+libv4lconvert, reducing the loop (and dropping strech_*) in
>>> usbvision_parse_lines_422() to:
>>>  scratch_get(usbvision, frame->data + (frame->v4l2_linesize *
>>> frame->curline), 2 * frame->frmwidth);
>>>
>>> The ISOC_MODE_YUV420 is some weird custom format with 64-byte lines of
>>> YYUV. usbvision_parse_lines_420() is real mess with that scratch_* crap
>>> everywhere.
>>>
>>> ISOC_MODE_COMPRESS: There are callbacks to usbvision_request_intra() and
>>> also usbvision_adjust_compression(). This is not going to work outside
>>> the kernel.
>>>
>>>
>>> So I can redo the conversion removal patch to keep the RGB formats and
>>> also provide another one to remove the testpattern (it oopses too). But
>>> I'm not going to do any major changes in the driver.
>>
>> While in a perfect world, this should be moved to userspace, I'm ok on
>> keeping it there, but the OOPS/Panic conditions should be fixed.
>>
>> Could you please work on a patch fixing the broken stuff, without removing
>> the conversions?
> 
> I've already returned the hardware so I can't test the driver anymore.
> 
> Did the YUV422P conversion ever work? The initialization of u and v pointers
> is missing in usbvision_parse_compress() function for YUV422P case.
> 
> The following oops was captured when trying to fix YVU420. Seems to be
> related to the u pointer too...
> 
> [  181.169233] usbvision_parse_compress before conversion
> [  181.169233] usbvision_parse_compress idx=0, format=842094169
> [  181.169233] usbvision_parse_compress YVU420 f=e088d000, Y=e0a3e000
> [  181.169233] usbvision_parse_compress YVU420 frame=df016b68
> [  181.169233] usbvision_parse_compress YVU420 frame->curline=0
> [  181.169233] usbvision_parse_compress YVU420 u=e08a4700, U=e0a50c00, v=e089fc00, V=e0a55700
> [  181.169233] BUG: unable to handle kernel paging request at e08a4700
> [  181.169233] IP: [<e097fd57>] usbvision_parse_compress+0x599/0x76e [usbvision]
> [  181.169233] *pde = 1f0c2067 *pte = 00000000
> [  181.169233] Oops: 0002 [#1] SMP
> [  181.169233] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/i2c-0/uevent
> [  181.169233] Modules linked in: savage drm loop usbvision v4l2_common snd_fm801 snd_tea575x_tuner videodev snd_intel8x0 e
> [  181.169233]
> [  181.169233] Pid: 0, comm: swapper Not tainted 2.6.39-rc2 #2    /848P-ICH5
> [  181.169233] EIP: 0060:[<e097fd57>] EFLAGS: 00010046 CPU: 0
> [  181.169233] EIP is at usbvision_parse_compress+0x599/0x76e [usbvision]
> [  181.169233] EAX: 00000000 EBX: df016b68 ECX: e08a4700 EDX: e0a50c81
> [  181.169233] ESI: 00000000 EDI: e088d001 EBP: 000000a0 ESP: df021cb4
> [  181.169233]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  181.169233] Process swapper (pid: 0, ti=df020000 task=c12dde60 task.ti=c12b0000)
> [  181.169233] Stack:
> [  181.169233]  e0986ed3 e09861a4 e08a4700 e0a50c00 e089fc00 e0a55700 00000003 e089fc00
> [  181.169233]  e08a4700 000000c0 00000140 df021f14 df021d52 05060000 00060027 00000009
> [  181.169233]  000000c0 00003293 00605a25 ff00605a fff0ffff 55d501fc 82995568 a0060124
> [  181.169233] Call Trace:
> [  181.169233]  [<e0c9c69d>] ? uhci_urb_enqueue+0x712/0x725 [uhci_hcd]
> [  181.169233]  [<e08f4155>] ? usb_hcd_submit_urb+0x4be/0x53d [usbcore]
> [  181.169233]  [<c11e9840>] ? printk+0xe/0x16
> [  181.169233]  [<e0980486>] ? usbvision_isoc_irq+0x55a/0x17a0 [usbvision]
> [  181.169233]  [<e097f5f9>] ? usbvision_write_reg_irq+0xd5/0x10f [usbvision]
> [  181.169233]  [<e0981505>] ? usbvision_isoc_irq+0x15d9/0x17a0 [usbvision]
> [  181.169233]  [<c1026eb2>] ? try_to_wake_up+0x13b/0x13b
> [  181.169233]  [<c117057c>] ? ata_scsi_qc_complete+0x2b4/0x2c2
> [  181.169233]  [<c101e899>] ? __wake_up+0x2c/0x3b
> [  181.169233]  [<e08f33e5>] ? usb_hcd_giveback_urb+0x46/0x71 [usbcore]
> [  181.169233]  [<e0c9a98d>] ? uhci_giveback_urb+0xea/0x15d [uhci_hcd]
> [  181.169233]  [<e0c9aff7>] ? uhci_scan_schedule+0x526/0x777 [uhci_hcd]
> [  181.169233]  [<c117951b>] ? __ata_sff_port_intr+0x97/0xa2
> [  181.169233]  [<e0c9c9f8>] ? uhci_irq+0xbf/0xcd [uhci_hcd]
> [  181.169233]  [<e08f2d2e>] ? usb_hcd_irq+0x1e/0x5f [usbcore]
> [  181.169233]  [<c1058581>] ? handle_irq_event_percpu+0x1e/0x106
> [  181.169233]  [<c1059edc>] ? handle_edge_irq+0xa0/0xa0
> [  181.169233]  [<c105868a>] ? handle_irq_event+0x21/0x37
> [  181.169233]  [<c1059edc>] ? handle_edge_irq+0xa0/0xa0
> [  181.169233]  [<c1059f42>] ? handle_fasteoi_irq+0x66/0x7e
> [  181.169233]  <IRQ>
> [  181.169233]  [<c10035c7>] ? do_IRQ+0x2e/0x84
> [  181.169233]  [<c11ec370>] ? common_interrupt+0x30/0x38
> [  181.169233]  [<c1007699>] ? mwait_idle+0x4f/0x54
> [  181.169233]  [<c1001a86>] ? cpu_idle+0x91/0xab
> [  181.169233]  [<c12f96d4>] ? start_kernel+0x2a3/0x2a8
> [  181.169233] Code: 08 ff 35 8c a1 98 e0 ff 74 24 14 68 a4 61 98 e0 68 d3 6e 98 e0 e8 ec 9a 86 e0 8b 15 8c a1 98 e0 89 f0
> [  181.169233]  11 8b 15 88 a1 98 e0 41 89 4c 24 20 8a 04 02 8b 54 24 1c 88
> [  181.169233] EIP: [<e097fd57>] usbvision_parse_compress+0x599/0x76e [usbvision] SS:ESP 0068:df021cb4
> [  181.169233] CR2: 00000000e08a4700
> [  181.169233] ---[ end trace aeedba237da329c1 ]---
> 
> 

