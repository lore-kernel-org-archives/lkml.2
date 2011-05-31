Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1EaWzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:55:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51735 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab1EaWzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Phl8HFkT96zeTW6kWtexHyxKrnx5SBZfqPkbb7+mS1LMvIRJhhZNN2rIke4bDOu4xb
         C8V9l25QqE0ZBYyPm2ZtIzDTmYti52jIXTAtW3f3ynL5NdgNpkxKQPYQv+b4jb4vU8yy
         bxxUhwj08Wogyb0CY5cUQixsj7JIyzXJPhppY=
Message-ID: <4DE571D7.6030005@gmail.com>
Date: Wed, 01 Jun 2011 00:55:19 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com> <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com> <4DE4F166.8020207@gmail.com> <20110531171446.GB6776@xanatos> <4DE5283A.9070202@gmail.com> <20110531181848.GA6911@xanatos> <4DE53C74.2080700@gmail.com> <20110531223502.GA8550@xanatos>
In-Reply-To: <20110531223502.GA8550@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-06-11 00:35, Sarah Sharp schreef:
> On Tue, May 31, 2011 at 09:07:32PM +0200, Maarten Lankhorst wrote:
>> Op 31-05-11 20:18, Sarah Sharp schreef:
>>> On Tue, May 31, 2011 at 07:41:14PM +0200, Maarten Lankhorst wrote:
>> My xhci controller is this one:
>> 04:00.0 USB Controller: Device 1b6f:7023 (rev 01) (prog-if 30 [XHCI])
>> Subsystem: ASRock Incorporation Device 7023
> Ok, the PCI SIGG says that vendor ID is assigned to Etron.  Congrats,
> that's the first xHCI host controller I've seen from that company. :)
>
>> After plugging in a simple bluetooth dongle, until the first failure:
> Are you sure you have the dmesg log level set to 8?  Because there still
> should be more debugging about input and output contexts in this log.
> Are you capturing via /var/log/kern.log?
I skipped the part where the device was initialized, it had a whole lot of stuff there. The log I had was from the input part forward..

Fuller log at the bottom. I was using dmesg to grab the log.
> Ok, so the xHCI driver does successfully get a slot from the host
> controller.
>
>> [  545.664041] xhci_hcd 0000:04:00.0: Allocating ring at ffff8801c7d7ccc0
>> [  545.664044] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801e2e26c40
>> [  545.664047] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac3f800 (virtual) 0xbac3f800 (DMA)
>> [  545.664053] xhci_hcd 0000:04:00.0: Linking segment 0xbac3f800 to segment 0xbac3f800 (DMA)
>> [  545.664056] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff8801e2e26c40 (virtual), 0xbac3f800 (DMA)
>> [  545.664059] xhci_hcd 0000:04:00.0: Set slot id 1 dcbaa entry ffff8800bac3e008 to 0xbac21000
>> [  545.664070] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2f1, 4'hf);
> But I don't see an Address Device command complete here.  The command
> submission probably caused that memory write, but there really should be
> more debugging here.  I'll have to look through the hub initialization
> and see if there is any error path that would make it skip setting the
> device address.
>
> Have you tried on Linux 3.0-rc1?
If I backtrace it I get this: hub_port_init calls hub_port_reset which issues the device reset in
xhci_discover_or_reset_device, it is called BEFORE the device is being initialized..

Haven't tried 3.0rc1 yet, will give it a shot

slightly fuller dmesg log:

