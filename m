Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1BYKwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:52:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39968 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932442Ab1BYKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:51:59 -0500
X-Authenticated: #66309254
X-Provags-ID: V01U2FsdGVkX18GQ60NG2UGs0VhBX37aap8pnU85RbhDxRaQMSXIq
	P1aicBrV2UFFpE
Date: Fri, 25 Feb 2011 11:55:52 +0100
From: Wolfgang Wegner <ww-ml@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: mmap()ed PCI write performance question/problem
Message-ID: <20110225105552.GB3666@debian-wegner1.datadisplay.de>
Reply-To: ww-ml@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am having some problems getting decent write performance from an mmap()ed
PCI device. The device in question is an FPGA core connected to an ARM
Kirkwood CPU via 88SB2211 PCIe->PCI bridge, but to get an idea about what
is going on I also tested some plain old graphics cards in an x86 PC which
also showed "strange" (i.e. I have no explanation yet) behaviour.

My tests:
load a simple, i.e. unaccelerated, frame buffer driver and use a very
basic test program which does nothing more than map the framebuffer
memory and write to it, measuring the time passing by during the write.
I used different write methods, but apart from the STMIA for ARM which
forces a burst write I could not see a difference.
Unfortunately I did not get the FPGA evaluation board to run in a PC,
not even using the bridge evaluation board, somehow the BIOS did not
like it at all and got stuck. Most PCI graphics cards I found had the
same performance (2 Matrox PCI, 1 Matrox PCIe with internal PCIe->PCI
bridge, one ATI Radeon), only a very old ATI card was much faster
for - for me - no apparent reason. And, a really new 16-lane PCIe
card was also faster (around 165 MBytes/s), but this one obviously is
not really useful for comparison.

What puzzles me:
- why do different graphics cards behave so different when there is
  no obvious difference in lspci and both use the same, framebuffer-
  internal, mmap function?
- why is it possible to write-combine(?) the single writes in the
  PC and not on the ARM platform?
- what does the old (I am tempted to call it stone-age) ATI card do
  to get this great write performance?
- or, last but not least, is my measurement crap?

Below are my tests, I hope I did not leave any relevant information
out - sorry it is so huge. As i did not see any difference in lspci
parameters I posted only one of the "slow" examples.
The values on the ARM are ideal values only with fixed register values
to write. As soon as I have memory accesses in between to read "real"
data, the performance drops down to around half in case of STM.

(I already asked on the ARM kernel mailing list which gave me the
hint of using STM, but no background on what might happen on the
PCI, and I did not yet have the PC comparison at that time:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/89561 )

Regards,
Wolfgang


Test program:
[open, mmap, ...]
	gettimeofday(&tv1, NULL);
#if 1
  for (i = MEMSIZE/32; i; i--) {
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
    *(fbp++) = fill_val;
  }
#elif 0
  memset(fbp, 0xff, MEMSIZE);
#else
  /* ARM only! */
  {
        register long __r0 asm("r0") = fill_val;
        register long __r1 asm("r1") = fill_val;
        register long __r2 asm("r2") = fill_val;
        register long __r3 asm("r3") = fill_val;
        register long __r4 asm("r4") = fill_val;
        register long __r5 asm("r5") = fill_val;
        register long __r6 asm("r6") = fill_val;
        register long __r7 asm("r7") = fill_val;
        for (i = MEMSIZE/32; i; i--) {
                asm volatile(
                        "stmia %0!, {r0 - r7}"
                        : "+r" (fbp)
                        : "r" (__r0), "r" (__r1), "r" (__r2), "r" (__r3), "r" (__r4), "r" (__r5), "r" (__r6), "r" (__r7));
        }
  }
#endif
	gettimeofday(&tv2, NULL);
	diff = tv2.tv_sec - tv1.tv_sec;
	diff *= 1000000;
	diff += tv2.tv_usec - tv1.tv_usec;
	printf("wrote %d bytes in %d microseconds, %d Bytes/s\n",
		MEMSIZE, diff, (int)((double)MEMSIZE * 1000000.0 / (double)diff));


Test results, first for ARM and then for PC (x86):

ARM (Kirkwood, OpenRD-base, Marvell 88SB2211 PCIe->PCI eval board,
     Lattice EC/ECP standard evaluation board Rev. B,
     kernel 2.6.36)
00:01.0 Class 0604: Device 11ab:2211 (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00001000-00004fff
        Memory behind bridge: e0000000-e3ffffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort+ >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [48] Express (v1) PCI/PCI-X Bridge, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-

01:08.0 Class ff00: Device 1731:0101 (rev 10)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr+ DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=64M]
        Region 1: I/O ports at <unassigned> [disabled]
        Kernel driver in use: ArtistaNET-III frame buffer driver

Driver: simple framebuffer driver, using framebuffer's internal mmap()

STM: around 42 MBytes/s
	wrote 8388608 bytes in 201079 microseconds, 41717971 Bytes/s
memset: around 6.2 MBytes/s
	wrote 8388608 bytes in 1346533 microseconds, 6229782 Bytes/s
for (i = MEMSIZE/32; i; i--): around 6.2 MBytes/s
	wrote 8388608 bytes in 1346277 microseconds, 6230967 Bytes/s




PC (Gigabyte GA-P35-S3G, Intel Core2 Duo CPU E6850  @ 3.00GHz,
    Debian 6.0, kernel 2.6.32-5-686)

root@ww1-test:~# lspci -vvx -s 04:00.0
04:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro 215GP (rev 5c) (prog-if 00 [VGA controller])
	Subsystem: ATI Technologies Inc Rage Pro Turbo
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Region 0: Memory at f9000000 (32-bit, prefetchable) [size=16M]
	Region 1: I/O ports at d000 [size=256]
	Region 2: Memory at f8000000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at f7000000 [disabled] [size=128K]
	Kernel driver in use: atyfb
00: 02 10 50 47 87 00 80 02 5c 00 00 03 08 20 00 00
10: 08 00 00 f9 01 d0 00 00 00 00 00 f8 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 50 47
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 08 00

memset: around 106 MBytes/s
	wrote 2097152 bytes in 19811 microseconds, 105857957 Bytes/s
for (i = MEMSIZE/32; i; i--): around 106 MBytes/s
	wrote 2097152 bytes in 19673 microseconds, 106600518 Bytes/s


root@ww1-test:~# lspci -vvx -s 04:00.0
04:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA 1064SG [Mystique] (rev 02) (prog-if 00 [VGA controller])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at f3000000 (32-bit, non-prefetchable) [size=16K]
	Region 1: Memory at f6000000 (32-bit, prefetchable) [size=8M]
	Region 2: Memory at f4000000 (32-bit, non-prefetchable) [size=8M]
	[virtual] Expansion ROM at f6800000 [disabled] [size=64K]
	Kernel driver in use: matroxfb
00: 2b 10 1a 05 87 00 80 02 02 00 00 03 00 20 00 00
10: 00 00 00 f3 08 00 00 f6 00 00 00 f4 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff
30: 00 00 00 00 00 00 00 00 00 00 00 00 0c 01 00 00

memset: around 26.5 MBytes/s
	wrote 2097152 bytes in 78682 microseconds, 26653516 Bytes/s
for (i = MEMSIZE/32; i; i--): around 26.5 MBytes/s
	wrote 2097152 bytes in 78677 microseconds, 26655210 Bytes/s


