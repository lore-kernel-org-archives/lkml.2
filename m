Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990Ab2LFJLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:11:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33222 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2LFJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:11:02 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
References: <20120524021429.GB12557@kroah.com>
	<Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
	<CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
Date: Thu, 6 Dec 2012 01:11:00 -0800
Message-ID: <CANeycqo8sFVeWVEeW3mdPPVRt35+kfkdUzenLB+YgNs4y-T7Cg@mail.gmail.com>
Subject: Re: Race condition between driver_probe_device and device_shutdown
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for taking so long to respond, after a week of silence I
assumed I wouldn't get any responses, plus I had moved on to other
things.]

I happen to still have the logs, the relevant part is pasted at the end.

Answering some of the questions: the driver is on the platform bus, in
fact, it's drivers/usb/host/ehci-tegra.c; after seeing the oops below,
I added printks when entering and exiting tegra_ehci_probe to try to
understand it better.

Note that in the log we see some thread entering tegra_ehci_probe, but
nothing indicates that it has exited before we get the oops.

As for how to reproduce this, I was running a "reboot stress" test; I
would boot the device and reboot it as soon as possible. It appears
that drivers were still being loaded when I managed to start the
reboot. Given that it's a race condition, it wouldn't always
reproduce, but it happened often enough that caught my attention.

With the patch I sent out in my first email I wouldn't run into this at all.

