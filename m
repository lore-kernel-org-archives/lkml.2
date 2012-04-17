Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2DQOuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:50:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42023 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DQOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:50:17 -0400
Date: Tue, 17 Apr 2012 16:50:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, tigran@aivazian.fsnet.co.uk,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Message-ID: <20120417145002.GA11221@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
 <20120411201053.GF18114@aftab>
 <20120412162351.GJ24549@aftab>
 <20120412163422.GM24549@aftab>
 <4F8BDB58.6070007@linux.vnet.ibm.com>
 <20120416134335.GD308@aftab>
 <4F8D7A0A.4080404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8D7A0A.4080404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:41:22PM +0530, Srivatsa S. Bhat wrote:
> On 04/16/2012 07:13 PM, Borislav Petkov wrote:
> 
> > On Mon, Apr 16, 2012 at 02:12:00PM +0530, Srivatsa S. Bhat wrote:
> >> I guess a similar change in intel microcode driver would also be
> >> worthwhile, right? If so, then the below patch might be useful:
> > 
> > AFAICT, you'd need to test this on a box which is not supported (family
> > check below). Or you can tweak the family check so that it doesn't
> > apply and run it on a test box of yours to see whether the module still
> > unloads properly in the error case (and doesn't remain loaded as in
> > our case due to something in sysfs remaining registered although it
> > shouldn't).
> > 
> Judging by the nature of the code itself, its evident that this problem
> is not restricted to AMD alone. In any case, I went ahead and did the
> (tweaked) test that you suggested and here is the result:
> 
> 1. dmesg logs :
> [   21.912451] microcode: CPU0 not a capable Intel processor
> [   21.916028] microcode: CPU1 not a capable Intel processor
> [   21.934624] microcode: CPU2 not a capable Intel processor
> [   21.940276] microcode: CPU3 not a capable Intel processor
> [   21.946023] microcode: CPU4 not a capable Intel processor
> [   21.951678] microcode: CPU5 not a capable Intel processor
> [   21.957326] microcode: CPU6 not a capable Intel processor
> [   21.962935] microcode: CPU7 not a capable Intel processor
> [   21.968611] microcode: CPU8 not a capable Intel processor
> [   21.974212] microcode: CPU9 not a capable Intel processor
> [   21.979842] microcode: CPU10 not a capable Intel processor
> [   21.985577] microcode: CPU11 not a capable Intel processor
> [   21.991323] microcode: CPU12 not a capable Intel processor
> [   21.997055] microcode: CPU13 not a capable Intel processor
> [   22.002774] microcode: CPU14 not a capable Intel processor
> [   22.008460] microcode: CPU15 not a capable Intel processor
> [   22.014600] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> 
> 2. lsmod | grep microcode
> microcode             117749  0
> 
> 3. rmmod microcode
> 
> 4. dmesg logs:
> [   64.297638] ------------[ cut here ]------------
> [   64.302332] WARNING: at fs/sysfs/group.c:142 sysfs_remove_group+0xd9/0xe0()
> [   64.309446] Hardware name: IBM System x -[7870C4Q]-
> [   64.309449] sysfs group ffffffffa03a5110 not found for kobject 'cpu0'
> [   64.309451] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod coretemp crc32c_intel shpchp microcode(-) cdc_ether usbnet ioatdma bnx2 mii serio_raw pcspkr pci_hotplug i2c_i801 i7core_edac i2c_core dca edac_core iTCO_wdt iTCO_vendor_support tpm_tis tpm sg tpm_bios rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
> [   64.309499] Pid: 6529, comm: rmmod Not tainted 3.4.0-rc3-intelucodebroken-0.0.0.28.36b5ec9-default #2
> [   64.309501] Call Trace:
> [   64.309506]  [<ffffffff811fac69>] ? sysfs_remove_group+0xd9/0xe0
> [   64.309510]  [<ffffffff811fac69>] ? sysfs_remove_group+0xd9/0xe0
> [   64.309516]  [<ffffffff8103dd2a>] warn_slowpath_common+0x7a/0xb0
> [   64.309522]  [<ffffffff8103de01>] warn_slowpath_fmt+0x41/0x50
> [   64.309526]  [<ffffffff811f87b6>] ? sysfs_get_dirent+0x56/0x80
> [   64.309531]  [<ffffffff811fac69>] sysfs_remove_group+0xd9/0xe0
> [   64.309538]  [<ffffffffa03a2118>] mc_device_remove+0x78/0xa0 [microcode]
> [   64.309545]  [<ffffffff8134b219>] subsys_interface_unregister+0x89/0xd0
> [   64.309553]  [<ffffffffa03a357a>] microcode_exit+0x5a/0xa4 [microcode]
> [   64.309559]  [<ffffffff810b0c8a>] sys_delete_module+0x16a/0x2b0
> [   64.309565]  [<ffffffff810a408d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
> [   64.309573]  [<ffffffff814b36f9>] system_call_fastpath+0x16/0x1b
> [   64.309576] ---[ end trace 748ddf8b4218f820 ]---
> 
> 
> The above warning was repeated for each cpu, of course.

Right, this is the warning we're seeing too. Applying your patch fixes
it, I s'pose? If so, maybe x86 people would pick it up.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
