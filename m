Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057Ab0GPQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:28:48 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29023 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965982Ab0GPQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:28:47 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5NSAE-01-LW2-02
X-M-MSG: 
Date: Fri, 16 Jul 2010 18:25:17 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100716162517.GF28902@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <4C3FDF43.6030203@zytor.com>
 <20100716063952.GB27546@aftab>
 <4C3F8418.5020803@zytor.com>
 <20100716072244.GA27954@aftab>
 <4C408298.8060004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C408298.8060004@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, Jul 16, 2010 at 12:02:32PM -0400

> On 07/16/2010 12:22 AM, Borislav Petkov wrote:
> >>
> >> No, the difference between using a separate variable and the CPU feature 
> >> bit is that CPU feature bit is ANDed across all CPUs, whereas this 
> >> variable is set if it is set on *any* CPU.
> > 
> > ... and that's ok because the MSR bits get set on all cores after BIOS
> > turns on C1E. Let me verify this though.
> > 
> 
> Is there any reason for the OR behavior?  Otherwise, it's just plain
> wrong...

I don't see the need for two things denoting C1E for the very simple
reason: when C1E gets enabled on a machine, one of the bits gets set in
the MSR on each core simultaneously. So if one core sees one of the bits
set, all the remaining cores are seeing them too. The first core that
sees one of the bits in the MSR, sets c1e_detected.

So next time any core does cpu_idle() => c1e_idle(), it switches to
timer broadcast on it since it might go into C1E if all the others
follow.

Frankly, I can't think of a case where we'd need to two things - I
could be missing something. But this workaround is a couple of years
old, maybe Thomas might give us more insight into whether there's a
particular reason for the cpuid flag and the c1e_detected variable.
Thomas?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

