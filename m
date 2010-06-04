Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0FDW3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:29:39 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59880 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757121Ab0FDW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:29:38 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Re: [linux-pm] Invalid opcode on resume from STR on Asus P4P800-VM
Date: Sat, 5 Jun 2010 00:29:23 +0200
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1004261631320.1764-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004261631320.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006050029.25819.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010 22:34:35 Alan Stern wrote:
> On Mon, 26 Apr 2010, Ondrej Zary wrote:
> > On Monday 26 April 2010 21:17:27 Alan Stern wrote:
> > > On Mon, 26 Apr 2010, Ondrej Zary wrote:
> > > > Hello,
> > > > I'm trying to debug oops on resume from suspend-to-RAM on Asus
> > > > P4P800-VM mainboard. It crashes with invalid opcode (see below). The
> > > > kernel is 2.6.32-trunk from Debian but the same problem is present
> > > > with vanilla kernels - both newer and older (but screen remains blank
> > > > most of the time, only keyboard LEDs blink indicating an oops).
> > > >
> > > > What can cause this problem?
> > > >
> > > >      8.000339  invalid opcode: 0000 [#1] SMP
> > > >      8.003529  last sysfs file: /sys/power/state
> > > >      8.004265  Modules linked in: sco bridge stp bnep l2cacp crc16
> > > > bluetooth rfkill loop i2c_i801 snd_intel8x0 snd_ac97_codec shpchp
> > > > ac97_bus parport_pc parport
> > > > rng_core pci_hotplug snd_pcsp snd_pcm snd_timer snd soundcore psmouse
> > > > snd_page_alloc serio_raw evdev processor ext3 jbd mbcache ide_gd_mod
> > > > ata_generic libata scsi_mod
> > > > ide_pci_generic i915 drm_kms_helper uhci_hcd drm i2c_algo_bit piix
> > > > i2c_core ehci_hcd intel_agp e100 video ide_core mii floppy agpgart
> > > > output usbcore nls_base button
> > > > thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> > > > [  148.004265]
> > > > [  148.004265] Pid: 0, comm: swapper Not tainted (2.6.32-trunk-686
> > > > #1) To Be Filled By O.E.M. [  148.004265] EIP: 0060:[<c1008ff3>]
> > > > EFLAGS: 00010086 CPU: 0
> > > > [  148.004265] EIP is at mwait_idle+0x4e/0x6c
> > >
> > > I had exactly the same problem (on an HP computer with an Intel
> > > chipset).  As far as anyone could figure out, it is caused by a bug in
> > > the BIOS.  It's not entirely clear that this is the complete answer,
> > > but nothing else turned up.  See
> > >
> > > 	http://bugzilla.kernel.org/show_bug.cgi?id=15385
> > >
> > > for the complete record.  The best solution I could find was to boot
> > > with "idle=halt" on the command line.  You might check to see if any
> > > BIOS updates are available.
> >
> > Thanks, it does not crash with "idle=halt" or "idle=poll". According to
> > this: http://siyobik.info/index.php?module=x86&id=215
> > the MWAIT instruction can be enabled/disabled in IA32_MISC_ENABLES MSR.
> > Kernel probably should enable it at boot and also on resume.
> > Here's some more info:
> > http://software.intel.com/en-us/forums/showthread.php?t=63654
>
> That could be the answer.  Clearly this should be handled by the
> arch-specific boot/setup code.  I don't know enough about it, but other
> people do.

Here's a patch that fixes the problem. I don't know how many machines will
it break...


diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_32.h linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_32.h
--- linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_32.h	2010-05-30 22:21:02.000000000 +0200
+++ linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_32.h	2010-06-04 23:52:22.000000000 +0200
@@ -15,6 +15,7 @@ static inline int arch_prepare_suspend(v
 struct saved_context {
 	u16 es, fs, gs, ss;
 	unsigned long cr0, cr2, cr3, cr4;
+	unsigned long misc_enable;
 	struct desc_ptr gdt;
 	struct desc_ptr idt;
 	u16 ldt;
diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_64.h linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_64.h
--- linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_64.h	2010-05-30 22:21:02.000000000 +0200
+++ linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_64.h	2010-06-04 23:52:21.000000000 +0200
@@ -27,6 +27,7 @@ struct saved_context {
 	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
+	unsigned long misc_enable;
 	unsigned long efer;
 	u16 gdt_pad;
 	u16 gdt_limit;
diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/power/cpu.c linux-2.6.35-rc1-git2/arch/x86/power/cpu.c
--- linux-2.6.35-rc1-git2-orig/arch/x86/power/cpu.c	2010-05-30 22:21:02.000000000 +0200
+++ linux-2.6.35-rc1-git2/arch/x86/power/cpu.c	2010-06-04 23:50:52.000000000 +0200
@@ -105,6 +105,7 @@ static void __save_processor_state(struc
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
 #endif
+	rdmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
 }
 
 /* Needed by apm.c */
@@ -152,6 +153,7 @@ static void fix_processor_context(void)
  */
 static void __restore_processor_state(struct saved_context *ctxt)
 {
+	wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
 	/*
 	 * control registers
 	 */


-- 
Ondrej Zary
