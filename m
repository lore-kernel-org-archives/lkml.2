Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab0IUAmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:42:01 -0400
Received: from infernal.debian.net ([87.230.26.131]:53701 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0IUAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:41:59 -0400
Date: Tue, 21 Sep 2010 02:41:46 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mat <jackdachef@gmail.com>,
        Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Alex Riesen <raa.lkml@gmail.com>,
        Phil Turmel <philip@turmel.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st
 insert, ignored on 2nd insert, lsusb stuck at usbdev_open
Message-ID: <20100921004145.GA5648@amos.infernal>
References: <Pine.LNX.4.44L0.1009201642310.1306-100000@iolanthe.rowland.org>
 <alpine.LNX.2.00.1009210043460.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009210043460.26813@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:48:25AM +0200, Jiri Kosina wrote:
> On Mon, 20 Sep 2010, Alan Stern wrote:
> > I have no idea what's really happening.  Can you figure it out?
> 
> I am trying, but on my testing systems everything is behaving correctly, 
> so it's a bit more difficult. Ideas welcome.

It appears it so far only happened to those who have one of the fancier
Logitech mice. Those also have some extra communications channels AFAICS
(storing and retrieving settings for the G500, battery information for
the wireless mice). That might trigger something here. I am appending
the lsusb output at the end FWIW.

I have compiled it with your extra debug output and also confirmed that
the pointer hiddev is null:

        /*
         * no need for locking because the USB major number
         * is shared which usbcore guards against disconnect
         */
        if (list->hiddev->exist) {
    1406:       48 8b 93 18 c0 00 00    mov    0xc018(%rbx),%rdx
    140d:       b8 ed ff ff ff          mov    $0xffffffed,%eax
    1412:       83 3a 00                cmpl   $0x0,(%rdx)
    1415:       0f 84 bb 00 00 00       je     14d6 <hiddev_open+0x170>

The RIP in the Oops is at offset 1412 here. Relevant dmesg output:

[    1.668245] usb 2-2.3: new full speed USB device using ehci_hcd and address 4
[    1.763862] usb 2-2.3: New USB device found, idVendor=046d, idProduct=c068
[    1.763898] usb 2-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.763937] usb 2-2.3: Product: G500
[    1.763970] usb 2-2.3: Manufacturer: Logitech
...
[    1.771981] usbcore: registered new interface driver hiddev
[    1.772246] HID debug: usbhid_probe() -- set intfdata(ffff88012baa3800, ffff88012b9f8000)
[    1.772347] HID debug: usbhid_probe() -- set intfdata(ffff88012c01ec00, ffff88012b9f8000)
[    1.774298] HID debug: hid_connect() -- hid: ffff88012b9f8000
[    1.774434] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.3/2-2.3:1.0/input/input1
[    1.774885] generic-usb 0003:046D:C068.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech G500] on usb-0000:00:1d.7-2.3/input0
[    1.774942] HID debug: usbhid_probe() -- set intfdata(ffff88012c01dc00, ffff88012b848000)
[    1.779008] HID debug: hid_connect() -- hid: ffff88012b848000
[    1.779192] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.3/2-2.3:1.1/input/input2
[    1.779353] HID debug: hiddev_connect() -- hid: ffff88012b848000, hiddev: ffff88012ac59600, intf: ffff88012c01dc00
[    1.779634] HID debug: hid_connect() -- after hiddev_connect(), hid: ffff88012b848000, hiddev: ffff88012ac59600
[    1.779724] generic-usb 0003:046D:C068.0002: input,hiddev0,hidraw1: USB HID v1.11 Keyboard [Logitech G500] on usb-0000:00:1d.7-2.3/input1
[    1.779783] usbcore: registered new interface driver usbhid
[    1.779813] usbhid: USB HID core driver

...

