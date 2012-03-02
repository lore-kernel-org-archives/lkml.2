Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2CBNQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:16:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34365 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2CBNQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:16:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cwillu@gmail.com designates 10.52.27.111 as permitted sender) smtp.mail=cwillu@gmail.com; dkim=pass header.i=cwillu@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
Date: Fri, 2 Mar 2012 07:16:33 -0600
X-Google-Sender-Auth: 9O6xBQuaLPkFBmnOQk3-xw7PZws
Message-ID: <CAE5mzvgfsHD1Ku5saw+Cu7+vJAayx20=HfHfab1MrAwz3AtqJg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
From: cwillu <cwillu@cwillu.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:38 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> This series addresses regression problems with
>
>    commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>    ahci: start engine only during soft/hard resets

I just spent the better part of last night tracking down the specific
sources of the log entry I get when I disconnect my e-sata drive; once
it disconnects, the port is dead until I reboot; no combination of
anything I've been able to poke at in /sys or elsewhere gets it live
again.  This starts with 3.3rc1, and turns out to still work fine in
3.2.1. Any chance it's related?

3.3rc5, immediately after the unplug:

[359799.624284] ata5: exception Emask 0x50 SAct 0x0 SErr 0x4090800
action 0xe frozen
[359799.624293] ata5: irq_stat 0x00400040, connection status changed
[359799.624298] ata5: SError: { HostInt PHYRdyChg 10B8B DevExch }
[359799.624304] ata5: hard resetting link
[359800.348021] ata5: SATA link down (SStatus 0 SControl 300)
[359805.348019] ata5: hard resetting link
[359805.668015] ata5: SATA link down (SStatus 0 SControl 300)
[359805.668030] ata5: limiting SATA link speed to 1.5 Gbps
[359810.668014] ata5: hard resetting link
[359810.988027] ata5: SATA link down (SStatus 0 SControl 310)
[359810.988038] ata5.00: disabled
[359810.988052] ata5: EH complete
[359810.988062] ata5.00: detaching (SCSI 4:0:0:0)
[359810.989357] sd 4:0:0:0: [sde] Synchronizing SCSI cache
[359810.989403] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[359810.989410] sd 4:0:0:0: [sde] Stopping disk
[359810.989422] sd 4:0:0:0: [sde] START_STOP FAILED
[359810.989426] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK

plug it back in, and nothing happens.

3.3rc4 + v2 of your patch series (because there's nothing better than
finding a likely culprit after 8 hours reading unfamiliar code, and
the first search result for its commit log has words  "However, some
devices currently have issues with that fix, so we must implement a
flag that delays the ahci_start_engine() call only for specific
controllers" along with a patch):

[  135.966542] netconsole: network logging started
[  136.043949] Fri Mar 2 06:09:41 CST 2012
[  164.204992] SysRq : Changing Loglevel
[  164.205008] Loglevel set to 9

unplug the esata cable

[  182.076415] ata5: exception Emask 0x50 SAct 0x0 SErr 0x4090800
action 0xe frozen
[  182.076429] ata5: irq_stat 0x00400040, connection status changed
[  182.076443] ata5: SError: { HostInt PHYRdyChg 10B8B DevExch }
[  182.076449] ata5: hard resetting link
[  182.800028] ata5: SATA link down (SStatus 0 SControl 300)
[  187.800020] ata5: hard resetting link
[  188.120032] ata5: SATA link down (SStatus 0 SControl 300)
[  188.120050] ata5: limiting SATA link speed to 1.5 Gbps
[  193.120021] ata5: hard resetting link
[  193.440046] ata5: SATA link down (SStatus 0 SControl 310)
[  193.440087] ata5.00: disabled
[  193.440106] ata5: EH complete
[  193.440127] ata5.00: detaching (SCSI 4:0:0:0)
[  193.441626] sd 4:0:0:0: [sde] Synchronizing SCSI cache
[  193.441726] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  193.441734] sd 4:0:0:0: [sde] Stopping disk
[  193.441745] sd 4:0:0:0: [sde] START_STOP FAILED
[  193.441750] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK

plug it back in, and nothing happens.


The same the same thing on 3.2.1 for comparison:

[   68.834142] netconsole: network logging started
[   76.551905] SysRq : Changing Loglevel
[   76.551917] Loglevel set to 9

unplug

[   87.530721] ata5: exception Emask 0x50 SAct 0x0 SErr 0x4090800
action 0xe frozen
[   87.530735] ata5: irq_stat 0x00400040, connection status changed
[   87.530739] ata5: SError: { HostInt PHYRdyChg 10B8B DevExch }
[   87.530748] ata5: hard resetting link
[   88.252038] ata5: SATA link down (SStatus 0 SControl 300)
[   93.252026] ata5: hard resetting link
[   93.576040] ata5: SATA link down (SStatus 0 SControl 300)
[   93.576069] ata5: limiting SATA link speed to 1.5 Gbps
[   98.576034] ata5: hard resetting link
[   98.896035] ata5: SATA link down (SStatus 0 SControl 310)
[   98.896052] ata5.00: disabled
[   98.896069] ata5: EH complete
[   98.896090] ata5.00: detaching (SCSI 4:0:0:0)
[   98.897565] sd 4:0:0:0: [sde] Synchronizing SCSI cache
[   98.898391] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   98.898405] sd 4:0:0:0: [sde] Stopping disk
[   98.898417] sd 4:0:0:0: [sde] START_STOP FAILED
[   98.898421] sd 4:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK

and plug it back in...

[  111.783606] ata5: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[  111.783620] ata5: irq_stat 0x00000040, connection status changed
[  111.783625] ata5: SError: { CommWake DevExch }
[  111.783633] ata5: limiting SATA link speed to 1.5 Gbps
[  111.783638] ata5: hard resetting link
[  112.676058] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  112.678304] ata5.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
[  112.678316] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[  112.679599] ata5.00: configured for UDMA/133
[  112.679635] ata5: EH complete
[  112.679763] scsi 4:0:0:0: Direct-Access     ATA      WDC
WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
[  112.679933] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[  112.680107] sd 4:0:0:0: [sde] Write Protect is off
[  112.680112] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[  112.680140] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  112.680804] sd 4:0:0:0: Attached scsi generic sg4 type 0
[  113.099967]  sde: unknown partition table
[  113.100259] sd 4:0:0:0: [sde] Attached SCSI disk

It lives!  (and it works fine all the way back to 2.6.32, possibly earlier).

Now, the reason I'm picking on you is that git blame only has a
handful of lines in libata-eh.c, and as near as I can figure, the only
lines of code that changed in 3.3 that would seem to be able to cause
this are the ones that your series is a quasi revert of.  I don't have
hard evidence yet (unless the logged messages are more damning than I
think they are), but it does seem likely that, at the very least, you
might have some idea what's going on :p

-- Carey