[14254.214609] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[14254.214639] xhci_hcd 0000:04:00.0: setting latency timer to 64
[14254.214644] xhci_hcd 0000:04:00.0: xHCI Host Controller
[14254.214649] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
[14254.220705] xhci_hcd 0000:04:00.0: xHCI capability registers at ffffc90001ce0000:
[14254.220711] xhci_hcd 0000:04:00.0: CAPLENGTH AND HCIVERSION 0x1000020:
[14254.220712] xhci_hcd 0000:04:00.0: CAPLENGTH: 0x20
[14254.220713] xhci_hcd 0000:04:00.0: HCIVERSION: 0x100
[14254.220716] xhci_hcd 0000:04:00.0: HCSPARAMS 1: 0x4000440
[14254.220717] xhci_hcd 0000:04:00.0:   Max device slots: 64
[14254.220718] xhci_hcd 0000:04:00.0:   Max interrupters: 4
[14254.220718] xhci_hcd 0000:04:00.0:   Max ports: 4
[14254.220721] xhci_hcd 0000:04:00.0: HCSPARAMS 2: 0x240000f9
[14254.220722] xhci_hcd 0000:04:00.0:   Isoc scheduling threshold: 9
[14254.220723] xhci_hcd 0000:04:00.0:   Maximum allowed segments in event ring: 15
[14254.220726] xhci_hcd 0000:04:00.0: HCSPARAMS 3 0x7ff0003:
[14254.220727] xhci_hcd 0000:04:00.0:   Worst case U1 device exit latency: 3
[14254.220728] xhci_hcd 0000:04:00.0:   Worst case U2 device exit latency: 2047
[14254.220731] xhci_hcd 0000:04:00.0: HCC PARAMS 0x40050af:
[14254.220732] xhci_hcd 0000:04:00.0:   HC generates 64 bit addresses
[14254.220732] xhci_hcd 0000:04:00.0:   FIXME: more HCCPARAMS debugging
[14254.220735] xhci_hcd 0000:04:00.0: RTSOFF 0x2000:
[14254.220736] xhci_hcd 0000:04:00.0: xHCI operational registers at ffffc90001ce0020:
[14254.220739] xhci_hcd 0000:04:00.0: USBCMD 0x0:
[14254.220740] xhci_hcd 0000:04:00.0:   HC is being stopped
[14254.220741] xhci_hcd 0000:04:00.0:   HC has finished hard reset
[14254.220742] xhci_hcd 0000:04:00.0:   Event Interrupts disabled
[14254.220743] xhci_hcd 0000:04:00.0:   Host System Error Interrupts disabled
[14254.220743] xhci_hcd 0000:04:00.0:   HC has finished light reset
[14254.220746] xhci_hcd 0000:04:00.0: USBSTS 0x11:
[14254.220747] xhci_hcd 0000:04:00.0:   Event ring is empty
[14254.220748] xhci_hcd 0000:04:00.0:   No Host System Error
[14254.220749] xhci_hcd 0000:04:00.0:   HC is halted
[14254.220752] xhci_hcd 0000:04:00.0: ffffc90001ce0420 port status reg = 0x202e1
[14254.220755] xhci_hcd 0000:04:00.0: ffffc90001ce0424 port power reg = 0x0
[14254.220758] xhci_hcd 0000:04:00.0: ffffc90001ce0428 port link reg = 0x0
[14254.220761] xhci_hcd 0000:04:00.0: ffffc90001ce042c port reserved reg = 0x0
[14254.220765] xhci_hcd 0000:04:00.0: ffffc90001ce0430 port status reg = 0x2a0
[14254.220768] xhci_hcd 0000:04:00.0: ffffc90001ce0434 port power reg = 0x0
[14254.220771] xhci_hcd 0000:04:00.0: ffffc90001ce0438 port link reg = 0x0
[14254.220775] xhci_hcd 0000:04:00.0: ffffc90001ce043c port reserved reg = 0x0
[14254.220778] xhci_hcd 0000:04:00.0: ffffc90001ce0440 port status reg = 0x2a0
[14254.220781] xhci_hcd 0000:04:00.0: ffffc90001ce0444 port power reg = 0x0
[14254.220784] xhci_hcd 0000:04:00.0: ffffc90001ce0448 port link reg = 0x0
[14254.220788] xhci_hcd 0000:04:00.0: ffffc90001ce044c port reserved reg = 0x0
[14254.220791] xhci_hcd 0000:04:00.0: ffffc90001ce0450 port status reg = 0x2a0
[14254.220794] xhci_hcd 0000:04:00.0: ffffc90001ce0454 port power reg = 0x0
[14254.220798] xhci_hcd 0000:04:00.0: ffffc90001ce0458 port link reg = 0x0
[14254.220801] xhci_hcd 0000:04:00.0: ffffc90001ce045c port reserved reg = 0x0
[14254.220803] xhci_hcd 0000:04:00.0: // Halt the HC
[14254.220808] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h0, 4'hf);
[14254.220812] xhci_hcd 0000:04:00.0: Resetting HCD
[14254.220814] xhci_hcd 0000:04:00.0: // Reset the HC
[14254.220817] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h2, 4'hf);
[14254.220824] xhci_hcd 0000:04:00.0: Wait for controller to be ready for doorbell rings
[14254.220827] xhci_hcd 0000:04:00.0: Reset complete
[14254.220830] xhci_hcd 0000:04:00.0: Enabling 64-bit DMA addresses.
[14254.220831] xhci_hcd 0000:04:00.0: Calling HCD init
[14254.220832] xhci_hcd 0000:04:00.0: xhci_init
[14254.220833] xhci_hcd 0000:04:00.0: xHCI doesn't need link TRB QUIRK
[14254.220836] xhci_hcd 0000:04:00.0: Supported page size register = 0x1
[14254.220837] xhci_hcd 0000:04:00.0: Supported page size of 4K
[14254.220838] xhci_hcd 0000:04:00.0: HCD page size set to 4K
[14254.220841] xhci_hcd 0000:04:00.0: // xHC can handle at most 64 device slots.
[14254.220844] xhci_hcd 0000:04:00.0: // Setting Max device slots reg = 0x40.
[14254.220845] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0058, 32'h40, 4'hf);
[14254.220849] xhci_hcd 0000:04:00.0: // Device context base array address = 0xbac41000 (DMA), ffff8800bac41000 (virt)
[14254.220850] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce0050, 64'hbac41000, 4'hf);
[14254.220853] xhci_hcd 0000:04:00.0: Allocating ring at ffff88022fb25180
[14254.220855] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801c2f455e0
[14254.220857] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac45000 (virtual) 0xbac45000 (DMA)
[14254.220861] xhci_hcd 0000:04:00.0: Linking segment 0xbac45000 to segment 0xbac45000 (DMA)
[14254.220862] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff8801c2f455e0 (virtual), 0xbac45000 (DMA)
[14254.220863] xhci_hcd 0000:04:00.0: Allocated command ring at ffff88022fb25180
[14254.220864] xhci_hcd 0000:04:00.0: First segment DMA is 0xbac45000
[14254.220869] xhci_hcd 0000:04:00.0: // Setting command ring address to 0x40
[14254.220870] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce0038, 64'hbac45001, 4'hf);
[14254.220876] xhci_hcd 0000:04:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[14254.220877] xhci_hcd 0000:04:00.0: // xHC command ring deq ptr high bits = @00000000
[14254.220880] xhci_hcd 0000:04:00.0: // Doorbell array is located at offset 0x3000 from cap regs base addr
[14254.220881] xhci_hcd 0000:04:00.0: // xHCI capability registers at ffffc90001ce0000:
[14254.220884] xhci_hcd 0000:04:00.0: // @ffffc90001ce0000 = 0x1000020 (CAPLENGTH AND HCIVERSION)
[14254.220885] xhci_hcd 0000:04:00.0: //   CAPLENGTH: 0x20
[14254.220886] xhci_hcd 0000:04:00.0: // xHCI operational registers at ffffc90001ce0020:
[14254.220889] xhci_hcd 0000:04:00.0: // @ffffc90001ce0018 = 0x2000 RTSOFF
[14254.220890] xhci_hcd 0000:04:00.0: // xHCI runtime registers at ffffc90001ce2000:
[14254.220893] xhci_hcd 0000:04:00.0: // @ffffc90001ce0014 = 0x3000 DBOFF
[14254.220894] xhci_hcd 0000:04:00.0: // Doorbell array at ffffc90001ce3000:
[14254.220895] xhci_hcd 0000:04:00.0: xHCI runtime registers at ffffc90001ce2000:
[14254.220899] xhci_hcd 0000:04:00.0:   ffffc90001ce2000: Microframe index = 0x0
[14254.220915] xhci_hcd 0000:04:00.0: // Allocating event ring
[14254.220917] xhci_hcd 0000:04:00.0: Allocating ring at ffff88022fb25ea0
[14254.220918] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801c2f45a00
[14254.220919] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac45400 (virtual) 0xbac45400 (DMA)
[14254.220920] xhci_hcd 0000:04:00.0: Linking segment 0xbac45400 to segment 0xbac45400 (DMA)
[14254.220922] xhci_hcd 0000:04:00.0: TRB math tests passed.
[14254.220924] xhci_hcd 0000:04:00.0: // Allocated event ring segment table at 0xbac44000
[14254.220925] xhci_hcd 0000:04:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff8800bac44000, dma addr = 0xbac44000
[14254.220928] xhci_hcd 0000:04:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[14254.220929] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce2028, 32'h1, 4'hf);
[14254.220930] xhci_hcd 0000:04:00.0: // Set ERST entries to point to event ring.
[14254.220931] xhci_hcd 0000:04:00.0: // Set ERST base address for ir_set 0 = 0xbac44000
[14254.220937] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2030, 64'hbac44000, 4'hf);
[14254.220942] xhci_hcd 0000:04:00.0: // Write event ring dequeue pointer, preserving EHB bit
[14254.220943] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac45400, 4'hf);
[14254.220944] xhci_hcd 0000:04:00.0: Wrote ERST address to ir_set 0.
[14254.220948] xhci_hcd 0000:04:00.0: Allocating 4 scratchpad buffers
[14254.220962] xhci_hcd 0000:04:00.0: Ext Cap ffffc90001ce1010, port offset = 1, count = 2, revision = 0x2
[14254.220968] xhci_hcd 0000:04:00.0: Ext Cap ffffc90001ce1020, port offset = 3, count = 2, revision = 0x3
[14254.220969] xhci_hcd 0000:04:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[14254.220970] xhci_hcd 0000:04:00.0: USB 2.0 port at index 0, addr = ffffc90001ce0420
[14254.220971] xhci_hcd 0000:04:00.0: USB 2.0 port at index 1, addr = ffffc90001ce0430
[14254.220973] xhci_hcd 0000:04:00.0: USB 3.0 port at index 2, addr = ffffc90001ce0440
[14254.220974] xhci_hcd 0000:04:00.0: USB 3.0 port at index 3, addr = ffffc90001ce0450
[14254.220975] xhci_hcd 0000:04:00.0: Finished xhci_init
[14254.220976] xhci_hcd 0000:04:00.0: Called HCD init
[14254.220980] xhci_hcd 0000:04:00.0: Got SBRN 48
[14254.220988] xhci_hcd 0000:04:00.0: MWI active
[14254.220988] xhci_hcd 0000:04:00.0: Finished xhci_pci_reinit
[14254.220990] xhci_hcd 0000:04:00.0: supports USB remote wakeup
[14254.220998] xhci_hcd 0000:04:00.0: irq 17, io mem 0xfa100000
[14254.220999] xhci_hcd 0000:04:00.0: xhci_run
[14254.221025] xhci_hcd 0000:04:00.0: Failed to enable MSI-X
[14254.221102] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[14254.221132] xhci_hcd 0000:04:00.0: Setting event ring polling timer
[14254.221135] xhci_hcd 0000:04:00.0: Command ring memory map follows:
[14254.221137] xhci_hcd 0000:04:00.0: @bac45000 00000000 00000000 00000000 00000000
[14254.221138] xhci_hcd 0000:04:00.0: @bac45010 00000000 00000000 00000000 00000000
[14254.221139] xhci_hcd 0000:04:00.0: @bac45020 00000000 00000000 00000000 00000000
[14254.221140] xhci_hcd 0000:04:00.0: @bac45030 00000000 00000000 00000000 00000000
[14254.221141] xhci_hcd 0000:04:00.0: @bac45040 00000000 00000000 00000000 00000000
[14254.221142] xhci_hcd 0000:04:00.0: @bac45050 00000000 00000000 00000000 00000000
[14254.221143] xhci_hcd 0000:04:00.0: @bac45060 00000000 00000000 00000000 00000000
[14254.221144] xhci_hcd 0000:04:00.0: @bac45070 00000000 00000000 00000000 00000000
[14254.221145] xhci_hcd 0000:04:00.0: @bac45080 00000000 00000000 00000000 00000000
[14254.221146] xhci_hcd 0000:04:00.0: @bac45090 00000000 00000000 00000000 00000000
[14254.221147] xhci_hcd 0000:04:00.0: @bac450a0 00000000 00000000 00000000 00000000
[14254.221148] xhci_hcd 0000:04:00.0: @bac450b0 00000000 00000000 00000000 00000000
[14254.221149] xhci_hcd 0000:04:00.0: @bac450c0 00000000 00000000 00000000 00000000
[14254.221150] xhci_hcd 0000:04:00.0: @bac450d0 00000000 00000000 00000000 00000000
[14254.221151] xhci_hcd 0000:04:00.0: @bac450e0 00000000 00000000 00000000 00000000
[14254.221152] xhci_hcd 0000:04:00.0: @bac450f0 00000000 00000000 00000000 00000000
[14254.221153] xhci_hcd 0000:04:00.0: @bac45100 00000000 00000000 00000000 00000000
[14254.221154] xhci_hcd 0000:04:00.0: @bac45110 00000000 00000000 00000000 00000000
[14254.221155] xhci_hcd 0000:04:00.0: @bac45120 00000000 00000000 00000000 00000000
[14254.221156] xhci_hcd 0000:04:00.0: @bac45130 00000000 00000000 00000000 00000000
[14254.221157] xhci_hcd 0000:04:00.0: @bac45140 00000000 00000000 00000000 00000000
[14254.221158] xhci_hcd 0000:04:00.0: @bac45150 00000000 00000000 00000000 00000000
[14254.221159] xhci_hcd 0000:04:00.0: @bac45160 00000000 00000000 00000000 00000000
[14254.221160] xhci_hcd 0000:04:00.0: @bac45170 00000000 00000000 00000000 00000000
[14254.221161] xhci_hcd 0000:04:00.0: @bac45180 00000000 00000000 00000000 00000000
[14254.221162] xhci_hcd 0000:04:00.0: @bac45190 00000000 00000000 00000000 00000000
[14254.221163] xhci_hcd 0000:04:00.0: @bac451a0 00000000 00000000 00000000 00000000
[14254.221164] xhci_hcd 0000:04:00.0: @bac451b0 00000000 00000000 00000000 00000000
[14254.221165] xhci_hcd 0000:04:00.0: @bac451c0 00000000 00000000 00000000 00000000
[14254.221166] xhci_hcd 0000:04:00.0: @bac451d0 00000000 00000000 00000000 00000000
[14254.221167] xhci_hcd 0000:04:00.0: @bac451e0 00000000 00000000 00000000 00000000
[14254.221168] xhci_hcd 0000:04:00.0: @bac451f0 00000000 00000000 00000000 00000000
[14254.221169] xhci_hcd 0000:04:00.0: @bac45200 00000000 00000000 00000000 00000000
[14254.221170] xhci_hcd 0000:04:00.0: @bac45210 00000000 00000000 00000000 00000000
[14254.221171] xhci_hcd 0000:04:00.0: @bac45220 00000000 00000000 00000000 00000000
[14254.221172] xhci_hcd 0000:04:00.0: @bac45230 00000000 00000000 00000000 00000000
[14254.221173] xhci_hcd 0000:04:00.0: @bac45240 00000000 00000000 00000000 00000000
[14254.221174] xhci_hcd 0000:04:00.0: @bac45250 00000000 00000000 00000000 00000000
[14254.221175] xhci_hcd 0000:04:00.0: @bac45260 00000000 00000000 00000000 00000000
[14254.221176] xhci_hcd 0000:04:00.0: @bac45270 00000000 00000000 00000000 00000000
[14254.221177] xhci_hcd 0000:04:00.0: @bac45280 00000000 00000000 00000000 00000000
[14254.221178] xhci_hcd 0000:04:00.0: @bac45290 00000000 00000000 00000000 00000000
[14254.221179] xhci_hcd 0000:04:00.0: @bac452a0 00000000 00000000 00000000 00000000
[14254.221180] xhci_hcd 0000:04:00.0: @bac452b0 00000000 00000000 00000000 00000000
[14254.221181] xhci_hcd 0000:04:00.0: @bac452c0 00000000 00000000 00000000 00000000
[14254.221182] xhci_hcd 0000:04:00.0: @bac452d0 00000000 00000000 00000000 00000000
[14254.221183] xhci_hcd 0000:04:00.0: @bac452e0 00000000 00000000 00000000 00000000
[14254.221184] xhci_hcd 0000:04:00.0: @bac452f0 00000000 00000000 00000000 00000000
[14254.221185] xhci_hcd 0000:04:00.0: @bac45300 00000000 00000000 00000000 00000000
[14254.221186] xhci_hcd 0000:04:00.0: @bac45310 00000000 00000000 00000000 00000000
[14254.221187] xhci_hcd 0000:04:00.0: @bac45320 00000000 00000000 00000000 00000000
[14254.221188] xhci_hcd 0000:04:00.0: @bac45330 00000000 00000000 00000000 00000000
[14254.221189] xhci_hcd 0000:04:00.0: @bac45340 00000000 00000000 00000000 00000000
[14254.221190] xhci_hcd 0000:04:00.0: @bac45350 00000000 00000000 00000000 00000000
[14254.221191] xhci_hcd 0000:04:00.0: @bac45360 00000000 00000000 00000000 00000000
[14254.221192] xhci_hcd 0000:04:00.0: @bac45370 00000000 00000000 00000000 00000000
[14254.221193] xhci_hcd 0000:04:00.0: @bac45380 00000000 00000000 00000000 00000000
[14254.221194] xhci_hcd 0000:04:00.0: @bac45390 00000000 00000000 00000000 00000000
[14254.221195] xhci_hcd 0000:04:00.0: @bac453a0 00000000 00000000 00000000 00000000
[14254.221196] xhci_hcd 0000:04:00.0: @bac453b0 00000000 00000000 00000000 00000000
[14254.221197] xhci_hcd 0000:04:00.0: @bac453c0 00000000 00000000 00000000 00000000
[14254.221198] xhci_hcd 0000:04:00.0: @bac453d0 00000000 00000000 00000000 00000000
[14254.221199] xhci_hcd 0000:04:00.0: @bac453e0 00000000 00000000 00000000 00000000
[14254.221200] xhci_hcd 0000:04:00.0: @bac453f0 bac45000 00000000 00000000 00001802
[14254.221201] xhci_hcd 0000:04:00.0:   Ring has not been updated
[14254.221202] xhci_hcd 0000:04:00.0: Ring deq = ffff8800bac45000 (virt), 0xbac45000 (dma)
[14254.221203] xhci_hcd 0000:04:00.0: Ring deq updated 0 times
[14254.221204] xhci_hcd 0000:04:00.0: Ring enq = ffff8800bac45000 (virt), 0xbac45000 (dma)
[14254.221205] xhci_hcd 0000:04:00.0: Ring enq updated 0 times
[14254.221210] xhci_hcd 0000:04:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[14254.221211] xhci_hcd 0000:04:00.0: // xHC command ring deq ptr high bits = @00000000
[14254.221212] xhci_hcd 0000:04:00.0: ERST memory map follows:
[14254.221213] xhci_hcd 0000:04:00.0: @bac44000 bac45400 00000000 00000040 00000000
[14254.221214] xhci_hcd 0000:04:00.0: Event ring:
[14254.221215] xhci_hcd 0000:04:00.0: @bac45400 00000000 00000000 00000000 00000000
[14254.221216] xhci_hcd 0000:04:00.0: @bac45410 00000000 00000000 00000000 00000000
[14254.221217] xhci_hcd 0000:04:00.0: @bac45420 00000000 00000000 00000000 00000000
[14254.221218] xhci_hcd 0000:04:00.0: @bac45430 00000000 00000000 00000000 00000000
[14254.221219] xhci_hcd 0000:04:00.0: @bac45440 00000000 00000000 00000000 00000000
[14254.221220] xhci_hcd 0000:04:00.0: @bac45450 00000000 00000000 00000000 00000000
[14254.221221] xhci_hcd 0000:04:00.0: @bac45460 00000000 00000000 00000000 00000000
[14254.221222] xhci_hcd 0000:04:00.0: @bac45470 00000000 00000000 00000000 00000000
[14254.221223] xhci_hcd 0000:04:00.0: @bac45480 00000000 00000000 00000000 00000000
[14254.221224] xhci_hcd 0000:04:00.0: @bac45490 00000000 00000000 00000000 00000000
[14254.221225] xhci_hcd 0000:04:00.0: @bac454a0 00000000 00000000 00000000 00000000
[14254.221227] xhci_hcd 0000:04:00.0: @bac454b0 00000000 00000000 00000000 00000000
[14254.221228] xhci_hcd 0000:04:00.0: @bac454c0 00000000 00000000 00000000 00000000
[14254.221229] xhci_hcd 0000:04:00.0: @bac454d0 00000000 00000000 00000000 00000000
[14254.221230] xhci_hcd 0000:04:00.0: @bac454e0 00000000 00000000 00000000 00000000
[14254.221231] xhci_hcd 0000:04:00.0: @bac454f0 00000000 00000000 00000000 00000000
[14254.221232] xhci_hcd 0000:04:00.0: @bac45500 00000000 00000000 00000000 00000000
[14254.221233] xhci_hcd 0000:04:00.0: @bac45510 00000000 00000000 00000000 00000000
[14254.221234] xhci_hcd 0000:04:00.0: @bac45520 00000000 00000000 00000000 00000000
[14254.221235] xhci_hcd 0000:04:00.0: @bac45530 00000000 00000000 00000000 00000000
[14254.221236] xhci_hcd 0000:04:00.0: @bac45540 00000000 00000000 00000000 00000000
[14254.221237] xhci_hcd 0000:04:00.0: @bac45550 00000000 00000000 00000000 00000000
[14254.221238] xhci_hcd 0000:04:00.0: @bac45560 00000000 00000000 00000000 00000000
[14254.221239] xhci_hcd 0000:04:00.0: @bac45570 00000000 00000000 00000000 00000000
[14254.221240] xhci_hcd 0000:04:00.0: @bac45580 00000000 00000000 00000000 00000000
[14254.221241] xhci_hcd 0000:04:00.0: @bac45590 00000000 00000000 00000000 00000000
[14254.221242] xhci_hcd 0000:04:00.0: @bac455a0 00000000 00000000 00000000 00000000
[14254.221243] xhci_hcd 0000:04:00.0: @bac455b0 00000000 00000000 00000000 00000000
[14254.221244] xhci_hcd 0000:04:00.0: @bac455c0 00000000 00000000 00000000 00000000
[14254.221245] xhci_hcd 0000:04:00.0: @bac455d0 00000000 00000000 00000000 00000000
[14254.221246] xhci_hcd 0000:04:00.0: @bac455e0 00000000 00000000 00000000 00000000
[14254.221247] xhci_hcd 0000:04:00.0: @bac455f0 00000000 00000000 00000000 00000000
[14254.221248] xhci_hcd 0000:04:00.0: @bac45600 00000000 00000000 00000000 00000000
[14254.221249] xhci_hcd 0000:04:00.0: @bac45610 00000000 00000000 00000000 00000000
[14254.221250] xhci_hcd 0000:04:00.0: @bac45620 00000000 00000000 00000000 00000000
[14254.221251] xhci_hcd 0000:04:00.0: @bac45630 00000000 00000000 00000000 00000000
[14254.221252] xhci_hcd 0000:04:00.0: @bac45640 00000000 00000000 00000000 00000000
[14254.221253] xhci_hcd 0000:04:00.0: @bac45650 00000000 00000000 00000000 00000000
[14254.221254] xhci_hcd 0000:04:00.0: @bac45660 00000000 00000000 00000000 00000000
[14254.221255] xhci_hcd 0000:04:00.0: @bac45670 00000000 00000000 00000000 00000000
[14254.221256] xhci_hcd 0000:04:00.0: @bac45680 00000000 00000000 00000000 00000000
[14254.221257] xhci_hcd 0000:04:00.0: @bac45690 00000000 00000000 00000000 00000000
[14254.221258] xhci_hcd 0000:04:00.0: @bac456a0 00000000 00000000 00000000 00000000
[14254.221259] xhci_hcd 0000:04:00.0: @bac456b0 00000000 00000000 00000000 00000000
[14254.221260] xhci_hcd 0000:04:00.0: @bac456c0 00000000 00000000 00000000 00000000
[14254.221261] xhci_hcd 0000:04:00.0: @bac456d0 00000000 00000000 00000000 00000000
[14254.221262] xhci_hcd 0000:04:00.0: @bac456e0 00000000 00000000 00000000 00000000
[14254.221263] xhci_hcd 0000:04:00.0: @bac456f0 00000000 00000000 00000000 00000000
[14254.221264] xhci_hcd 0000:04:00.0: @bac45700 00000000 00000000 00000000 00000000
[14254.221265] xhci_hcd 0000:04:00.0: @bac45710 00000000 00000000 00000000 00000000
[14254.221266] xhci_hcd 0000:04:00.0: @bac45720 00000000 00000000 00000000 00000000
[14254.221267] xhci_hcd 0000:04:00.0: @bac45730 00000000 00000000 00000000 00000000
[14254.221268] xhci_hcd 0000:04:00.0: @bac45740 00000000 00000000 00000000 00000000
[14254.221269] xhci_hcd 0000:04:00.0: @bac45750 00000000 00000000 00000000 00000000
[14254.221270] xhci_hcd 0000:04:00.0: @bac45760 00000000 00000000 00000000 00000000
[14254.221271] xhci_hcd 0000:04:00.0: @bac45770 00000000 00000000 00000000 00000000
[14254.221272] xhci_hcd 0000:04:00.0: @bac45780 00000000 00000000 00000000 00000000
[14254.221273] xhci_hcd 0000:04:00.0: @bac45790 00000000 00000000 00000000 00000000
[14254.221274] xhci_hcd 0000:04:00.0: @bac457a0 00000000 00000000 00000000 00000000
[14254.221275] xhci_hcd 0000:04:00.0: @bac457b0 00000000 00000000 00000000 00000000
[14254.221276] xhci_hcd 0000:04:00.0: @bac457c0 00000000 00000000 00000000 00000000
[14254.221277] xhci_hcd 0000:04:00.0: @bac457d0 00000000 00000000 00000000 00000000
[14254.221278] xhci_hcd 0000:04:00.0: @bac457e0 00000000 00000000 00000000 00000000
[14254.221279] xhci_hcd 0000:04:00.0: @bac457f0 00000000 00000000 00000000 00000000
[14254.221280] xhci_hcd 0000:04:00.0:   Ring has not been updated
[14254.221281] xhci_hcd 0000:04:00.0: Ring deq = ffff8800bac45400 (virt), 0xbac45400 (dma)
[14254.221282] xhci_hcd 0000:04:00.0: Ring deq updated 0 times
[14254.221283] xhci_hcd 0000:04:00.0: Ring enq = ffff8800bac45400 (virt), 0xbac45400 (dma)
[14254.221284] xhci_hcd 0000:04:00.0: Ring enq updated 0 times
[14254.221289] xhci_hcd 0000:04:00.0: ERST deq = 64'hbac45400
[14254.221290] xhci_hcd 0000:04:00.0: // Set the interrupt modulation register
[14254.221293] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce2024, 32'ha0, 4'hf);
[14254.221296] xhci_hcd 0000:04:00.0: // Enable interrupts, cmd = 0x4.
[14254.221297] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h4, 4'hf);
[14254.221300] xhci_hcd 0000:04:00.0: // Enabling event ring interrupter ffffc90001ce2020 by writing 0x2 to irq_pending
[14254.221301] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce2020, 32'h2, 4'hf);
[14254.221305] xhci_hcd 0000:04:00.0:   ffffc90001ce2020: ir_set[0]
[14254.221306] xhci_hcd 0000:04:00.0:   ffffc90001ce2020: ir_set.pending = 0x2
[14254.221309] xhci_hcd 0000:04:00.0:   ffffc90001ce2024: ir_set.control = 0xa0
[14254.221312] xhci_hcd 0000:04:00.0:   ffffc90001ce2028: ir_set.erst_size = 0x1
[14254.221319] xhci_hcd 0000:04:00.0:   ffffc90001ce2030: ir_set.erst_base = @bac44000
[14254.221325] xhci_hcd 0000:04:00.0:   ffffc90001ce2038: ir_set.erst_dequeue = @bac45400
[14254.221326] xhci_hcd 0000:04:00.0: Finished xhci_run for USB2 roothub
[14254.221353] usb usb3: default language 0x0409
[14254.221357] usb usb3: udev 1, busnum 3, minor = 256
[14254.221359] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[14254.221360] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[14254.221361] usb usb3: Product: xHCI Host Controller
[14254.221362] usb usb3: Manufacturer: Linux 2.6.39-patser+ xhci_hcd
[14254.221363] usb usb3: SerialNumber: 0000:04:00.0
[14254.221627] usb usb3: usb_probe_device
[14254.221633] usb usb3: configuration #1 chosen from 1 choice
[14254.221642] xHCI xhci_add_endpoint called for root hub
[14254.221644] xHCI xhci_check_bandwidth called for root hub
[14254.221652] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[14254.221684] hub 3-0:1.0: usb_probe_interface
[14254.221686] hub 3-0:1.0: usb_probe_interface - got id
[14254.221689] hub 3-0:1.0: USB hub found
[14254.221702] hub 3-0:1.0: 2 ports detected
[14254.221704] hub 3-0:1.0: standalone hub
[14254.221705] hub 3-0:1.0: individual port power switching
[14254.221705] hub 3-0:1.0: individual port over-current protection
[14254.221706] hub 3-0:1.0: Single TT
[14254.221707] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
[14254.221708] hub 3-0:1.0: power on to power good time: 20ms
[14254.221712] hub 3-0:1.0: local power source is good
[14254.221714] hub 3-0:1.0: enabling power on all ports
[14254.221719] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2e1, 4'hf);
[14254.221723] xhci_hcd 0000:04:00.0: set port power, actual port 0 status  = 0x202e1
[14254.221730] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0430, 32'h2a0, 4'hf);
[14254.221734] xhci_hcd 0000:04:00.0: set port power, actual port 1 status  = 0x2a0
[14254.221799] xhci_hcd 0000:04:00.0: xHCI Host Controller
[14254.221803] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
[14254.228707] xhci_hcd 0000:04:00.0: Enabling 64-bit DMA addresses.
[14254.228710] xhci_hcd 0000:04:00.0: supports USB remote wakeup
[14254.228714] xhci_hcd 0000:04:00.0: // Turn on HC, cmd = 0x5.
[14254.228715] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h5, 4'hf);
[14254.228718] xhci_hcd 0000:04:00.0: Finished xhci_run for USB3 roothub
[14254.228728] xhci_hcd 0000:04:00.0: op reg status = 00000018
[14254.228730] usb usb4: skipped 1 descriptor after endpoint
[14254.228731] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
[14254.228732] usb usb4: default language 0x0409
[14254.228734] xhci_hcd 0000:04:00.0: @bac45400 01000000 00000000 01000000 00008801
[14254.228735] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h18, 4'hf);
[14254.228736] usb usb4: udev 1, busnum 4, minor = 384
[14254.228737] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[14254.228738] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[14254.228739] usb usb4: Product: xHCI Host Controller
[14254.228740] usb usb4: Manufacturer: Linux 2.6.39-patser+ xhci_hcd
[14254.228741] usb usb4: SerialNumber: 0000:04:00.0
[14254.228742] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.228743] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
[14254.228744] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_port_status
[14254.228745] xhci_hcd 0000:04:00.0: Port Status Change Event for port 1
[14254.228749] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac45410 (DMA)
[14254.228755] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_port_status
[14254.228756] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.228760] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac45418, 4'hf);
[14254.228805] usb usb4: usb_probe_device
[14254.228806] usb usb4: configuration #1 chosen from 1 choice
[14254.228809] xHCI xhci_add_endpoint called for root hub
[14254.228810] xHCI xhci_check_bandwidth called for root hub
[14254.228813] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[14254.228826] hub 4-0:1.0: usb_probe_interface
[14254.228827] hub 4-0:1.0: usb_probe_interface - got id
[14254.228828] hub 4-0:1.0: USB hub found
[14254.228834] hub 4-0:1.0: 2 ports detected
[14254.228835] hub 4-0:1.0: standalone hub
[14254.228836] hub 4-0:1.0: individual port power switching
[14254.228837] hub 4-0:1.0: individual port over-current protection
[14254.228838] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
[14254.228839] hub 4-0:1.0: power on to power good time: 20ms
[14254.228841] hub 4-0:1.0: local power source is good
[14254.228842] hub 4-0:1.0: enabling power on all ports
[14254.228846] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0440, 32'h2a0, 4'hf);
[14254.228849] xhci_hcd 0000:04:00.0: set port power, actual port 0 status  = 0x2a0
[14254.228855] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0450, 32'h2a0, 4'hf);
[14254.228859] xhci_hcd 0000:04:00.0: set port power, actual port 1 status  = 0x2a0
[14254.321691] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x202e1
[14254.321697] xhci_hcd 0000:04:00.0: Get port status returned 0x10101
[14254.321703] hub 3-0:1.0: port 1: status 0101 change 0001
[14254.321709] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h202e1, 4'hf);
[14254.321713] xhci_hcd 0000:04:00.0: clear port connect change, actual port 0 status  = 0x2e1
[14254.321717] xhci_hcd 0000:04:00.0: get port status, actual port 1 status  = 0x2a0
[14254.321718] xhci_hcd 0000:04:00.0: Get port status returned 0x100
[14254.328682] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2a0
[14254.328687] xhci_hcd 0000:04:00.0: Get port status returned 0x100
[14254.328696] xhci_hcd 0000:04:00.0: get port status, actual port 1 status  = 0x2a0
[14254.328699] xhci_hcd 0000:04:00.0: Get port status returned 0x100
[14254.328713] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[14254.421740] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[14254.421768] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
[14254.421771] xhci_hcd 0000:04:00.0: Get port status returned 0x101
[14254.421779] hub 3-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[14254.421787] xhci_hcd 0000:04:00.0: Endpoint state = 0x1
[14254.421792] xhci_hcd 0000:04:00.0: Command ring enq = 0xbac45010 (DMA)
[14254.421793] xhci_hcd 0000:04:00.0: // Ding dong!
[14254.421794] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce3000, 32'h0, 4'hf);
[14254.421811] xhci_hcd 0000:04:00.0: op reg status = 00000008
[14254.421813] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
[14254.421815] xhci_hcd 0000:04:00.0: @bac45410 bac45000 00000000 01000000 01008401
[14254.421816] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h8, 4'hf);
[14254.421820] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.421821] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
[14254.421823] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_cmd_completion
[14254.421827] xhci_hcd 0000:04:00.0: Command ring deq = 0xbac45010 (DMA)
[14254.421828] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_cmd_completion
[14254.421829] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac45420 (DMA)
[14254.421830] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.421836] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac45428, 4'hf);
[14254.421850] xhci_hcd 0000:04:00.0: Slot 1 output ctx = 0xa6088000 (dma)
[14254.421854] xhci_hcd 0000:04:00.0: Slot 1 input ctx = 0xa60b4000 (dma)
[14254.421857] xhci_hcd 0000:04:00.0: Allocating ring at ffff8801c5843de0
[14254.421860] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff880216ba3a60
[14254.421863] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac45800 (virtual) 0xbac45800 (DMA)
[14254.421867] xhci_hcd 0000:04:00.0: Linking segment 0xbac45800 to segment 0xbac45800 (DMA)
[14254.421868] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff880216ba3a60 (virtual), 0xbac45800 (DMA)
[14254.421870] xhci_hcd 0000:04:00.0: Set slot id 1 dcbaa entry ffff8800bac41008 to 0xa6088000
[14254.421889] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2f1, 4'hf);
[14254.421893] xhci_hcd 0000:04:00.0: set port reset, actual port 0 status  = 0x2f1
[14254.457707] xhci_hcd 0000:04:00.0: op reg status = 00000018
[14254.457710] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
[14254.457712] xhci_hcd 0000:04:00.0: @bac45420 01000000 00000000 01000000 00008801
[14254.457714] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h18, 4'hf);
[14254.457715] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.457716] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
[14254.457718] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_port_status
[14254.457719] xhci_hcd 0000:04:00.0: Port Status Change Event for port 1
[14254.457725] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac45430 (DMA)
[14254.457732] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_port_status
[14254.457733] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.457739] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac45438, 4'hf);
[14254.472687] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x200603
[14254.472692] xhci_hcd 0000:04:00.0: Get port status returned 0x103
[14254.523694] xhci_hcd 0000:04:00.0: Resetting device with slot ID 1
[14254.523700] xhci_hcd 0000:04:00.0: Endpoint state = 0x1
[14254.523702] xhci_hcd 0000:04:00.0: Command ring enq = 0xbac45020 (DMA)
[14254.523703] xhci_hcd 0000:04:00.0: // Ding dong!
[14254.523704] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce3000, 32'h0, 4'hf);
[14254.523714] xhci_hcd 0000:04:00.0: op reg status = 00000008
[14254.523716] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
[14254.523717] xhci_hcd 0000:04:00.0: @bac45430 bac45010 00000000 c0000000 01008401
[14254.523718] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h8, 4'hf);
[14254.523720] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.523720] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
[14254.523721] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_cmd_completion
[14254.523723] xhci_hcd 0000:04:00.0: Completed reset device command.
[14254.523725] xhci_hcd 0000:04:00.0: Command ring deq = 0xbac45020 (DMA)
[14254.523726] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_cmd_completion
[14254.523727] xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
[14254.523729] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac45440 (DMA)
[14254.523730] usb 3-1: Cannot reset HCD device state
[14254.523731] hub 3-0:1.0: port 1 not enabled, trying reset again...
[14254.523732] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.523737] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac45448, 4'hf);
[14254.523742] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h611, 4'hf);
[14254.523746] xhci_hcd 0000:04:00.0: set port reset, actual port 0 status  = 0x2006f1
[14254.724682] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x200603
[14254.724688] xhci_hcd 0000:04:00.0: Get port status returned 0x103
[14254.775660] xhci_hcd 0000:04:00.0: Resetting device with slot ID 1
[14254.775666] xhci_hcd 0000:04:00.0: Endpoint state = 0x1
[14254.775668] xhci_hcd 0000:04:00.0: Command ring enq = 0xbac45030 (DMA)
[14254.775669] xhci_hcd 0000:04:00.0: // Ding dong!
[14254.775670] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce3000, 32'h0, 4'hf);
[14254.775680] xhci_hcd 0000:04:00.0: op reg status = 00000008
[14254.775681] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
[14254.775683] xhci_hcd 0000:04:00.0: @bac45440 bac45020 00000000 c0000000 01008401
[14254.775684] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h8, 4'hf);
[14254.775685] xhci_hcd 0000:04:00.0: In xhci_handle_event
[14254.775686] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
[14254.775687] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_cmd_completion
[14254.775688] xhci_hcd 0000:04:00.0: Completed reset device command.
[14254.775690] xhci_hcd 0000:04:00.0: Command ring deq = 0xbac45030 (DMA)
[14254.775691] xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
[14254.775692] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_cmd_completion
[14254.775693] usb 3-1: Cannot reset HCD device state
[14254.775694] hub 3-0:1.0: port 1 not enabled, trying reset again...