[   58.759906] tegra_ehci_probe instance 1
[   58.764958] [USBHHCD] : usb_create_hcd start
[   58.769342] [USBHHCD] : usb_bus_init start
[   58.772507] Entering device_shutdown
[   58.772516] [USBHv2] tegra_ehci_hcd_shutdown
[   58.772534] Unable to handle kernel paging request at virtual
address ffffffa8
[   58.772541] pgd = ef1e0000
[   58.772545] [ffffffa8] *pgd=af7fe021, *pte=00000000, *ppte=00000000
[   58.772557] Internal error: Oops: 17 [#1] PREEMPT SMP
[   58.772563] last sysfs file:
/sys/devices/platform/tegra-ehci.1/usb1/1-1/bbusb_ioctl
[   58.772588] CPU: 0    Tainted: G        WC
(2.6.36.3-02116-gb523cbe-dirty #3)
[   58.772610] PC is at tegra_ehci_hcd_shutdown+0x28/0x64
[   58.772617] LR is at tegra_ehci_hcd_shutdown+0x28/0x64
[   58.772624] pc : [<c04e3c04>]    lr : [<c04e3c04>]    psr: 60000013
[   58.772628] sp : e5ea3e50  ip : 00010135  fp : 00000001
[   58.772634] r10: 40819060  r9 : e5ea2000  r8 : c023c284
[   58.772639] r7 : 4081b090  r6 : c09326d0  r5 : fffffef8  r4 : 00000000
[   58.772645] r3 : 00000000  r2 : 00000001  r1 : 60000093  r0 : 00000036
[   58.772652] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   58.772659] Control: 10c5387d  Table: af1e004a  DAC: 00000015
[   58.772664]
[   58.772666] PC: 0xc04e3b84:
[   58.772669] 3b84  10800003 eaffffd3 e591c000 e59c6008 e1120006
15d1302b 10800003 e1140006
[   58.772680] 3ba4  15d1302d e2811008 10800003 eaffffc9 e2803f42
e92d4010 e5932004 e592000c
[   58.772691] 3bc4  f57ff05f e5931024 e1a001a0 ebfcc5b7 e1a00001
e8bd8010 e92d4070 e2800008
[   58.772702] 3be4  ebfe615a e3500000 08bd8070 e5904000 e59f1038
e59f0038 e2445f42 eb07d6b4
[   58.772713] 3c04  e5143058 e5933028 e3530000 08bd8070 e59f1018
e59f001c eb07d6ad e5143058
[   58.772723] 3c24  e1a00005 e1a0e00f e593f028 e8bd8070 c07098f8
c07ec784 c07ec794 e92d41f0
[   58.772734] 3c44  e59d4018 e1a05001 e1a06002 e1a07003 e5952000
f57ff05f e3720001 e0021006
[   58.772745] 3c64  e2444001 e3a00001 0a000006 e1510007 0a000006
ebf5c2ba e3540000 cafffff3
[   58.772757]
[   58.772758] LR: 0xc04e3b84:
[   58.772761] 3b84  10800003 eaffffd3 e591c000 e59c6008 e1120006
15d1302b 10800003 e1140006
[   58.772772] 3ba4  15d1302d e2811008 10800003 eaffffc9 e2803f42
e92d4010 e5932004 e592000c
[   58.772783] 3bc4  f57ff05f e5931024 e1a001a0 ebfcc5b7 e1a00001
e8bd8010 e92d4070 e2800008
[   58.772793] 3be4  ebfe615a e3500000 08bd8070 e5904000 e59f1038
e59f0038 e2445f42 eb07d6b4
[   58.772804] 3c04  e5143058 e5933028 e3530000 08bd8070 e59f1018
e59f001c eb07d6ad e5143058
[   58.772814] 3c24  e1a00005 e1a0e00f e593f028 e8bd8070 c07098f8
c07ec784 c07ec794 e92d41f0
[   58.772825] 3c44  e59d4018 e1a05001 e1a06002 e1a07003 e5952000
f57ff05f e3720001 e0021006
[   58.772836] 3c64  e2444001 e3a00001 0a000006 e1510007 0a000006
ebf5c2ba e3540000 cafffff3
[   58.772847]
[   58.772849] SP: 0xe5ea3dd0:
[   58.772852] 3dd0  58b8609a 2020205b 372e3835 31353237 00205d36
00000000 3b9aca00 10624dd3
[   58.772863] 3df0  60000013 ffffffff e5ea3e3c c09326d0 4081b090
c023bbac 00000036 60000093
[   58.772874] 3e10  00000001 00000000 00000000 fffffef8 c09326d0
4081b090 c023c284 e5ea2000
[   58.772884] 3e30  40819060 00000001 00010135 e5ea3e50 c04e3c04
c04e3c04 60000013 ffffffff
[   58.772895] 3e50  ef044a08 ef044a14 c09326d0 c047d500 ef044a08
c047908c c07b89b8 e5ea3e90
[   58.772905] 3e70  00000000 c02b27f4 e5ea3e90 e5ea3e90 00000000
c02b28a4 00000000 c02b2a80
[   58.772916] 3e90  e5ea2000 403adc40 00000000 403adc48 00000100
00000000 00000000 e5ea3fb0
[   58.772927] 3eb0  e5ea2000 eb1f0080 e5ea2000 c02ae37c e5ea3fb0
c023eeb0 00000011 c11cbf14
[   58.772938]
[   58.772940] R5: 0xfffffe78:
[   58.772943] fe78  ******** ******** ******** ******** ********
******** ******** ********
[   58.772957] fe98  ******** ******** ******** ******** ********
******** ******** ********
[   58.772968] feb8  ******** ******** ******** ******** ********
******** ******** ********
[   58.772979] fed8  ******** ******** ******** ******** ********
******** ******** ********
[   58.772990] fef8  ******** ******** ******** ******** ********
******** ******** ********
[   58.773000] ff18  ******** ******** ******** ******** ********
******** ******** ********
[   58.773011] ff38  ******** ******** ******** ******** ********
******** ******** ********
[   58.773022] ff58  ******** ******** ******** ******** ********
******** ******** ********
[   58.773033]
[   58.773035] R6: 0xc0932650:
[   58.773038] 2650  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773049] 2670  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773059] 2690  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773069] 26b0  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773079] 26d0  ef015420 ef096c60 ef0153e0 ef0153a0 ef015360
00000000 00000000 ef0151e0
[   58.773090] 26f0  00000000 00000000 ef015320 00000001 ef0152e0
00000000 ef0152a0 00000000
[   58.773100] 2710  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773110] 2730  00000000 00000000 00000000 00000000 ef3f5bc0
00000000 00000000 00000000
[   58.773121]
[   58.773123] R8: 0xc023c204:
[   58.773126] c204  e31c0c01 1a000008 e3570f5d e24fef46 3798f107
e28d1008 e3a08000 e357080f
[   58.773137] c224  e2270000 2a000f9a ea01fd5c e1a02007 e28d1008
e3a00000 eb000583 e28fe014
[   58.773147] c244  e1a07000 e28d1008 e3570f5d 3891000f 3798f107
eaffffef e5ad0008 e1a02007
[   58.773158] c264  e1a0100d e3a00001 eb000577 eaffffba e320f000
e320f000 e320f000 c088360c
[   58.773169] c284  c02ad098 c02a5208 c023c87c c031ebf8 c031e9c4
c031c940 c031c6f8 c02bb7a4
[   58.773179] c2a4  c031c958 c032a680 c0329fe8 c023c88c c031d2c4
c02bb7a4 c032a3dc c031d1b8
[   58.773191] c2c4  c02cf7ac c02bb7a4 c02bb7a4 c031db00 c02ac334
c03381b8 c02bb7a4 c02cf744
[   58.773201] c2e4  c02cf4e8 c02bb7a4 c02ab000 c02bb7a4 c02bb7a4
c02ad218 c02bb7a4 c02bb7a4
[   58.773213]
[   58.773215] R9: 0xe5ea1f80:
[   58.773217] 1f80  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773228] 1fa0  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773238] 1fc0  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773248] 1fe0  00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773258] 2000  00000000 00000002 00000000 eb1f0080 c08a5268
00000000 00000015 eb1f0080
[   58.773269] 2020  c11bcb00 af1765a8 0000000d ee93da20 c08827e0
00000000 e5ea3bb4 e5ea3b18
[   58.773279] 2040  c06d9f30 00000000 00000000 00000000 00000000
00000000 01000000 00000000
[   58.773289] 2060  403adf00 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.773303] Process adbd (pid: 662, stack limit = 0xe5ea22f0)
[   58.773310] Stack: (0xe5ea3e50 to 0xe5ea4000)
[   58.773317] 3e40:                                     ef044a08
ef044a14 c09326d0 c047d500
[   58.773326] 3e60: ef044a08 c047908c c07b89b8 e5ea3e90 00000000
c02b27f4 e5ea3e90 e5ea3e90
[   58.773335] 3e80: 00000000 c02b28a4 00000000 c02b2a80 e5ea2000
403adc40 00000000 403adc48
[   58.773344] 3ea0: 00000100 00000000 00000000 e5ea3fb0 e5ea2000
eb1f0080 e5ea2000 c02ae37c
[   58.773354] 3ec0: e5ea3fb0 c023eeb0 00000011 c11cbf14 c08a8100
60000013 00000000 00000011
[   58.773363] 3ee0: 00000011 00000000 00040001 0000029b 00000000
00000000 00000000 00000001
[   58.773372] 3f00: 00000001 00000000 00000001 ee2064e0 e5ea3f60
ee856bd4 e5ea3f78 c02baa78
[   58.773381] 3f20: ee01db78 e5ea3f60 ee01dda8 c02a4890 00000001
e5ea3f78 00000000 00000005
[   58.773390] 3f40: 403adb4c 00000000 00000003 00000000 e5ea2000
00000000 e5ea2000 00000000
[   58.773399] 3f60: e5ea2000 e5ea21b0 00000100 00000000 403adb58
403add58 00000000 00000000
[   58.773408] 3f80: e5ea3fb0 e5ea2000 0000001b 00000077 00000000
000374d0 4081b090 0000001b
[   58.773417] 3fa0: 00000058 c023c100 000374d0 4081b090 fee1dead
28121969 a1b2c3d4 4081b090
[   58.773426] 3fc0: 000374d0 4081b090 0000001b 00000058 0000ee29
00100000 40819060 00000001
[   58.773436] 3fe0: 403adffc 403ade48 0000f1f7 000084fc 20000010
fee1dead ffffffff ffffffff
[   58.773468] [<c04e3c04>] (tegra_ehci_hcd_shutdown+0x28/0x64) from
[<c047d500>] (platform_drv_shutdown+0x18/0x1c)
[   58.773485] [<c047d500>] (platform_drv_shutdown+0x18/0x1c) from
[<c047908c>] (device_shutdown+0x78/0xd0)
[   58.773503] [<c047908c>] (device_shutdown+0x78/0xd0) from
[<c02b27f4>] (kernel_restart_prepare+0x58/0x70)
[   58.773516] [<c02b27f4>] (kernel_restart_prepare+0x58/0x70) from
[<c02b28a4>] (kernel_restart+0x2c/0x7c)
[   58.773527] [<c02b28a4>] (kernel_restart+0x2c/0x7c) from
[<c02b2a80>] (sys_reboot+0x184/0x1cc)
[   58.773540] [<c02b2a80>] (sys_reboot+0x184/0x1cc) from [<c023c100>]
(ret_fast_syscall+0x0/0x30)
[   58.773551] Code: e59f1038 e59f0038 e2445f42 eb07d6b4 (e5143058)
[   58.773559] ---[ end trace 1b75b31a2719ed32 ]---

On Thu, May 24, 2012 at 5:33 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Thu, May 24, 2012 at 10:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>> The code there is racy already.  It does:
>>
>>                } else if (dev->driver && dev->driver->shutdown) {
>>
>> without any locking protection.  If the driver is unbound while this
>> statement runs then dev->driver could be non-NULL for the first test
>> and NULL for the second.
>
> Yes,  I missed this one, :-)
>
>>
>>> > to fix the race by prevent driver core from probing or releasing once
>>> > shutdown is started.
>>> >
>>> > How about the below patch?
>>>
>>> How about waiting for the original poster to respond as to exactly how
>>> they are hitting this race before doing anything?
>>
>> In addition, the patch is too complicated.  For this type of
>> synchronization you should use SRCU.  See
>> Documentation/RCU/whatisRCU.txt and related files.
>
> Yes, the synchronization should be a many reader vs. one
> writer problem, RCU should be suitable.
>
> Looks we think alike, :-)
>
> I have studied RCU yesterday, but was afraid that may introduce
> much more code, so not applied it in the patch. Will study it further
> to figure out a new version.
>
>
> Thanks,
> --
> Ming Lei
