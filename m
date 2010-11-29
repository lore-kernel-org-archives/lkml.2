Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0K2WKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:10:41 -0500
Received: from claw.goop.org ([74.207.240.146]:41465 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0K2WKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:10:39 -0500
Message-ID: <4CF424D9.2040102@goop.org>
Date: Mon, 29 Nov 2010 14:10:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Alok Kataria <alokkataria1@gmail.com>
CC: "Alan J. Wylie" <alan@wylie.me.uk>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>, akataria@vmware.com
Subject: Re: Xen domU kernel no longer shuts down (Was Linux 2.6.32.26)
References: <20101122191547.GC4340@kroah.com>	<19695.48938.271140.613069@wylie.me.uk>	<4CF036CF.20606@goop.org> <AANLkTikH+GnpJCjYvn2+LDV30=kNMwNfkA94z+GRpJHG@mail.gmail.com>
In-Reply-To: <AANLkTikH+GnpJCjYvn2+LDV30=kNMwNfkA94z+GRpJHG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 01:35 PM, Alok Kataria wrote:
>
>
> On Fri, Nov 26, 2010 at 2:38 PM, Jeremy Fitzhardinge <jeremy@goop.org
> <mailto:jeremy@goop.org>> wrote:
>
>     On 11/26/2010 06:07 AM, Alan J. Wylie wrote:
>     > Greg KH <gregkh@suse.de <mailto:gregkh@suse.de>> writes:
>     >
>     >> I'm announcing the release of the 2.6.32.26 kernel.
>     > ...
>     >
>     >> Alok Kataria (1):
>     >>       x86, kexec: Make sure to stop all CPUs before exiting the
>     kernel
>     > This patch (ae832c21a08514fd11d2d1d6e217c8a537764bb0) stops my
>     Xen DomU from
>     > shutting down iff vcpus in the xen config file is > 1.
>     >
>     > Simply reverting the commit gets things working properly again.
>
>     Thanks for confirming this.  I had seen the same thing and suspected
>     this change, but hadn't investigated it yet.
>
>
>
> To get the old behavior back for Xen you can replace this call
> smp_call_function(stop_self, NULL, wait);
>
>  in  xen_stop_other_cpus with
>
> smp_call_function(stop_self, NULL, 0);
>
> That should fix your hang and fallback to the original behavior,
> though please note that there might still be a fundamental problem
> about why some of the AP's don't respond to stop_send IPI on XEN.

I'm not even sure that stop_all_cpus() in xen_reboot() is all that
meaningful; if the guest tells Xen its rebooting, I'm pretty sure Xen
will sort out the other VCPUs.

I'll see if I can work out what the root-cause is here, but I suspect it
may be that irqs have been disabled at this point, and Xen IPIs map to
irqs and so are never delivered...

Thanks,
    J


>
> Alok
>
>
>     I'll try to get to a fix next week.
>
>     Thanks,
>        J
>
>
>     > dom0 and domU userspace: recent Gentoo
>     > dom0: 2.6.32.18 (more recent releases won't boot - see below)
>     > domU: 2.6.32.26
>     > Xen: xen-4.0.2-rc1-pre.gz built from very recent mercurial pull
>     >
>     > Hardware: Supermicro X8DTL
>     > Processor: 1 x Intel XEON E5506 quad core
>     >
>     > Note that this is the same motherboard that is having issues as
>     > I have reported on the Xen mailing list:
>     >
>     >
>     http://lists.xensource.com/archives/html/xen-devel/2010-10/msg00257.html
>     >
>     http://lists.xensource.com/archives/html/xen-devel/2010-10/msg00469.html
>     >
>     > If there is any more information or debugging that I can provide
>     I will
>     > be more than happy to help.
>     >
>     > Xen domU config:
>     > ------8<------8<------8<------8<------8<------8<------8<------8<
>     > kernel = "/boot/vmlinuz-2.6.32.26-xenU"
>     > memory = 100
>     > vcpus = 2
>     > name = "alan"
>     > root = "/dev/xvda2 ro"
>     > disk = [
>     >            'phy:/dev/Main/alan-swap,xvda1,w',
>     >            'tap2:aio:/root/alan/images/alan.img,xvda2,w',
>     >        ]
>     > vif = [ 'mac=00:16:3e:15:96:18, bridge=xenbr0' ]
>     > dhcp="dhcp"
>     > extra = "console=hvc0"
>     > ------8<------8<------8<------8<------8<------8<------8<------8<
>     >
>     >
>     > On shutdown the last message is "System halted.", but if vcpus is >1
>     > the Xen domain never exits.
>     >
>     > The last messages on the dom0 are:
>     > Nov 26 13:53:02 alan shutdown[861]: shutting down for system halt
>     > Nov 26 13:53:02 alan init: Switching to runlevel: 0
>     > Nov 26 13:53:03 alan sshd[825]: Received signal 15; terminating.
>     > Nov 26 13:53:03 alan klogd: Kernel logging (proc) stopped.
>     > Nov 26 13:53:03 alan klogd: Kernel log daemon terminating.
>     > Nov 26 13:53:04 alan exiting on signal 15
>     >
>     > and similarly on the domU (looking in /var/log/messages on the
>     disk image):
>     > Nov 26 13:53:02 alan shutdown[861]: shutting down for system halt
>     > Nov 26 13:53:02 alan init: Switching to runlevel: 0
>     > Nov 26 13:53:03 alan sshd[825]: Received signal 15; terminating.
>     > Nov 26 13:53:03 alan klogd: Kernel logging (proc) stopped.
>     > Nov 26 13:53:03 alan klogd: Kernel log daemon terminating.
>     > Nov 26 13:53:04 alan exiting on signal 15
>     >
>     > xm dmesg (nothing after boot):
>     >  \ \/ /___ _ __   | || |  / _ \ / |
>     >   \  // _ \ \047_ \  | || |_| | | || |
>     >   /  \  __/ | | | |__   _| |_| || |
>     >  /_/\_\___|_| |_|    |_|(_)___(_)_|
>     >
>     > (XEN) Xen version 4.0.1 (@example.org <http://example.org>) (gcc
>     version 4.4.4 (Gentoo 4.4.4-r2 p1.2, pie-0.4.5) ) Wed Oct 20
>     15:10:19 BST 2010
>     > (XEN) Latest ChangeSet: unavailable
>     > (XEN) Bootloader: GNU GRUB 0.97
>     > (XEN) Command line: com2=115200,8n1 console=com2 noreboot
>     > (XEN) Video information:
>     > (XEN)  VGA is text mode 80x25, font 8x16
>     > (XEN)  VBE/DDC methods: none; EDID transfer time: 0 seconds
>     > (XEN)  EDID info not retrieved because no DDC retrieval method
>     detected
>     > (XEN) Disc information:
>     > (XEN)  Found 3 MBR signatures
>     > (XEN)  Found 3 EDD information structures
>     > (XEN) Xen-e820 RAM map:
>     > (XEN)  0000000000000000 - 0000000000097c00 (usable)
>     > (XEN)  0000000000097c00 - 00000000000a0000 (reserved)
>     > (XEN)  00000000000e4000 - 0000000000100000 (reserved)
>     > (XEN)  0000000000100000 - 00000000bf780000 (usable)
>     > (XEN)  00000000bf78e000 - 00000000bf790000 type 9
>     > (XEN)  00000000bf790000 - 00000000bf79e000 (ACPI data)
>     > (XEN)  00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
>     > (XEN)  00000000bf7d0000 - 00000000bf7e0000 (reserved)
>     > (XEN)  00000000bf7ec000 - 00000000c0000000 (reserved)
>     > (XEN)  00000000e0000000 - 00000000f0000000 (reserved)
>     > (XEN)  00000000fee00000 - 00000000fee01000 (reserved)
>     > (XEN)  00000000ffc00000 - 0000000100000000 (reserved)
>     > (XEN)  0000000100000000 - 0000000240000000 (usable)
>     > (XEN) ACPI: RSDP 000FAC10, 0024 (r2 ACPIAM)
>     > (XEN) ACPI: XSDT BF790100, 0084 (r1 SMCI            20100528
>     MSFT       97)
>     > (XEN) ACPI: FACP BF790290, 00F4 (r4 052810 FACP1443 20100528
>     MSFT       97)
>     > (XEN) ACPI: DSDT BF7906A0, 650A (r2  10006 10006000        0
>     INTL 20051117)
>     > (XEN) ACPI: FACS BF79E000, 0040
>     > (XEN) ACPI: APIC BF790390, 011E (r2 052810 APIC1443 20100528
>     MSFT       97)
>     > (XEN) ACPI: MCFG BF7904B0, 003C (r1 052810 OEMMCFG  20100528
>     MSFT       97)
>     > (XEN) ACPI: SLIT BF7904F0, 0030 (r1 052810 OEMSLIT  20100528
>     MSFT       97)
>     > (XEN) ACPI: OEMB BF79E040, 007D (r1 052810 OEMB1443 20100528
>     MSFT       97)
>     > (XEN) ACPI: HPET BF79A6A0, 0038 (r1 052810 OEMHPET  20100528
>     MSFT       97)
>     > (XEN) ACPI: DMAR BF79E0C0, 0128 (r1    AMI  OEMDMAR        1
>     MSFT       97)
>     > (XEN) ACPI: SSDT BF79EFC0, 0363 (r1 DpgPmm    CpuPm       12
>     INTL 20051117)
>     > (XEN) ACPI: EINJ BF79A6E0, 0130 (r1  AMIER AMI_EINJ 20100528
>     MSFT       97)
>     > (XEN) ACPI: BERT BF79A870, 0030 (r1  AMIER AMI_BERT 20100528
>     MSFT       97)
>     > (XEN) ACPI: ERST BF79A8A0, 01B0 (r1  AMIER AMI_ERST 20100528
>     MSFT       97)
>     > (XEN) ACPI: HEST BF79AA50, 00A8 (r1  AMIER ABC_HEST 20100528
>     MSFT       97)
>     > (XEN) System RAM: 8183MB (8379484kB)
>     > (XEN) No NUMA configuration found
>     > (XEN) Faking a node at 0000000000000000-0000000240000000
>     > (XEN) Domain heap initialised
>     > (XEN) found SMP MP-table at 000ff780
>     > (XEN) DMI present.
>     > (XEN) Using APIC driver default
>     > (XEN) ACPI: PM-Timer IO Port: 0x808
>     > (XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[804,0], pm1x_evt[800,0]
>     > (XEN) ACPI:                  wakeup_vec[bf79e00c], vec_size[20]
>     > (XEN) ACPI: Local APIC address 0xfee00000
>     > (XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>     > (XEN) Processor #0 7:10 APIC version 21
>     > (XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>     > (XEN) Processor #2 7:10 APIC version 21
>     > (XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
>     > (XEN) Processor #4 7:10 APIC version 21
>     > (XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
>     > (XEN) Processor #6 7:10 APIC version 21
>     > (XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
>     > (XEN) ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
>     > (XEN) ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
>     > (XEN) ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>     > (XEN) IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
>     > (XEN) ACPI: IOAPIC (id[0x03] address[0xfec8a000] gsi_base[24])
>     > (XEN) IOAPIC[1]: apic_id 3, version 32, address 0xfec8a000, GSI
>     24-47
>     > (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>     > (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>     > (XEN) ACPI: IRQ0 used by override.
>     > (XEN) ACPI: IRQ2 used by override.
>     > (XEN) ACPI: IRQ9 used by override.
>     > (XEN) Enabling APIC mode:  Flat.  Using 2 I/O APICs
>     > (XEN) ACPI: HPET id: 0x8086a301 base: 0xfed00000
>     > (XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0
>     - 255
>     > (XEN) PCI: MCFG area at e0000000 reserved in E820
>     > (XEN) Using ACPI (MADT) for SMP configuration information
>     > (XEN) Using scheduler: SMP Credit Scheduler (credit)
>     > (XEN) Detected 2133.459 MHz processor.
>     > (XEN) Initing memory sharing.
>     > (XEN) VMX: Supported advanced features:
>     > (XEN)  - APIC MMIO access virtualisation
>     > (XEN)  - APIC TPR shadow
>     > (XEN)  - Extended Page Tables (EPT)
>     > (XEN)  - Virtual-Processor Identifiers (VPID)
>     > (XEN)  - Virtual NMI
>     > (XEN)  - MSR direct-access bitmap
>     > (XEN) EPT supports 2MB super page.
>     > (XEN) HVM: ASIDs enabled.
>     > (XEN) HVM: VMX enabled
>     > (XEN) HVM: Hardware Assisted Paging detected.
>     > (XEN) Intel machine check reporting enabled
>     > (XEN) Intel VT-d Snoop Control supported.
>     > (XEN) Intel VT-d DMA Passthrough not supported.
>     > (XEN) Intel VT-d Queued Invalidation supported.
>     > (XEN) Intel VT-d Interrupt Remapping not supported.
>     > (XEN) I/O virtualisation enabled
>     > (XEN)  - Dom0 mode: Relaxed
>     > (XEN) Total of 4 processors activated.
>     > (XEN) ENABLING IO-APIC IRQs
>     > (XEN)  -> Using new ACK method
>     > (XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
>     > (XEN) TSC is reliable, synchronization unnecessary
>     > (XEN) Platform timer is 14.318MHz HPET
>     > (XEN) Allocated console ring of 32 KiB.
>     > (XEN) microcode.c:73:d32767 microcode: CPU1 resumed
>     > (XEN) microcode.c:73:d32767 microcode: CPU2 resumed
>     > (XEN) Brought up 4 CPUs
>     > (XEN) microcode.c:73:d32767 microcode: CPU3 resumed
>     > (XEN) HPET: 4 timers in total, 0 timers will be used for broadcast
>     > (XEN) ACPI sleep modes: S3
>     > (XEN) mcheck_poll: Machine check polling timer started.
>     > (XEN) *** LOADING DOMAIN 0 ***
>     > (XEN) elf_parse_binary: phdr: paddr=0x1000000 memsz=0x445000
>     > (XEN) elf_parse_binary: phdr: paddr=0x1445000 memsz=0xf4664
>     > (XEN) elf_parse_binary: phdr: paddr=0x153a000 memsz=0x888
>     > (XEN) elf_parse_binary: phdr: paddr=0x153b000 memsz=0x132d8
>     > (XEN) elf_parse_binary: phdr: paddr=0x154f000 memsz=0x162000
>     > (XEN) elf_parse_binary: memory: 0x1000000 -> 0x16b1000
>     > (XEN) elf_xen_parse_note: GUEST_OS = "linux"
>     > (XEN) elf_xen_parse_note: GUEST_VERSION = "2.6"
>     > (XEN) elf_xen_parse_note: XEN_VERSION = "xen-3.0"
>     > (XEN) elf_xen_parse_note: VIRT_BASE = 0xffffffff80000000
>     > (XEN) elf_xen_parse_note: ENTRY = 0xffffffff8154f200
>     > (XEN) elf_xen_parse_note: HYPERCALL_PAGE = 0xffffffff81009000
>     > (XEN) elf_xen_parse_note: FEATURES =
>     "!writable_page_tables|pae_pgdir_above_4gb"
>     > (XEN) elf_xen_parse_note: PAE_MODE = "yes"
>     > (XEN) elf_xen_parse_note: LOADER = "generic"
>     > (XEN) elf_xen_parse_note: unknown xen elf note (0xd)
>     > (XEN) elf_xen_parse_note: SUSPEND_CANCEL = 0x1
>     > (XEN) elf_xen_parse_note: HV_START_LOW = 0xffff800000000000
>     > (XEN) elf_xen_parse_note: PADDR_OFFSET = 0x0
>     > (XEN) elf_xen_addr_calc_check: addresses:
>     > (XEN)     virt_base        = 0xffffffff80000000
>     > (XEN)     elf_paddr_offset = 0x0
>     > (XEN)     virt_offset      = 0xffffffff80000000
>     > (XEN)     virt_kstart      = 0xffffffff81000000
>     > (XEN)     virt_kend        = 0xffffffff816b1000
>     > (XEN)     virt_entry       = 0xffffffff8154f200
>     > (XEN)     p2m_base         = 0xffffffffffffffff
>     > (XEN)  Xen  kernel: 64-bit, lsb, compat32
>     > (XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x16b1000
>     > (XEN) PHYSICAL MEMORY ARRANGEMENT:
>     > (XEN)  Dom0 alloc.:   0000000234000000->0000000238000000
>     (2021487 pages to be allocated)
>     > (XEN) VIRTUAL MEMORY ARRANGEMENT:
>     > (XEN)  Loaded kernel: ffffffff81000000->ffffffff816b1000
>     > (XEN)  Init. ramdisk: ffffffff816b1000->ffffffff816b1000
>     > (XEN)  Phys-Mach map: ffffffff816b1000->ffffffff8263d378
>     > (XEN)  Start info:    ffffffff8263e000->ffffffff8263e4b4
>     > (XEN)  Page tables:   ffffffff8263f000->ffffffff82656000
>     > (XEN)  Boot stack:    ffffffff82656000->ffffffff82657000
>     > (XEN)  TOTAL:         ffffffff80000000->ffffffff82800000
>     > (XEN)  ENTRY ADDRESS: ffffffff8154f200
>     > (XEN) Dom0 has maximum 4 VCPUs
>     > (XEN) elf_load_binary: phdr 0 at 0xffffffff81000000 ->
>     0xffffffff81445000
>     > (XEN) elf_load_binary: phdr 1 at 0xffffffff81445000 ->
>     0xffffffff81539664
>     > (XEN) elf_load_binary: phdr 2 at 0xffffffff8153a000 ->
>     0xffffffff8153a888
>     > (XEN) elf_load_binary: phdr 3 at 0xffffffff8153b000 ->
>     0xffffffff8154e2d8
>     > (XEN) elf_load_binary: phdr 4 at 0xffffffff8154f000 ->
>     0xffffffff815b7000
>     > (XEN) Scrubbing Free RAM: .done.
>     > (XEN) trace.c:89:d32767 calc_tinfo_first_offset: NR_CPUs 128,
>     offset_in_bytes 258, t_info_first_offset 65
>     > (XEN) Xen trace buffers: disabled
>     > (XEN) Std. Loglevel: All
>     > (XEN) Guest Loglevel: All
>     > (XEN) *** Serial input -> DOM0 (type \047CTRL-a\047 three times
>     to switch input to Xen)
>     > (XEN) Freed 168kB init memory.
>     > (XEN) PCI add device 00:00.0
>     > (XEN) PCI add device 00:01.0
>     > (XEN) PCI add device 00:03.0
>     > (XEN) PCI add device 00:07.0
>     > (XEN) PCI add device 00:09.0
>     > (XEN) PCI add device 00:13.0
>     > (XEN) PCI add device 00:14.0
>     > (XEN) PCI add device 00:14.1
>     > (XEN) PCI add device 00:14.2
>     > (XEN) PCI add device 00:14.3
>     > (XEN) PCI add device 00:16.0
>     > (XEN) PCI add device 00:16.1
>     > (XEN) PCI add device 00:16.2
>     > (XEN) PCI add device 00:16.3
>     > (XEN) PCI add device 00:16.4
>     > (XEN) PCI add device 00:16.5
>     > (XEN) PCI add device 00:16.6
>     > (XEN) PCI add device 00:16.7
>     > (XEN) PCI add device 00:1a.0
>     > (XEN) PCI add device 00:1a.1
>     > (XEN) PCI add device 00:1a.2
>     > (XEN) PCI add device 00:1a.7
>     > (XEN) PCI add device 00:1b.0
>     > (XEN) PCI add device 00:1c.0
>     > (XEN) PCI add device 00:1c.4
>     > (XEN) PCI add device 00:1c.5
>     > (XEN) PCI add device 00:1d.0
>     > (XEN) PCI add device 00:1d.1
>     > (XEN) PCI add device 00:1d.2
>     > (XEN) PCI add device 00:1d.7
>     > (XEN) PCI add device 00:1e.0
>     > (XEN) PCI add device 00:1f.0
>     > (XEN) PCI add device 00:1f.2
>     > (XEN) PCI add device 00:1f.3
>     > (XEN) PCI add device 06:00.0
>     > (XEN) PCI add device 07:00.0
>     > (XEN) PCI add device 08:01.0
>     > (XEN) HVM1: HVM Loader
>     > (XEN) HVM1: Detected Xen v4.0.1
>     > (XEN) HVM1: CPU speed is 2133 MHz
>     > (XEN) irq.c:243: Dom1 PCI link 0 changed 0 -> 5
>     > (XEN) HVM1: PCI-ISA link 0 routed to IRQ5
>     > (XEN) irq.c:243: Dom1 PCI link 1 changed 0 -> 10
>     > (XEN) HVM1: PCI-ISA link 1 routed to IRQ10
>     > (XEN) irq.c:243: Dom1 PCI link 2 changed 0 -> 11
>     > (XEN) HVM1: PCI-ISA link 2 routed to IRQ11
>     > (XEN) irq.c:243: Dom1 PCI link 3 changed 0 -> 5
>     > (XEN) HVM1: PCI-ISA link 3 routed to IRQ5
>     > (XEN) HVM1: pci dev 01:2 INTD->IRQ5
>     > (XEN) HVM1: pci dev 01:3 INTA->IRQ10
>     > (XEN) HVM1: pci dev 03:0 INTA->IRQ5
>     > (XEN) HVM1: pci dev 04:0 INTA->IRQ5
>     > (XEN) HVM1: pci dev 02:0 bar 10 size 02000000: f0000008
>     > (XEN) HVM1: pci dev 03:0 bar 14 size 01000000: f2000008
>     > (XEN) HVM1: pci dev 02:0 bar 14 size 00001000: f3000000
>     > (XEN) HVM1: pci dev 03:0 bar 10 size 00000100: 0000c001
>     > (XEN) HVM1: pci dev 04:0 bar 10 size 00000100: 0000c101
>     > (XEN) HVM1: pci dev 04:0 bar 14 size 00000100: f3001000
>     > (XEN) HVM1: pci dev 01:2 bar 20 size 00000020: 0000c201
>     > (XEN) HVM1: pci dev 01:1 bar 20 size 00000010: 0000c221
>     > (XEN) HVM1: Multiprocessor initialisation:
>     > (XEN) HVM1:  - CPU0 ... 40-bit phys ... fixed MTRRs ... var
>     MTRRs [2/8] ... done.
>     > (XEN) HVM1: Writing SMBIOS tables ...
>     > (XEN) HVM1: Loading ROMBIOS ...
>     > (XEN) HVM1: 10588 bytes of ROMBIOS high-memory extensions:
>     > (XEN) HVM1:   Relocating to 0xfc000000-0xfc00295c ... done
>     > (XEN) HVM1: Creating MP tables ...
>     > (XEN) HVM1: Loading Cirrus VGABIOS ...
>     > (XEN) HVM1: Loading PCI Option ROM ...
>     > (XEN) HVM1:  - Manufacturer: http://etherboot.org
>     > (XEN) HVM1:  - Product name: gPXE
>     > (XEN) HVM1: Loading ACPI ...
>     > (XEN) HVM1:  - Lo data: 000ea020-000ea04f
>     > (XEN) HVM1:  - Hi data: fc002c00-fc012d1f
>     > (XEN) HVM1: vm86 TSS at fc013000
>     > (XEN) HVM1: BIOS map:
>     > (XEN) HVM1:  c0000-c8fff: VGA BIOS
>     > (XEN) HVM1:  c9000-d57ff: Etherboot ROM
>     > (XEN) HVM1:  eb000-eb140: SMBIOS tables
>     > (XEN) HVM1:  f0000-fffff: Main BIOS
>     > (XEN) HVM1: Invoking ROMBIOS ...
>     > (XEN) HVM1: $Revision: 1.221 $ $Date: 2008/12/07 17:32:29 $
>     > (XEN) stdvga.c:147:d1 entering stdvga and caching modes
>     > (XEN) HVM1: VGABios $Id: vgabios.c,v 1.67 2008/01/27 09:44:12
>     vruppert Exp $
>     > (XEN) HVM1: Bochs BIOS - build: 06/23/99
>     > (XEN) HVM1: $Revision: 1.221 $ $Date: 2008/12/07 17:32:29 $
>     > (XEN) HVM1: Options: apmbios pcibios eltorito PMM
>     > (XEN) HVM1:
>     > (XEN) HVM1: ata0-0: PCHS=16383/16/63 translation=lba
>     LCHS=1024/255/63
>     > (XEN) HVM1: ata0 master: QEMU HARDDISK ATA-7 Hard-Disk (10240
>     MBytes)
>     > (XEN) HVM1: IDE time out
>     > (XEN) HVM1:
>     > (XEN) HVM1:
>     > (XEN) HVM1:
>     > (XEN) HVM1: Press F12 for boot menu.
>     > (XEN) HVM1:
>     > (XEN) HVM1: Booting from Hard Disk...
>     > (XEN) HVM1: Booting from 0000:7c00
>     > (XEN) stdvga.c:151:d1 leaving stdvga
>     > (XEN) HVM1: int13_diskette: unsupported AH=41
>     > (XEN) irq.c:243: Dom1 PCI link 0 changed 5 -> 0
>     > (XEN) irq.c:243: Dom1 PCI link 1 changed 10 -> 0
>     > (XEN) irq.c:243: Dom1 PCI link 2 changed 11 -> 0
>     > (XEN) irq.c:243: Dom1 PCI link 3 changed 5 -> 0
>     > (XEN) grant_table.c:1121:d1 Expanding dom (1) grant table from
>     (4) to (32) frames.
>     > (XEN) irq.c:309: Dom1 callback via changed to GSI 28
>     > (XEN) memory.c:132:d0 Could not allocate order=0 extent: id=4
>     memflags=0 (136483 of 262144)
>     >
>     > xm info:
>     > host                   : xenity
>     > release                : 2.6.32.18-xen0
>     > version                : #3 SMP Mon Nov 22 10:39:24 GMT 2010
>     > machine                : x86_64
>     > nr_cpus                : 4
>     > nr_nodes               : 1
>     > cores_per_socket       : 4
>     > threads_per_core       : 1
>     > cpu_mhz                : 2133
>     > hw_caps                :
>     bfebfbff:28100800:00000000:00001b40:009ce3bd:00000000:00000001:00000000
>     > virt_caps              : hvm hvm_directio
>     > total_memory           : 8183
>     > free_memory            : 928
>     > node_to_cpu            : node0:0-3
>     > node_to_memory         : node0:928
>     > node_to_dma32_mem      : node0:109
>     > max_node_id            : 0
>     > xen_major              : 4
>     > xen_minor              : 0
>     > xen_extra              : .1
>     > xen_caps               : xen-3.0-x86_64 xen-3.0-x86_32p
>     hvm-3.0-x86_32 hvm-3.0-x86_32p hvm-3.0-x86_64
>     > xen_scheduler          : credit
>     > xen_pagesize           : 4096
>     > platform_params        : virt_start=0xffff800000000000
>     > xen_changeset          : unavailable
>     > xen_commandline        : com2=115200,8n1 console=com2 noreboot
>     > cc_compiler            : gcc version 4.4.4 (Gentoo 4.4.4-r2
>     p1.2, pie-0.4.5)
>     > cc_compile_by          :
>     > cc_compile_date        : Wed Oct 20 15:10:19 BST 2010
>     > xend_config_format     : 4
>     >
>     >
>     >
>     > Dom0 config:
>     > # zgrep -vE "^(#|$)" /proc/config.gz
>     > CONFIG_64BIT=y
>     > CONFIG_X86_64=y
>     > CONFIG_X86=y
>     > CONFIG_OUTPUT_FORMAT="elf64-x86-64"
>     > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
>     > CONFIG_GENERIC_TIME=y
>     > CONFIG_GENERIC_CMOS_UPDATE=y
>     > CONFIG_CLOCKSOURCE_WATCHDOG=y
>     > CONFIG_GENERIC_CLOCKEVENTS=y
>     > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>     > CONFIG_LOCKDEP_SUPPORT=y
>     > CONFIG_STACKTRACE_SUPPORT=y
>     > CONFIG_HAVE_LATENCYTOP_SUPPORT=y
>     > CONFIG_MMU=y
>     > CONFIG_ZONE_DMA=y
>     > CONFIG_GENERIC_ISA_DMA=y
>     > CONFIG_GENERIC_IOMAP=y
>     > CONFIG_GENERIC_BUG=y
>     > CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
>     > CONFIG_GENERIC_HWEIGHT=y
>     > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
>     > CONFIG_RWSEM_XCHGADD_ALGORITHM=y
>     > CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
>     > CONFIG_GENERIC_CALIBRATE_DELAY=y
>     > CONFIG_GENERIC_TIME_VSYSCALL=y
>     > CONFIG_ARCH_HAS_CPU_RELAX=y
>     > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
>     > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
>     > CONFIG_HAVE_SETUP_PER_CPU_AREA=y
>     > CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
>     > CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
>     > CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
>     > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
>     > CONFIG_ARCH_SUSPEND_POSSIBLE=y
>     > CONFIG_ZONE_DMA32=y
>     > CONFIG_ARCH_POPULATES_NODE_MAP=y
>     > CONFIG_AUDIT_ARCH=y
>     > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
>     > CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
>     > CONFIG_GENERIC_HARDIRQS=y
>     > CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
>     > CONFIG_GENERIC_IRQ_PROBE=y
>     > CONFIG_GENERIC_PENDING_IRQ=y
>     > CONFIG_USE_GENERIC_SMP_HELPERS=y
>     > CONFIG_X86_64_SMP=y
>     > CONFIG_X86_HT=y
>     > CONFIG_X86_TRAMPOLINE=y
>     > CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>     > CONFIG_CONSTRUCTORS=y
>     > CONFIG_LOCK_KERNEL=y
>     > CONFIG_INIT_ENV_ARG_LIMIT=32
>     > CONFIG_LOCALVERSION="-xen0"
>     > CONFIG_HAVE_KERNEL_GZIP=y
>     > CONFIG_HAVE_KERNEL_BZIP2=y
>     > CONFIG_HAVE_KERNEL_LZMA=y
>     > CONFIG_KERNEL_BZIP2=y
>     > CONFIG_SWAP=y
>     > CONFIG_SYSVIPC=y
>     > CONFIG_SYSVIPC_SYSCTL=y
>     > CONFIG_TREE_RCU=y
>     > CONFIG_RCU_FANOUT=64
>     > CONFIG_IKCONFIG=y
>     > CONFIG_IKCONFIG_PROC=y
>     > CONFIG_LOG_BUF_SHIFT=16
>     > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>     > CONFIG_NAMESPACES=y
>     > CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>     > CONFIG_SYSCTL=y
>     > CONFIG_ANON_INODES=y
>     > CONFIG_UID16=y
>     > CONFIG_SYSCTL_SYSCALL=y
>     > CONFIG_KALLSYMS=y
>     > CONFIG_HOTPLUG=y
>     > CONFIG_PRINTK=y
>     > CONFIG_BUG=y
>     > CONFIG_ELF_CORE=y
>     > CONFIG_PCSPKR_PLATFORM=y
>     > CONFIG_BASE_FULL=y
>     > CONFIG_FUTEX=y
>     > CONFIG_EPOLL=y
>     > CONFIG_SIGNALFD=y
>     > CONFIG_TIMERFD=y
>     > CONFIG_EVENTFD=y
>     > CONFIG_SHMEM=y
>     > CONFIG_AIO=y
>     > CONFIG_HAVE_PERF_EVENTS=y
>     > CONFIG_PERF_EVENTS=y
>     > CONFIG_VM_EVENT_COUNTERS=y
>     > CONFIG_PCI_QUIRKS=y
>     > CONFIG_SLAB=y
>     > CONFIG_HAVE_OPROFILE=y
>     > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
>     > CONFIG_HAVE_IOREMAP_PROT=y
>     > CONFIG_HAVE_KPROBES=y
>     > CONFIG_HAVE_KRETPROBES=y
>     > CONFIG_HAVE_ARCH_TRACEHOOK=y
>     > CONFIG_HAVE_DMA_ATTRS=y
>     > CONFIG_HAVE_DMA_API_DEBUG=y
>     > CONFIG_SLABINFO=y
>     > CONFIG_RT_MUTEXES=y
>     > CONFIG_BASE_SMALL=0
>     > CONFIG_MODULES=y
>     > CONFIG_STOP_MACHINE=y
>     > CONFIG_BLOCK=y
>     > CONFIG_BLK_DEV_BSG=y
>     > CONFIG_BLOCK_COMPAT=y
>     > CONFIG_IOSCHED_NOOP=y
>     > CONFIG_IOSCHED_AS=y
>     > CONFIG_IOSCHED_DEADLINE=y
>     > CONFIG_DEFAULT_DEADLINE=y
>     > CONFIG_DEFAULT_IOSCHED="deadline"
>     > CONFIG_FREEZER=y
>     > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>     > CONFIG_SMP=y
>     > CONFIG_X86_MPPARSE=y
>     > CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
>     > CONFIG_SCHED_OMIT_FRAME_POINTER=y
>     > CONFIG_PARAVIRT_GUEST=y
>     > CONFIG_XEN=y
>     > CONFIG_XEN_MAX_DOMAIN_MEMORY=128
>     > CONFIG_XEN_SAVE_RESTORE=y
>     > CONFIG_SWIOTLB_XEN=y
>     > CONFIG_MICROCODE_XEN=y
>     > CONFIG_XEN_DOM0=y
>     > CONFIG_XEN_PRIVILEGED_GUEST=y
>     > CONFIG_XEN_DOM0_PCI=y
>     > CONFIG_XEN_PCI_PASSTHROUGH=y
>     > CONFIG_PARAVIRT=y
>     > CONFIG_PARAVIRT_CLOCK=y
>     > CONFIG_MEMTEST=y
>     > CONFIG_MCORE2=y
>     > CONFIG_X86_CPU=y
>     > CONFIG_X86_L1_CACHE_BYTES=64
>     > CONFIG_X86_INTERNODE_CACHE_BYTES=64
>     > CONFIG_X86_CMPXCHG=y
>     > CONFIG_X86_L1_CACHE_SHIFT=6
>     > CONFIG_X86_XADD=y
>     > CONFIG_X86_WP_WORKS_OK=y
>     > CONFIG_X86_INTEL_USERCOPY=y
>     > CONFIG_X86_USE_PPRO_CHECKSUM=y
>     > CONFIG_X86_P6_NOP=y
>     > CONFIG_X86_TSC=y
>     > CONFIG_X86_CMPXCHG64=y
>     > CONFIG_X86_CMOV=y
>     > CONFIG_X86_MINIMUM_CPU_FAMILY=64
>     > CONFIG_X86_DEBUGCTLMSR=y
>     > CONFIG_CPU_SUP_INTEL=y
>     > CONFIG_CPU_SUP_AMD=y
>     > CONFIG_CPU_SUP_CENTAUR=y
>     > CONFIG_HPET_TIMER=y
>     > CONFIG_HPET_EMULATE_RTC=y
>     > CONFIG_DMI=y
>     > CONFIG_GART_IOMMU=y
>     > CONFIG_SWIOTLB=y
>     > CONFIG_IOMMU_HELPER=y
>     > CONFIG_NR_CPUS=16
>     > CONFIG_SCHED_MC=y
>     > CONFIG_PREEMPT_NONE=y
>     > CONFIG_X86_LOCAL_APIC=y
>     > CONFIG_X86_IO_APIC=y
>     > CONFIG_X86_MCE=y
>     > CONFIG_X86_MCE_INTEL=y
>     > CONFIG_X86_MCE_THRESHOLD=y
>     > CONFIG_X86_THERMAL_VECTOR=y
>     > CONFIG_MICROCODE=y
>     > CONFIG_MICROCODE_INTEL=y
>     > CONFIG_MICROCODE_OLD_INTERFACE=y
>     > CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
>     > CONFIG_DIRECT_GBPAGES=y
>     > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
>     > CONFIG_ARCH_SPARSEMEM_ENABLE=y
>     > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
>     > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
>     > CONFIG_SELECT_MEMORY_MODEL=y
>     > CONFIG_SPARSEMEM_MANUAL=y
>     > CONFIG_SPARSEMEM=y
>     > CONFIG_HAVE_MEMORY_PRESENT=y
>     > CONFIG_SPARSEMEM_EXTREME=y
>     > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>     > CONFIG_SPARSEMEM_VMEMMAP=y
>     > CONFIG_PAGEFLAGS_EXTENDED=y
>     > CONFIG_SPLIT_PTLOCK_CPUS=4
>     > CONFIG_PHYS_ADDR_T_64BIT=y
>     > CONFIG_ZONE_DMA_FLAG=1
>     > CONFIG_BOUNCE=y
>     > CONFIG_VIRT_TO_BUS=y
>     > CONFIG_HAVE_MLOCK=y
>     > CONFIG_HAVE_MLOCKED_PAGE_BIT=y
>     > CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
>     > CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
>     > CONFIG_X86_RESERVE_LOW_64K=y
>     > CONFIG_MTRR=y
>     > CONFIG_MTRR_SANITIZER=y
>     > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
>     > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>     > CONFIG_X86_PAT=y
>     > CONFIG_ARCH_USES_PG_UNCACHED=y
>     > CONFIG_SECCOMP=y
>     > CONFIG_CC_STACKPROTECTOR=y
>     > CONFIG_HZ_100=y
>     > CONFIG_HZ=100
>     > CONFIG_PHYSICAL_START=0x1000000
>     > CONFIG_PHYSICAL_ALIGN=0x1000000
>     > CONFIG_HOTPLUG_CPU=y
>     > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>     > CONFIG_PM=y
>     > CONFIG_PM_DEBUG=y
>     > CONFIG_PM_VERBOSE=y
>     > CONFIG_PM_SLEEP_SMP=y
>     > CONFIG_PM_SLEEP=y
>     > CONFIG_ACPI=y
>     > CONFIG_ACPI_SYSFS_POWER=y
>     > CONFIG_ACPI_BUTTON=y
>     > CONFIG_ACPI_FAN=y
>     > CONFIG_ACPI_DOCK=y
>     > CONFIG_ACPI_PROCESSOR=y
>     > CONFIG_ACPI_HOTPLUG_CPU=y
>     > CONFIG_ACPI_THERMAL=y
>     > CONFIG_ACPI_BLACKLIST_YEAR=0
>     > CONFIG_ACPI_DEBUG=y
>     > CONFIG_X86_PM_TIMER=y
>     > CONFIG_ACPI_CONTAINER=y
>     > CONFIG_CPU_IDLE=y
>     > CONFIG_CPU_IDLE_GOV_LADDER=y
>     > CONFIG_PCI=y
>     > CONFIG_PCI_DIRECT=y
>     > CONFIG_PCI_MMCONFIG=y
>     > CONFIG_PCI_XEN=y
>     > CONFIG_PCI_DOMAINS=y
>     > CONFIG_PCIEPORTBUS=y
>     > CONFIG_PCIEAER=y
>     > CONFIG_ARCH_SUPPORTS_MSI=y
>     > CONFIG_XEN_PCIDEV_FRONTEND=y
>     > CONFIG_HT_IRQ=y
>     > CONFIG_ISA_DMA_API=y
>     > CONFIG_K8_NB=y
>     > CONFIG_BINFMT_ELF=y
>     > CONFIG_COMPAT_BINFMT_ELF=y
>     > CONFIG_IA32_EMULATION=y
>     > CONFIG_COMPAT=y
>     > CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
>     > CONFIG_SYSVIPC_COMPAT=y
>     > CONFIG_NET=y
>     > CONFIG_PACKET=y
>     > CONFIG_UNIX=y
>     > CONFIG_INET=y
>     > CONFIG_IP_FIB_HASH=y
>     > CONFIG_IP_PNP=y
>     > CONFIG_IP_PNP_DHCP=y
>     > CONFIG_NET_IPIP=y
>     > CONFIG_INET_TUNNEL=y
>     > CONFIG_INET_LRO=y
>     > CONFIG_TCP_CONG_CUBIC=y
>     > CONFIG_DEFAULT_TCP_CONG="cubic"
>     > CONFIG_NETFILTER=y
>     > CONFIG_NETFILTER_ADVANCED=y
>     > CONFIG_BRIDGE_NETFILTER=y
>     > CONFIG_NETFILTER_XTABLES=y
>     > CONFIG_IP_NF_IPTABLES=y
>     > CONFIG_IP_NF_FILTER=y
>     > CONFIG_IP_NF_TARGET_LOG=y
>     > CONFIG_BRIDGE_NF_EBTABLES=y
>     > CONFIG_BRIDGE_EBT_BROUTE=m
>     > CONFIG_BRIDGE_EBT_T_FILTER=m
>     > CONFIG_BRIDGE_EBT_T_NAT=m
>     > CONFIG_BRIDGE_EBT_802_3=m
>     > CONFIG_BRIDGE_EBT_AMONG=m
>     > CONFIG_BRIDGE_EBT_ARP=m
>     > CONFIG_BRIDGE_EBT_IP=m
>     > CONFIG_BRIDGE_EBT_LIMIT=m
>     > CONFIG_BRIDGE_EBT_MARK=m
>     > CONFIG_BRIDGE_EBT_PKTTYPE=m
>     > CONFIG_BRIDGE_EBT_STP=m
>     > CONFIG_BRIDGE_EBT_VLAN=m
>     > CONFIG_BRIDGE_EBT_ARPREPLY=m
>     > CONFIG_BRIDGE_EBT_DNAT=m
>     > CONFIG_BRIDGE_EBT_MARK_T=m
>     > CONFIG_BRIDGE_EBT_REDIRECT=m
>     > CONFIG_BRIDGE_EBT_SNAT=m
>     > CONFIG_BRIDGE_EBT_LOG=m
>     > CONFIG_BRIDGE_EBT_NFLOG=m
>     > CONFIG_STP=y
>     > CONFIG_BRIDGE=y
>     > CONFIG_LLC=y
>     > CONFIG_UEVENT_HELPER_PATH=""
>     > CONFIG_STANDALONE=y
>     > CONFIG_PREVENT_FIRMWARE_BUILD=y
>     > CONFIG_FW_LOADER=y
>     > CONFIG_FIRMWARE_IN_KERNEL=y
>     > CONFIG_EXTRA_FIRMWARE=""
>     > CONFIG_SYS_HYPERVISOR=y
>     > CONFIG_PNP=y
>     > CONFIG_PNP_DEBUG_MESSAGES=y
>     > CONFIG_PNPACPI=y
>     > CONFIG_BLK_DEV=y
>     > CONFIG_BLK_DEV_LOOP=y
>     > CONFIG_BLK_DEV_RAM=y
>     > CONFIG_BLK_DEV_RAM_COUNT=16
>     > CONFIG_BLK_DEV_RAM_SIZE=8192
>     > CONFIG_XEN_BLKDEV_FRONTEND=y
>     > CONFIG_HAVE_IDE=y
>     > CONFIG_SCSI=y
>     > CONFIG_SCSI_DMA=y
>     > CONFIG_SCSI_PROC_FS=y
>     > CONFIG_BLK_DEV_SD=y
>     > CONFIG_BLK_DEV_SR=y
>     > CONFIG_BLK_DEV_SR_VENDOR=y
>     > CONFIG_CHR_DEV_SG=m
>     > CONFIG_SCSI_MULTI_LUN=y
>     > CONFIG_SCSI_CONSTANTS=y
>     > CONFIG_SCSI_WAIT_SCAN=m
>     > CONFIG_SCSI_LOWLEVEL=y
>     > CONFIG_MEGARAID_SAS=y
>     > CONFIG_ATA=y
>     > CONFIG_ATA_VERBOSE_ERROR=y
>     > CONFIG_ATA_ACPI=y
>     > CONFIG_SATA_AHCI=y
>     > CONFIG_MD=y
>     > CONFIG_BLK_DEV_MD=y
>     > CONFIG_MD_AUTODETECT=y
>     > CONFIG_MD_RAID1=y
>     > CONFIG_MD_RAID456=y
>     > CONFIG_MD_RAID6_PQ=y
>     > CONFIG_BLK_DEV_DM=y
>     > CONFIG_DM_DEBUG=y
>     > CONFIG_NETDEVICES=y
>     > CONFIG_TUN=y
>     > CONFIG_NETDEV_1000=y
>     > CONFIG_E1000E=y
>     > CONFIG_XEN_NETDEV_FRONTEND=y
>     > CONFIG_INPUT=y
>     > CONFIG_INPUT_MOUSEDEV=y
>     > CONFIG_INPUT_MOUSEDEV_PSAUX=y
>     > CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
>     > CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>     > CONFIG_INPUT_EVDEV=y
>     > CONFIG_XEN_KBDDEV_FRONTEND=y
>     > CONFIG_INPUT_KEYBOARD=y
>     > CONFIG_KEYBOARD_ATKBD=y
>     > CONFIG_INPUT_MOUSE=y
>     > CONFIG_MOUSE_PS2=y
>     > CONFIG_MOUSE_PS2_ALPS=y
>     > CONFIG_MOUSE_PS2_LOGIPS2PP=y
>     > CONFIG_MOUSE_PS2_SYNAPTICS=y
>     > CONFIG_MOUSE_PS2_LIFEBOOK=y
>     > CONFIG_MOUSE_PS2_TRACKPOINT=y
>     > CONFIG_SERIO=y
>     > CONFIG_SERIO_I8042=y
>     > CONFIG_SERIO_LIBPS2=y
>     > CONFIG_VT=y
>     > CONFIG_CONSOLE_TRANSLATIONS=y
>     > CONFIG_VT_CONSOLE=y
>     > CONFIG_HW_CONSOLE=y
>     > CONFIG_DEVKMEM=y
>     > CONFIG_SERIAL_8250=y
>     > CONFIG_SERIAL_8250_CONSOLE=y
>     > CONFIG_FIX_EARLYCON_MEM=y
>     > CONFIG_SERIAL_8250_PCI=y
>     > CONFIG_SERIAL_8250_PNP=y
>     > CONFIG_SERIAL_8250_NR_UARTS=4
>     > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
>     > CONFIG_SERIAL_CORE=y
>     > CONFIG_SERIAL_CORE_CONSOLE=y
>     > CONFIG_UNIX98_PTYS=y
>     > CONFIG_HVC_DRIVER=y
>     > CONFIG_HVC_IRQ=y
>     > CONFIG_HVC_XEN=y
>     > CONFIG_IPMI_HANDLER=m
>     > CONFIG_IPMI_DEVICE_INTERFACE=m
>     > CONFIG_IPMI_SI=m
>     > CONFIG_IPMI_WATCHDOG=m
>     > CONFIG_IPMI_POWEROFF=m
>     > CONFIG_HW_RANDOM=y
>     > CONFIG_HW_RANDOM_INTEL=y
>     > CONFIG_DEVPORT=y
>     > CONFIG_I2C=m
>     > CONFIG_I2C_BOARDINFO=y
>     > CONFIG_I2C_HELPER_AUTO=y
>     > CONFIG_I2C_I801=m
>     > CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
>     > CONFIG_POWER_SUPPLY=y
>     > CONFIG_HWMON=m
>     > CONFIG_HWMON_VID=m
>     > CONFIG_SENSORS_W83627EHF=m
>     > CONFIG_THERMAL=y
>     > CONFIG_SSB_POSSIBLE=y
>     > CONFIG_VGA_ARB=y
>     > CONFIG_VIDEO_OUTPUT_CONTROL=m
>     > CONFIG_FB=y
>     > CONFIG_FIRMWARE_EDID=y
>     > CONFIG_FB_SYS_FILLRECT=y
>     > CONFIG_FB_SYS_COPYAREA=y
>     > CONFIG_FB_SYS_IMAGEBLIT=y
>     > CONFIG_FB_SYS_FOPS=y
>     > CONFIG_FB_DEFERRED_IO=y
>     > CONFIG_FB_TILEBLITTING=y
>     > CONFIG_XEN_FBDEV_FRONTEND=y
>     > CONFIG_VGA_CONSOLE=y
>     > CONFIG_DUMMY_CONSOLE=y
>     > CONFIG_LOGO=y
>     > CONFIG_LOGO_LINUX_CLUT224=y
>     > CONFIG_HID_SUPPORT=y
>     > CONFIG_HID=y
>     > CONFIG_HIDRAW=y
>     > CONFIG_USB_HID=m
>     > CONFIG_USB_HIDDEV=y
>     > CONFIG_HID_A4TECH=m
>     > CONFIG_HID_APPLE=m
>     > CONFIG_HID_BELKIN=m
>     > CONFIG_HID_CHERRY=m
>     > CONFIG_HID_CHICONY=m
>     > CONFIG_HID_CYPRESS=m
>     > CONFIG_HID_DRAGONRISE=m
>     > CONFIG_HID_EZKEY=m
>     > CONFIG_HID_KYE=m
>     > CONFIG_HID_GYRATION=m
>     > CONFIG_HID_TWINHAN=m
>     > CONFIG_HID_KENSINGTON=m
>     > CONFIG_HID_LOGITECH=m
>     > CONFIG_HID_MICROSOFT=m
>     > CONFIG_HID_MONTEREY=m
>     > CONFIG_HID_NTRIG=m
>     > CONFIG_HID_PANTHERLORD=m
>     > CONFIG_HID_PETALYNX=m
>     > CONFIG_HID_SAMSUNG=m
>     > CONFIG_HID_SONY=m
>     > CONFIG_HID_SUNPLUS=m
>     > CONFIG_HID_GREENASIA=m
>     > CONFIG_HID_SMARTJOYPLUS=m
>     > CONFIG_HID_TOPSEED=m
>     > CONFIG_HID_THRUSTMASTER=m
>     > CONFIG_HID_ZEROPLUS=m
>     > CONFIG_USB_SUPPORT=y
>     > CONFIG_USB_ARCH_HAS_HCD=y
>     > CONFIG_USB_ARCH_HAS_OHCI=y
>     > CONFIG_USB_ARCH_HAS_EHCI=y
>     > CONFIG_USB=m
>     > CONFIG_USB_EHCI_HCD=m
>     > CONFIG_USB_EHCI_ROOT_HUB_TT=y
>     > CONFIG_USB_UHCI_HCD=m
>     > CONFIG_USB_STORAGE=m
>     > CONFIG_NEW_LEDS=y
>     > CONFIG_LEDS_CLASS=m
>     > CONFIG_LEDS_TRIGGERS=y
>     > CONFIG_LEDS_TRIGGER_TIMER=m
>     > CONFIG_LEDS_TRIGGER_HEARTBEAT=m
>     > CONFIG_LEDS_TRIGGER_BACKLIGHT=m
>     > CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
>     > CONFIG_RTC_LIB=m
>     > CONFIG_RTC_CLASS=m
>     > CONFIG_RTC_INTF_SYSFS=y
>     > CONFIG_RTC_INTF_PROC=y
>     > CONFIG_RTC_INTF_DEV=y
>     > CONFIG_RTC_DRV_CMOS=m
>     > CONFIG_DMADEVICES=y
>     > CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
>     > CONFIG_INTEL_IOATDMA=m
>     > CONFIG_DMA_ENGINE=y
>     > CONFIG_NET_DMA=y
>     > CONFIG_DCA=m
>     > CONFIG_XEN_BALLOON=y
>     > CONFIG_XEN_SCRUB_PAGES=y
>     > CONFIG_XEN_DEV_EVTCHN=y
>     > CONFIG_XEN_BACKEND=y
>     > CONFIG_XEN_NETDEV_BACKEND=y
>     > CONFIG_XEN_BLKDEV_BACKEND=y
>     > CONFIG_XEN_BLKDEV_TAP=y
>     > CONFIG_XEN_BLKBACK_PAGEMAP=y
>     > CONFIG_XEN_PCIDEV_BACKEND=y
>     > CONFIG_XEN_PCIDEV_BACKEND_VPCI=y
>     > CONFIG_XENFS=y
>     > CONFIG_XEN_COMPAT_XENFS=y
>     > CONFIG_XEN_SYS_HYPERVISOR=y
>     > CONFIG_XEN_MCE=y
>     > CONFIG_XEN_XENBUS_FRONTEND=y
>     > CONFIG_XEN_S3=y
>     > CONFIG_XEN_PLATFORM_PCI=y
>     > CONFIG_FIRMWARE_MEMMAP=y
>     > CONFIG_DMIID=y
>     > CONFIG_EXT2_FS=y
>     > CONFIG_EXT3_FS=y
>     > CONFIG_EXT4_FS=y
>     > CONFIG_JBD=y
>     > CONFIG_JBD2=y
>     > CONFIG_FS_POSIX_ACL=y
>     > CONFIG_XFS_FS=y
>     > CONFIG_FILE_LOCKING=y
>     > CONFIG_FSNOTIFY=y
>     > CONFIG_DNOTIFY=y
>     > CONFIG_INOTIFY=y
>     > CONFIG_INOTIFY_USER=y
>     > CONFIG_FUSE_FS=m
>     > CONFIG_GENERIC_ACL=y
>     > CONFIG_ISO9660_FS=y
>     > CONFIG_JOLIET=y
>     > CONFIG_ZISOFS=y
>     > CONFIG_UDF_FS=y
>     > CONFIG_UDF_NLS=y
>     > CONFIG_FAT_FS=m
>     > CONFIG_VFAT_FS=m
>     > CONFIG_FAT_DEFAULT_CODEPAGE=437
>     > CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
>     > CONFIG_PROC_FS=y
>     > CONFIG_PROC_SYSCTL=y
>     > CONFIG_PROC_PAGE_MONITOR=y
>     > CONFIG_SYSFS=y
>     > CONFIG_TMPFS=y
>     > CONFIG_TMPFS_POSIX_ACL=y
>     > CONFIG_CONFIGFS_FS=m
>     > CONFIG_MISC_FILESYSTEMS=y
>     > CONFIG_SQUASHFS=y
>     > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
>     > CONFIG_NETWORK_FILESYSTEMS=y
>     > CONFIG_NFS_FS=m
>     > CONFIG_NFS_V3=y
>     > CONFIG_NFSD=m
>     > CONFIG_NFSD_V3=y
>     > CONFIG_LOCKD=m
>     > CONFIG_LOCKD_V4=y
>     > CONFIG_EXPORTFS=y
>     > CONFIG_NFS_COMMON=y
>     > CONFIG_SUNRPC=m
>     > CONFIG_PARTITION_ADVANCED=y
>     > CONFIG_MSDOS_PARTITION=y
>     > CONFIG_EFI_PARTITION=y
>     > CONFIG_NLS=y
>     > CONFIG_NLS_DEFAULT="iso8859-1"
>     > CONFIG_NLS_CODEPAGE_437=m
>     > CONFIG_NLS_ASCII=m
>     > CONFIG_NLS_ISO8859_1=y
>     > CONFIG_NLS_UTF8=m
>     > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>     > CONFIG_ENABLE_WARN_DEPRECATED=y
>     > CONFIG_ENABLE_MUST_CHECK=y
>     > CONFIG_FRAME_WARN=2048
>     > CONFIG_MAGIC_SYSRQ=y
>     > CONFIG_DEBUG_BUGVERBOSE=y
>     > CONFIG_DEBUG_MEMORY_INIT=y
>     > CONFIG_ARCH_WANT_FRAME_POINTERS=y
>     > CONFIG_RCU_CPU_STALL_DETECTOR=y
>     > CONFIG_USER_STACKTRACE_SUPPORT=y
>     > CONFIG_HAVE_FUNCTION_TRACER=y
>     > CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>     > CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>     > CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>     > CONFIG_HAVE_DYNAMIC_FTRACE=y
>     > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>     > CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
>     > CONFIG_TRACING_SUPPORT=y
>     > CONFIG_HAVE_ARCH_KGDB=y
>     > CONFIG_HAVE_ARCH_KMEMCHECK=y
>     > CONFIG_X86_VERBOSE_BOOTUP=y
>     > CONFIG_EARLY_PRINTK=y
>     > CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>     > CONFIG_IO_DELAY_TYPE_0X80=0
>     > CONFIG_IO_DELAY_TYPE_0XED=1
>     > CONFIG_IO_DELAY_TYPE_UDELAY=2
>     > CONFIG_IO_DELAY_TYPE_NONE=3
>     > CONFIG_IO_DELAY_0X80=y
>     > CONFIG_DEFAULT_IO_DELAY_TYPE=0
>     > CONFIG_XOR_BLOCKS=y
>     > CONFIG_ASYNC_CORE=y
>     > CONFIG_ASYNC_MEMCPY=y
>     > CONFIG_ASYNC_XOR=y
>     > CONFIG_ASYNC_PQ=y
>     > CONFIG_ASYNC_RAID6_RECOV=y
>     > CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
>     > CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
>     > CONFIG_CRYPTO=y
>     > CONFIG_CRYPTO_ALGAPI=y
>     > CONFIG_CRYPTO_ALGAPI2=y
>     > CONFIG_CRYPTO_HASH=y
>     > CONFIG_CRYPTO_HASH2=y
>     > CONFIG_CRYPTO_CRC32C_INTEL=y
>     > CONFIG_HAVE_KVM=y
>     > CONFIG_BITREVERSE=y
>     > CONFIG_GENERIC_FIND_FIRST_BIT=y
>     > CONFIG_GENERIC_FIND_NEXT_BIT=y
>     > CONFIG_GENERIC_FIND_LAST_BIT=y
>     > CONFIG_CRC16=y
>     > CONFIG_CRC_ITU_T=y
>     > CONFIG_CRC32=y
>     > CONFIG_ZLIB_INFLATE=y
>     > CONFIG_HAS_IOMEM=y
>     > CONFIG_HAS_IOPORT=y
>     > CONFIG_HAS_DMA=y
>     > CONFIG_NLATTR=y
>     >
>     > DomU config:
>     > CONFIG_64BIT=y
>     > CONFIG_X86_64=y
>     > CONFIG_X86=y
>     > CONFIG_OUTPUT_FORMAT="elf64-x86-64"
>     > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
>     > CONFIG_GENERIC_TIME=y
>     > CONFIG_GENERIC_CMOS_UPDATE=y
>     > CONFIG_CLOCKSOURCE_WATCHDOG=y
>     > CONFIG_GENERIC_CLOCKEVENTS=y
>     > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>     > CONFIG_LOCKDEP_SUPPORT=y
>     > CONFIG_STACKTRACE_SUPPORT=y
>     > CONFIG_HAVE_LATENCYTOP_SUPPORT=y
>     > CONFIG_MMU=y
>     > CONFIG_ZONE_DMA=y
>     > CONFIG_GENERIC_ISA_DMA=y
>     > CONFIG_GENERIC_IOMAP=y
>     > CONFIG_GENERIC_BUG=y
>     > CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
>     > CONFIG_GENERIC_HWEIGHT=y
>     > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
>     > CONFIG_RWSEM_XCHGADD_ALGORITHM=y
>     > CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
>     > CONFIG_GENERIC_CALIBRATE_DELAY=y
>     > CONFIG_GENERIC_TIME_VSYSCALL=y
>     > CONFIG_ARCH_HAS_CPU_RELAX=y
>     > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
>     > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
>     > CONFIG_HAVE_SETUP_PER_CPU_AREA=y
>     > CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
>     > CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
>     > CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
>     > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
>     > CONFIG_ARCH_SUSPEND_POSSIBLE=y
>     > CONFIG_ZONE_DMA32=y
>     > CONFIG_ARCH_POPULATES_NODE_MAP=y
>     > CONFIG_AUDIT_ARCH=y
>     > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
>     > CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
>     > CONFIG_GENERIC_HARDIRQS=y
>     > CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
>     > CONFIG_GENERIC_IRQ_PROBE=y
>     > CONFIG_GENERIC_PENDING_IRQ=y
>     > CONFIG_USE_GENERIC_SMP_HELPERS=y
>     > CONFIG_X86_64_SMP=y
>     > CONFIG_X86_HT=y
>     > CONFIG_X86_TRAMPOLINE=y
>     > CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>     > CONFIG_CONSTRUCTORS=y
>     > CONFIG_LOCK_KERNEL=y
>     > CONFIG_INIT_ENV_ARG_LIMIT=32
>     > CONFIG_LOCALVERSION="-xenU"
>     > CONFIG_HAVE_KERNEL_GZIP=y
>     > CONFIG_HAVE_KERNEL_BZIP2=y
>     > CONFIG_HAVE_KERNEL_LZMA=y
>     > CONFIG_KERNEL_BZIP2=y
>     > CONFIG_SWAP=y
>     > CONFIG_SYSVIPC=y
>     > CONFIG_SYSVIPC_SYSCTL=y
>     > CONFIG_TREE_RCU=y
>     > CONFIG_RCU_FANOUT=64
>     > CONFIG_IKCONFIG=y
>     > CONFIG_IKCONFIG_PROC=y
>     > CONFIG_LOG_BUF_SHIFT=14
>     > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>     > CONFIG_NAMESPACES=y
>     > CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>     > CONFIG_SYSCTL=y
>     > CONFIG_ANON_INODES=y
>     > CONFIG_UID16=y
>     > CONFIG_SYSCTL_SYSCALL=y
>     > CONFIG_KALLSYMS=y
>     > CONFIG_HOTPLUG=y
>     > CONFIG_PRINTK=y
>     > CONFIG_BUG=y
>     > CONFIG_ELF_CORE=y
>     > CONFIG_PCSPKR_PLATFORM=y
>     > CONFIG_BASE_FULL=y
>     > CONFIG_FUTEX=y
>     > CONFIG_EPOLL=y
>     > CONFIG_SIGNALFD=y
>     > CONFIG_TIMERFD=y
>     > CONFIG_EVENTFD=y
>     > CONFIG_SHMEM=y
>     > CONFIG_AIO=y
>     > CONFIG_HAVE_PERF_EVENTS=y
>     > CONFIG_VM_EVENT_COUNTERS=y
>     > CONFIG_SLAB=y
>     > CONFIG_HAVE_OPROFILE=y
>     > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
>     > CONFIG_HAVE_IOREMAP_PROT=y
>     > CONFIG_HAVE_KPROBES=y
>     > CONFIG_HAVE_KRETPROBES=y
>     > CONFIG_HAVE_ARCH_TRACEHOOK=y
>     > CONFIG_HAVE_DMA_ATTRS=y
>     > CONFIG_HAVE_DMA_API_DEBUG=y
>     > CONFIG_SLABINFO=y
>     > CONFIG_RT_MUTEXES=y
>     > CONFIG_BASE_SMALL=0
>     > CONFIG_BLOCK=y
>     > CONFIG_BLK_DEV_BSG=y
>     > CONFIG_BLOCK_COMPAT=y
>     > CONFIG_IOSCHED_NOOP=y
>     > CONFIG_IOSCHED_AS=y
>     > CONFIG_IOSCHED_DEADLINE=y
>     > CONFIG_DEFAULT_DEADLINE=y
>     > CONFIG_DEFAULT_IOSCHED="deadline"
>     > CONFIG_TICK_ONESHOT=y
>     > CONFIG_NO_HZ=y
>     > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>     > CONFIG_SMP=y
>     > CONFIG_X86_MPPARSE=y
>     > CONFIG_SCHED_OMIT_FRAME_POINTER=y
>     > CONFIG_PARAVIRT_GUEST=y
>     > CONFIG_XEN=y
>     > CONFIG_XEN_MAX_DOMAIN_MEMORY=32
>     > CONFIG_PARAVIRT=y
>     > CONFIG_PARAVIRT_CLOCK=y
>     > CONFIG_MCORE2=y
>     > CONFIG_X86_CPU=y
>     > CONFIG_X86_L1_CACHE_BYTES=64
>     > CONFIG_X86_INTERNODE_CACHE_BYTES=64
>     > CONFIG_X86_CMPXCHG=y
>     > CONFIG_X86_L1_CACHE_SHIFT=6
>     > CONFIG_X86_XADD=y
>     > CONFIG_X86_WP_WORKS_OK=y
>     > CONFIG_X86_INTEL_USERCOPY=y
>     > CONFIG_X86_USE_PPRO_CHECKSUM=y
>     > CONFIG_X86_P6_NOP=y
>     > CONFIG_X86_TSC=y
>     > CONFIG_X86_CMPXCHG64=y
>     > CONFIG_X86_CMOV=y
>     > CONFIG_X86_MINIMUM_CPU_FAMILY=64
>     > CONFIG_X86_DEBUGCTLMSR=y
>     > CONFIG_CPU_SUP_INTEL=y
>     > CONFIG_CPU_SUP_AMD=y
>     > CONFIG_CPU_SUP_CENTAUR=y
>     > CONFIG_HPET_TIMER=y
>     > CONFIG_DMI=y
>     > CONFIG_SWIOTLB=y
>     > CONFIG_IOMMU_HELPER=y
>     > CONFIG_NR_CPUS=16
>     > CONFIG_PREEMPT_NONE=y
>     > CONFIG_X86_LOCAL_APIC=y
>     > CONFIG_X86_IO_APIC=y
>     > CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
>     > CONFIG_DIRECT_GBPAGES=y
>     > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
>     > CONFIG_ARCH_SPARSEMEM_ENABLE=y
>     > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
>     > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
>     > CONFIG_SELECT_MEMORY_MODEL=y
>     > CONFIG_SPARSEMEM_MANUAL=y
>     > CONFIG_SPARSEMEM=y
>     > CONFIG_HAVE_MEMORY_PRESENT=y
>     > CONFIG_SPARSEMEM_EXTREME=y
>     > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>     > CONFIG_SPARSEMEM_VMEMMAP=y
>     > CONFIG_PAGEFLAGS_EXTENDED=y
>     > CONFIG_SPLIT_PTLOCK_CPUS=4
>     > CONFIG_PHYS_ADDR_T_64BIT=y
>     > CONFIG_ZONE_DMA_FLAG=1
>     > CONFIG_BOUNCE=y
>     > CONFIG_VIRT_TO_BUS=y
>     > CONFIG_HAVE_MLOCK=y
>     > CONFIG_HAVE_MLOCKED_PAGE_BIT=y
>     > CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
>     > CONFIG_SECCOMP=y
>     > CONFIG_CC_STACKPROTECTOR=y
>     > CONFIG_HZ_100=y
>     > CONFIG_HZ=100
>     > CONFIG_PHYSICAL_START=0x1000000
>     > CONFIG_PHYSICAL_ALIGN=0x1000000
>     > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>     > CONFIG_ISA_DMA_API=y
>     > CONFIG_BINFMT_ELF=y
>     > CONFIG_COMPAT_BINFMT_ELF=y
>     > CONFIG_IA32_EMULATION=y
>     > CONFIG_COMPAT=y
>     > CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
>     > CONFIG_SYSVIPC_COMPAT=y
>     > CONFIG_NET=y
>     > CONFIG_PACKET=y
>     > CONFIG_UNIX=y
>     > CONFIG_INET=y
>     > CONFIG_IP_FIB_HASH=y
>     > CONFIG_NET_IPIP=y
>     > CONFIG_INET_TUNNEL=y
>     > CONFIG_INET_LRO=y
>     > CONFIG_TCP_CONG_CUBIC=y
>     > CONFIG_DEFAULT_TCP_CONG="cubic"
>     > CONFIG_NETFILTER=y
>     > CONFIG_NETFILTER_ADVANCED=y
>     > CONFIG_NETFILTER_XTABLES=y
>     > CONFIG_IP_NF_IPTABLES=y
>     > CONFIG_IP_NF_FILTER=y
>     > CONFIG_IP_NF_TARGET_LOG=y
>     > CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>     > CONFIG_STANDALONE=y
>     > CONFIG_PREVENT_FIRMWARE_BUILD=y
>     > CONFIG_FW_LOADER=y
>     > CONFIG_FIRMWARE_IN_KERNEL=y
>     > CONFIG_EXTRA_FIRMWARE=""
>     > CONFIG_SYS_HYPERVISOR=y
>     > CONFIG_BLK_DEV=y
>     > CONFIG_XEN_BLKDEV_FRONTEND=y
>     > CONFIG_HAVE_IDE=y
>     > CONFIG_NETDEVICES=y
>     > CONFIG_TUN=y
>     > CONFIG_XEN_NETDEV_FRONTEND=y
>     > CONFIG_INPUT=y
>     > CONFIG_INPUT_MOUSEDEV=y
>     > CONFIG_INPUT_MOUSEDEV_PSAUX=y
>     > CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
>     > CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>     > CONFIG_INPUT_EVDEV=y
>     > CONFIG_INPUT_KEYBOARD=y
>     > CONFIG_KEYBOARD_ATKBD=y
>     > CONFIG_SERIO=y
>     > CONFIG_SERIO_I8042=y
>     > CONFIG_SERIO_LIBPS2=y
>     > CONFIG_VT=y
>     > CONFIG_CONSOLE_TRANSLATIONS=y
>     > CONFIG_VT_CONSOLE=y
>     > CONFIG_HW_CONSOLE=y
>     > CONFIG_DEVKMEM=y
>     > CONFIG_SERIAL_8250=y
>     > CONFIG_SERIAL_8250_CONSOLE=y
>     > CONFIG_FIX_EARLYCON_MEM=y
>     > CONFIG_SERIAL_8250_NR_UARTS=4
>     > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
>     > CONFIG_SERIAL_8250_EXTENDED=y
>     > CONFIG_SERIAL_8250_MANY_PORTS=y
>     > CONFIG_SERIAL_8250_SHARE_IRQ=y
>     > CONFIG_SERIAL_8250_RSA=y
>     > CONFIG_SERIAL_CORE=y
>     > CONFIG_SERIAL_CORE_CONSOLE=y
>     > CONFIG_UNIX98_PTYS=y
>     > CONFIG_HVC_DRIVER=y
>     > CONFIG_HVC_IRQ=y
>     > CONFIG_HVC_XEN=y
>     > CONFIG_HW_RANDOM=y
>     > CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
>     > CONFIG_SSB_POSSIBLE=y
>     > CONFIG_VGA_CONSOLE=y
>     > CONFIG_DUMMY_CONSOLE=y
>     > CONFIG_XEN_DEV_EVTCHN=y
>     > CONFIG_XENFS=y
>     > CONFIG_XEN_COMPAT_XENFS=y
>     > CONFIG_XEN_SYS_HYPERVISOR=y
>     > CONFIG_FIRMWARE_MEMMAP=y
>     > CONFIG_EXT3_FS=y
>     > CONFIG_JBD=y
>     > CONFIG_FS_POSIX_ACL=y
>     > CONFIG_FILE_LOCKING=y
>     > CONFIG_FSNOTIFY=y
>     > CONFIG_DNOTIFY=y
>     > CONFIG_INOTIFY=y
>     > CONFIG_INOTIFY_USER=y
>     > CONFIG_PROC_FS=y
>     > CONFIG_PROC_SYSCTL=y
>     > CONFIG_PROC_PAGE_MONITOR=y
>     > CONFIG_SYSFS=y
>     > CONFIG_TMPFS=y
>     > CONFIG_MISC_FILESYSTEMS=y
>     > CONFIG_SQUASHFS=y
>     > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
>     > CONFIG_NETWORK_FILESYSTEMS=y
>     > CONFIG_NFS_FS=y
>     > CONFIG_NFS_V3=y
>     > CONFIG_NFS_V3_ACL=y
>     > CONFIG_NFSD=y
>     > CONFIG_NFSD_V3=y
>     > CONFIG_LOCKD=y
>     > CONFIG_LOCKD_V4=y
>     > CONFIG_EXPORTFS=y
>     > CONFIG_NFS_ACL_SUPPORT=y
>     > CONFIG_NFS_COMMON=y
>     > CONFIG_SUNRPC=y
>     > CONFIG_MSDOS_PARTITION=y
>     > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>     > CONFIG_ENABLE_WARN_DEPRECATED=y
>     > CONFIG_ENABLE_MUST_CHECK=y
>     > CONFIG_FRAME_WARN=2048
>     > CONFIG_MAGIC_SYSRQ=y
>     > CONFIG_DEBUG_BUGVERBOSE=y
>     > CONFIG_DEBUG_MEMORY_INIT=y
>     > CONFIG_ARCH_WANT_FRAME_POINTERS=y
>     > CONFIG_USER_STACKTRACE_SUPPORT=y
>     > CONFIG_HAVE_FUNCTION_TRACER=y
>     > CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>     > CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>     > CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>     > CONFIG_HAVE_DYNAMIC_FTRACE=y
>     > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>     > CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
>     > CONFIG_TRACING_SUPPORT=y
>     > CONFIG_HAVE_ARCH_KGDB=y
>     > CONFIG_HAVE_ARCH_KMEMCHECK=y
>     > CONFIG_EARLY_PRINTK=y
>     > CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>     > CONFIG_IO_DELAY_TYPE_0X80=0
>     > CONFIG_IO_DELAY_TYPE_0XED=1
>     > CONFIG_IO_DELAY_TYPE_UDELAY=2
>     > CONFIG_IO_DELAY_TYPE_NONE=3
>     > CONFIG_IO_DELAY_0X80=y
>     > CONFIG_DEFAULT_IO_DELAY_TYPE=0
>     > CONFIG_CRYPTO=y
>     > CONFIG_CRYPTO_ALGAPI=y
>     > CONFIG_CRYPTO_ALGAPI2=y
>     > CONFIG_CRYPTO_HASH=y
>     > CONFIG_CRYPTO_HASH2=y
>     > CONFIG_CRYPTO_CRC32C=y
>     > CONFIG_CRYPTO_CRC32C_INTEL=y
>     > CONFIG_HAVE_KVM=y
>     > CONFIG_BITREVERSE=y
>     > CONFIG_GENERIC_FIND_FIRST_BIT=y
>     > CONFIG_GENERIC_FIND_NEXT_BIT=y
>     > CONFIG_GENERIC_FIND_LAST_BIT=y
>     > CONFIG_CRC32=y
>     > CONFIG_ZLIB_INFLATE=y
>     > CONFIG_HAS_IOMEM=y
>     > CONFIG_HAS_IOPORT=y
>     > CONFIG_HAS_DMA=y
>     > CONFIG_NLATTR=y
>     >
>     > --
>     > Alan J. Wylie                                        
>      http://www.wylie.me.uk/
>     >
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at  http://www.tux.org/lkml/
>
>

