Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab1DNTDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:03:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44720 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1DNTDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:03:15 -0400
Date: Thu, 14 Apr 2011 21:02:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v3] x86, MCE: Drop the default decoding notifier
Message-ID: <20110414190253.GQ10080@aftab>
References: <20110413143642.GC2791@aftab>
 <4DA5D6CC.9090500@redhat.com>
 <4DA5D9FB.1010503@redhat.com>
 <20110413173705.GJ2791@aftab>
 <20110414150036.GG10080@aftab>
 <4DA70D0B.3080407@redhat.com>
 <20110414151621.GI10080@aftab>
 <4DA71158.6020302@redhat.com>
 <20110414154405.GK10080@aftab>
 <4DA71774.9020900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA71774.9020900@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:49:08AM -0400, Prarit Bhargava wrote:
> > And we don't want to fix that - we want to fix the case with the
> > occasional CE MCEs which get detected in the polling path but none of
> > their MCA regs get dumped for decoding so the decoding hint there is
> > out of place. And we fixed that at least partially so that it doesn't
> > flood the logs. If you're not fine with the default ratelimit of 10 msgs
> > per 5 seconds we can always raise the ratelimit but tweaking an almost
> > hypothetical case is just not worth it.
> >
> Okay -- I'm good then.

Ok, injecting MCEs with this patch looks like this. Nevermind the
decoded MCEs, I simply uncommented the "if (ret != NOTIFY_DONE)" line
so that I can see the rate limiting. So we still have them there, this
is the default setting of 10 calls per 5 secs, we might want to dial it
down in the output. After the 10th MCE, it doesn't appear anymore.

Hmm...

Prarit, you said you have a machine which spits a lot of CECCs on boot,
does the final version help there, did you have a chance to run it?

[  312.983610] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: 9200400000010e3f
[  312.987463] [Hardware Error]: TSC 7ca4633c24 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807306 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[-|CE|-|PCC|-|CECC]: 0x9200400000010e3f
[  312.987463] [Hardware Error]: Data Cache Error: 
[  312.987463] [Hardware Error]: Corrupted DC MCE info?
[  312.987463] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: DRD, part-proc: GEN (no timeout)
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii' 					<-----------------
[  312.987463] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: d400400000010016
[  312.987463] [Hardware Error]: TSC 825c93b856 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807321 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[Over|CE|-|-|AddrV|CECC]: 0xd400400000010016
[  312.987463] [Hardware Error]: Data Cache Error: L2 TLB multimatch.
[  312.987463] [Hardware Error]: cache level: L2, tx: DATA
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii'						<-----------------
[  312.987463] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: d40040000000081f
[  312.987463] [Hardware Error]: TSC 852bb06a47 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807328 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[Over|CE|-|-|AddrV|CECC]: 0xd40040000000081f
[  312.987463] [Hardware Error]: Data Cache Error: 
[  312.987463] [Hardware Error]: Corrupted DC MCE info?
[  312.987463] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: RD, part-proc: SRC (no timeout)
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii'						<-----------------
[  312.987463] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: dc03400008000f43
[  312.987463] [Hardware Error]: TSC 9a9c3818f3 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807382 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[Over|CE|MiscV|-|AddrV|CECC]: 0xdc03400008000f43
[  312.987463] [Hardware Error]: Data Cache Error: 
[  312.987463] [Hardware Error]: Corrupted DC MCE info?
[  312.987463] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: DWR, part-proc: GEN (timed out)
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii'						<-----------------
[  312.987463] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: f600210000000107
[  312.987463] [Hardware Error]: TSC 88ce52d026 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807337 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[Over|UE|-|PCC|AddrV|UECC]: 0xf600210000000107
[  312.987463] [Hardware Error]: Data Cache Error: 
[  312.987463] [Hardware Error]: Corrupted DC MCE info?
[  312.987463] [Hardware Error]: cache level: L3/GEN, tx: DATA, mem-tx: GEN
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii'						<-----------------
[  312.987463] [Hardware Error]: CPU 0: Machine Check Exception: 0 Bank 0: dc03400008000f43
[  312.987463] [Hardware Error]: TSC 9a9c3818f3 
[  312.987463] [Hardware Error]: PROCESSOR 2:100f91 TIME 1302807382 SOCKET 0 APIC 0
[  312.987463] [Hardware Error]: MC0_STATUS[Over|CE|MiscV|-|AddrV|CECC]: 0xdc03400008000f43
[  312.987463] [Hardware Error]: Data Cache Error: 
[  312.987463] [Hardware Error]: Corrupted DC MCE info?
[  312.987463] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: DWR, part-proc: GEN (timed out)
[  312.987463] [Hardware Error]: Run the above through 'mcelog --ascii'						<-----------------
[  312.987463] [Hardware Error]: Machine check: MCIP not set in MCA handler
[  312.987463] [Hardware Error]: Fake kernel panic: Fatal machine check on current CPU
[  312.987463] mce_notify_irq: 2 callbacks suppressed
[  312.987463] [Hardware Error]: Machine check events logged

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