[   28.047248] HID debug: hiddev_open(): hid: ffff88012b9f8000, hiddev: (null), intf: ffff88012c01ec00
[   28.050469] BUG: unable to handle kernel NULL pointer dereference at (null)
[   28.053596] IP: [<ffffffffa0042f72>] hiddev_open+0xac/0x19e [usbhid]
[   28.054362] PGD 12c188067 PUD 12b68b067 PMD 0 
[   28.054362] Oops: 0000 [#1] SMP 
[   28.054362] last sysfs file: /sys/module/acpi/parameters/acpica_version
[   28.054362] CPU 1 
[   28.054362] Modules linked in: sco bnep rfcomm l2cap bluetooth rfkill binfmt_misc kvm_intel kvm uinput fuse xfs exportfs sha256_generic twofish_generic twofish_x86_64 twofish_common cbc coretemp loop dm_crypt snd_hda_codec_atihdmi snd_hda_codec_realtek snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_hda_intel radeon snd_hda_codec ttm drm_kms_helper drm snd_ac97_codec snd_pcm_oss snd_mixer_oss ac97_bus snd_util_mem joydev snd_hwdep snd_seq_midi i2c_algo_bit snd_rawmidi wacom snd_seq_midi_event i2c_i801 snd_pcm pcspkr snd_seq snd_timer emu10k1_gp gameport snd_page_alloc snd_seq_device button asus_atk0110 evdev shpchp snd pci_hotplug soundcore intel_agp tpm_tis tpm processor tpm_bios ext4 mbcache jbd2 crc16 dm_mod sg sr_mod sd_mod cdrom crc_t10dif usbhid hid uhci_hcd ahci libahci libata ehci_hcd firewire_ohci scsi_mod firewire_core crc_itu_t usbcore atl1e thermal thermal_sys nls_base [last unloaded: scsi_wait_scan]
[   28.054362] 
[   28.054362] Pid: 2098, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00215-gb3fe624 #24 P5Q/P5Q
[   28.054362] RIP: 0010:[<ffffffffa0042f72>]  [<ffffffffa0042f72>] hiddev_open+0xac/0x19e [usbhid]
[   28.054362] RSP: 0018:ffff88012dfe5c28  EFLAGS: 00010296
[   28.054362] RAX: 00000000ffffffed RBX: ffff88012df50000 RCX: 0000000000000034
[   28.054362] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
[   28.054362] RBP: ffff88012dfe5c68 R08: 000000000000e4a7 R09: 0000000000000000
[   28.054362] R10: 0000000000000000 R11: ffffffff8163d278 R12: 0000000000000000
[   28.054362] R13: ffff88012b8bcdc0 R14: ffff88012b9f8000 R15: ffff88012c01ec00
[   28.054362] FS:  00007fed1de45700(0000) GS:ffff880002280000(0000) knlGS:0000000000000000
[   28.054362] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   28.054362] CR2: 0000000000000000 CR3: 000000012af00000 CR4: 00000000000406e0
[   28.054362] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.054362] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.054362] Process hald-probe-hidd (pid: 2098, threadinfo ffff88012dfe4000, task ffff88012b7d0000)
[   28.054362] Stack:
[   28.054362]  0000000000000000 0000000000000000 ffff88012dfe5c68 ffffffffa0063d50
[   28.054362] <0> ffff88012b8bcdc0 ffff88012a8f7330 00000000ffffffed 0000000000000000
[   28.054362] <0> ffff88012dfe5c98 ffffffffa005c0a7 ffff88012a8f7330 ffff88012b8bcdc0
[   28.054362] Call Trace:
[   28.054362]  [<ffffffffa005c0a7>] usb_open+0x63/0xc4 [usbcore]
[   28.054362]  [<ffffffff81105532>] chrdev_open+0x134/0x155
[   28.054362]  [<ffffffff811053fe>] ? chrdev_open+0x0/0x155
[   28.054362]  [<ffffffff81100d31>] __dentry_open+0x164/0x299
[   28.054362]  [<ffffffff811858f3>] ? devcgroup_inode_permission+0xf9/0x13b
[   28.054362]  [<ffffffff81100f2b>] nameidata_to_filp+0x3a/0x4b
[   28.054362]  [<ffffffff8110c244>] do_last+0x3d6/0x51d
[   28.054362]  [<ffffffff8110dd6e>] do_filp_open+0x203/0x599
[   28.054362]  [<ffffffff813397e3>] ? _raw_spin_unlock+0x26/0x2a
[   28.054362]  [<ffffffff81117080>] ? alloc_fd+0x111/0x123
[   28.054362]  [<ffffffff81100af4>] do_sys_open+0x5b/0xf7
[   28.054362]  [<ffffffff81338f49>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   28.054362]  [<ffffffff81100bb9>] sys_open+0x1b/0x1d
[   28.054362]  [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
[   28.054362] Code: 00 4c 89 e2 31 c0 49 89 9d f8 00 00 00 4c 89 f9 4c 89 f6 48 c7 c7 d3 5a 04 a0 e8 de 3b 2f e1 48 8b 93 18 c0 00 00 b8 ed ff ff ff <83> 3a 00 0f 84 bb 00 00 00 8b 42 04 8d 48 01 85 c0 89 4a 04 75 
[   28.054362] RIP  [<ffffffffa0042f72>] hiddev_open+0xac/0x19e [usbhid]
[   28.054362]  RSP <ffff88012dfe5c28>
[   28.054362] CR2: 0000000000000000
[   28.246052] ---[ end trace 2a9b1643521f14fd ]---


And finally, the lsusb output for my mouse:

Bus 002 Device 004: ID 046d:c068 Logitech, Inc. G500 Laser Mouse
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc068 G500 Laser Mouse
  bcdDevice           58.02
  iManufacturer           1 Logitech
  iProduct                2 G500
...
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 U58.02_B0018
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      67
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     122
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0014  1x 20 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)
