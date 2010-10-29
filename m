Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab0J2Lek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:34:40 -0400
Received: from smtp-out-012.synserver.de ([212.40.180.12]:1180 "HELO
	smtp-out-008.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932390Ab0J2Leh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:34:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 27029
Date: Fri, 29 Oct 2010 13:34:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101029113433.GB1553@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <20101029081831.GA7149@liondog.tnic>
 <20101029083013.GA1553@arch.trippelsdorf.de>
 <20101029102713.GA21125@aftab>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20101029102713.GA21125@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 29, 2010 at 12:27:13PM +0200, Borislav Petkov wrote:
> On Fri, Oct 29, 2010 at 04:30:13AM -0400, Markus Trippelsdorf wrote:
> > > Well, what do you know, the temporary "slowdown" triggered on my setup
> > > too. After waiting a minute maybe, the machine recovered and guess what
> > > appeared in dmesg:
> > > 
> > > [44729.650859] Clocksource tsc unstable (delta = -8615263009 ns)
> > > [44729.656229] Switching to clocksource hpet
> > > 
> > > I've reverted the changeset above and will run without it to check
> > > whether it makes any difference.
> > 
> > After further testing I've found out that the tsc- and the kvm-issue are
> > unrelated. IOW I get these "slowdowns" even with 34f971f6f7988be4
> > reverted.
> 
> hmm, I'll run with 34f971f6f798 reverted for a while just to confirm
> your observations...
> 
> > I guess John was right when he wrote:
> > > From your dmesg, I'd guess the hpet is the watchdog clocksource, so I
> > > be on the lookout for hpet related changes.
> > >
> > > Maybe does reverting 995bd3bb5c78f3ff71339803c0b8337ed36d64fb hide the
> > > issue?  
> > 
> > Because with 995bd3bb5c78f reverted I never had a single "slowdown" here.
> 
> That's strange, when we tested this one everything seemed fine so I
> guess this is one of those bugs which appear later, just as if out of
> nowhere.
> 
> Thomas, could it be that SMI fires in between the HPET write and
> subsequent read:
> 
> 	hpet_writel(cnt, HPET_Tn_CMP(timer));
> 
> 	...
> 
> 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
> 
> causing the -ETIME and thus a wait for HPET wraparound? My machine at
> least does SMI-initiated C1E so it could very well be the problem.
> 
> Markus, can you verify this on your system by compiling x86info from
> git://git.choralone.org/git/x86info and doing
> 
> ./lsmsr Int


x86info v1.28beta.  Dave Jones 2001-2010
Feedback to <davej@redhat.com>.

Found 4 CPUs
--------------------------------------------------------------------------
CPU #1
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
--------------------------------------------------------------------------
CPU #2
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
--------------------------------------------------------------------------
CPU #3
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
--------------------------------------------------------------------------
CPU #4
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
--------------------------------------------------------------------------
 running at an estimated 3.20GHz

x86info --all output is attached
-- 
Markus

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x86info_all

x86info v1.28beta.  Dave Jones 2001-2010
Feedback to <davej@redhat.com>.

Found 4 CPUs
MP Table:
#	APIC ID	Version	State		Family	Model	Step	Flags
#	 0	 0x10	 BSP, usable	 16	 4	 2	 0x178bfbff
#	 1	 0x10	 AP, usable	 16	 4	 2	 0x178bfbff
#	 2	 0x10	 AP, usable	 16	 4	 2	 0x178bfbff
#	 3	 0x10	 AP, usable	 16	 4	 2	 0x178bfbff

--------------------------------------------------------------------------
CPU #1
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Data cache data parity enabled
  Data cache main tag parity enabled
  Data cache snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
 Instruction cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Instruction cache data parity enabled
  IC main tag parity enabled
  IC snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
  Predecode array parity enabled
  Target selector parity enabled
  Read data error enabled
 Bus unit check enabled
  External L2 tag parity error enabled
  L2 partial tag parity error enabled
  System ECC TLB reload error enabled
  L2 ECC TLB reload error enabled
  L2 ECC K7 deallocate enabled
  L2 ECC probe deallocate enabled
  System datareaderror reporting enabled
 Load/Store unit check enabled
  Read data error enable (loads) enabled
  Read data error enable (stores) enabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   11111111 11111111 11111111 11111111
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    11111111 11111111 11111111 11111111
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   11111111 11111111 11111111 11111111
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00001111 11111111
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   11111111 11111111 11111111 11111111
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000011
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   11111111 11111111 11111111 11111111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00111111 11111111 11111111 11111111
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   11111111 11111111 11111111 11111111
MC4MISC:   11111111 11111111 11111111 11111111

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000001
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   11111111 11111111 11111111 11111111
MC5MISC:   00000000 00000000 00001111 11111111

Microcode patch level: 0x1000086

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Pstate-0: fid=10, did=0, vid=10 (3200MHz) (current)
Pstate-1: fid=9, did=0, vid=18 (2500MHz)
Pstate-2: fid=5, did=0, vid=20 (2100MHz)
Pstate-3: fid=0, did=1, vid=2e (800MHz)

Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 00040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001b76 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 35353920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (1G):           Fully associative. 48 entries.
L1 Instruction TLB (1G):    Disabled. 0 entries.
L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (1G):           8-way associative. 16 entries.
L2 Instruction TLB (1G):    Disabled. 0 entries.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 nx mmxext mmx fxsr ffxsr page1gb rdtscp lm 3dnowext 3dnow lahf/sahf CmpLegacy svm ExtApicSpace LockMovCr0 abm sse4a misalignsse 3dnowPref osvw ibs skinit wdt

Long NOPs supported: yes
Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x00000000c0000006
MTRRphysMask2 (0x205): 0x0000ffffe0000800
MTRRphysBase3 (0x206): 0x00000000f0000001
MTRRphysMask3 (0x207): 0x0000fffff8000800
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00


3.20GHz processor (estimate).

--------------------------------------------------------------------------
CPU #2
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Data cache data parity enabled
  Data cache main tag parity enabled
  Data cache snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
 Instruction cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Instruction cache data parity enabled
  IC main tag parity enabled
  IC snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
  Predecode array parity enabled
  Target selector parity enabled
  Read data error enabled
 Bus unit check enabled
  External L2 tag parity error enabled
  L2 partial tag parity error enabled
  System ECC TLB reload error enabled
  L2 ECC TLB reload error enabled
  L2 ECC K7 deallocate enabled
  L2 ECC probe deallocate enabled
  System datareaderror reporting enabled
 Load/Store unit check enabled
  Read data error enable (loads) enabled
  Read data error enable (stores) enabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   11111111 11111111 11111111 11111111
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    11111111 11111111 11111111 11111111
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   11111111 11111111 11111111 11111111
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00001111 11111111
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   11111111 11111111 11111111 11111111
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000011
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   11111111 11111111 11111111 11111111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   11111111 11111111 11111111 11111111

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000001
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   11111111 11111111 11111111 11111111
MC5MISC:   00000000 00000000 00001111 11111111

Microcode patch level: 0x1000086

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Pstate-0: fid=10, did=0, vid=10 (3200MHz)
Pstate-1: fid=9, did=0, vid=18 (2500MHz)
Pstate-2: fid=5, did=0, vid=20 (2100MHz)
Pstate-3: fid=0, did=1, vid=2e (800MHz) (current)

Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 01040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001b76 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 35353920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (1G):           Fully associative. 48 entries.
L1 Instruction TLB (1G):    Disabled. 0 entries.
L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (1G):           8-way associative. 16 entries.
L2 Instruction TLB (1G):    Disabled. 0 entries.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 nx mmxext mmx fxsr ffxsr page1gb rdtscp lm 3dnowext 3dnow lahf/sahf CmpLegacy svm ExtApicSpace LockMovCr0 abm sse4a misalignsse 3dnowPref osvw ibs skinit wdt

Long NOPs supported: yes
Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x00000000c0000006
MTRRphysMask2 (0x205): 0x0000ffffe0000800
MTRRphysBase3 (0x206): 0x00000000f0000001
MTRRphysMask3 (0x207): 0x0000fffff8000800
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00


3.20GHz processor (estimate).

--------------------------------------------------------------------------
CPU #3
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Data cache data parity enabled
  Data cache main tag parity enabled
  Data cache snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
 Instruction cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Instruction cache data parity enabled
  IC main tag parity enabled
  IC snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
  Predecode array parity enabled
  Target selector parity enabled
  Read data error enabled
 Bus unit check enabled
  External L2 tag parity error enabled
  L2 partial tag parity error enabled
  System ECC TLB reload error enabled
  L2 ECC TLB reload error enabled
  L2 ECC K7 deallocate enabled
  L2 ECC probe deallocate enabled
  System datareaderror reporting enabled
 Load/Store unit check enabled
  Read data error enable (loads) enabled
  Read data error enable (stores) enabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   11111111 11111111 11111111 11111111
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    11111111 11111111 11111111 11111111
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   11111111 11111111 11111111 11111111
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00001111 11111111
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   11111111 11111111 11111111 11111111
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000011
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   11111111 11111111 11111111 11111111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   11111111 11111111 11111111 11111111

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000001
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   00111111 11111111 11111111 11111111
MC5MISC:   00000000 00000000 00001111 11111111

Microcode patch level: 0x1000086

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Pstate-0: fid=10, did=0, vid=10 (3200MHz)
Pstate-1: fid=9, did=0, vid=18 (2500MHz)
Pstate-2: fid=5, did=0, vid=20 (2100MHz)
Pstate-3: fid=0, did=1, vid=2e (800MHz) (current)

Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 02040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001b76 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 35353920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (1G):           Fully associative. 48 entries.
L1 Instruction TLB (1G):    Disabled. 0 entries.
L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (1G):           8-way associative. 16 entries.
L2 Instruction TLB (1G):    Disabled. 0 entries.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 nx mmxext mmx fxsr ffxsr page1gb rdtscp lm 3dnowext 3dnow lahf/sahf CmpLegacy svm ExtApicSpace LockMovCr0 abm sse4a misalignsse 3dnowPref osvw ibs skinit wdt

Long NOPs supported: yes
Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x00000000c0000006
MTRRphysMask2 (0x205): 0x0000ffffe0000800
MTRRphysBase3 (0x206): 0x00000000f0000001
MTRRphysMask3 (0x207): 0x0000fffff8000800
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00


3.20GHz processor (estimate).

--------------------------------------------------------------------------
CPU #4
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron/Phenom II (RB-C2)
Processor name string: AMD Phenom(tm) II X4 955 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Data cache data parity enabled
  Data cache main tag parity enabled
  Data cache snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
 Instruction cache check enabled
  ECC 1 bit error reporting enabled
  ECC multi bit error reporting enabled
  Instruction cache data parity enabled
  IC main tag parity enabled
  IC snoop tag parity enabled
  L1 TLB parity enabled
  L2 TLB parity enabled
  Predecode array parity enabled
  Target selector parity enabled
  Read data error enabled
 Bus unit check enabled
  External L2 tag parity error enabled
  L2 partial tag parity error enabled
  System ECC TLB reload error enabled
  L2 ECC TLB reload error enabled
  L2 ECC K7 deallocate enabled
  L2 ECC probe deallocate enabled
  System datareaderror reporting enabled
 Load/Store unit check enabled
  Read data error enable (loads) enabled
  Read data error enable (stores) enabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   11111111 11111111 11111111 11111111
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    11111111 11111111 11111111 11111111
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   00000000 00000000 00000000 00000000
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00001111 11111111
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   11111111 11111111 11111111 11111111
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000011
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   11111111 11111111 11111111 11111111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   11111111 11111111 11111111 11111111

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000001
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   11111111 11111111 11111111 11111111
MC5MISC:   00000000 00000000 00001111 11111111

Microcode patch level: 0x1000086

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Pstate-0: fid=10, did=0, vid=10 (3200MHz)
Pstate-1: fid=9, did=0, vid=18 (2500MHz)
Pstate-2: fid=5, did=0, vid=20 (2100MHz)
Pstate-3: fid=0, did=1, vid=2e (800MHz) (current)

Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 03040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001b76 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 35353920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (1G):           Fully associative. 48 entries.
L1 Instruction TLB (1G):    Disabled. 0 entries.
L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (1G):           8-way associative. 16 entries.
L2 Instruction TLB (1G):    Disabled. 0 entries.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 nx mmxext mmx fxsr ffxsr page1gb rdtscp lm 3dnowext 3dnow lahf/sahf CmpLegacy svm ExtApicSpace LockMovCr0 abm sse4a misalignsse 3dnowPref osvw ibs skinit wdt

Long NOPs supported: yes
Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x00000000c0000006
MTRRphysMask2 (0x205): 0x0000ffffe0000800
MTRRphysBase3 (0x206): 0x00000000f0000001
MTRRphysMask3 (0x207): 0x0000fffff8000800
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00


3.20GHz processor (estimate).

--------------------------------------------------------------------------
 running at an estimated 3.20GHz

--wRRV7LY7NUeQGEoC--
