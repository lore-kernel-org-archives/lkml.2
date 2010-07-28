Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0G1LwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:52:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41182 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0G1LwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:52:15 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L69NHJ-01-BDJ-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 13:51:33 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
Message-ID: <20100728115133.GG26098@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
 <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
 <4C4F2643.8080507@redhat.com>
 <20100728093708.GD26098@amd.com>
 <4C500636.1070708@redhat.com>
 <20100728112540.GE26098@amd.com>
 <4C5015B3.8010003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C5015B3.8010003@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 07:34:11AM -0400, Avi Kivity wrote:
>   On 07/28/2010 02:25 PM, Roedel, Joerg wrote:
> > On Wed, Jul 28, 2010 at 06:28:06AM -0400, Avi Kivity wrote:
> >> We have a slightly different problem, if the nested guest manages to get
> >> an instruction to be emulated by the host (if the guest assigned it the
> >> cirrus framebuffer, for example, so from L1's point of view it is RAM,
> >> but from L0's point of view it is emulated), then we miss the
> >> intercept.  L2 could take over L1 this way.
> > I wonder how this could happen. Shouldn't the shadow paging code take
> > care of this?
> >
> 
> L1 thinks the memory is RAM, so it maps it directly and forgets about 
> it.  L0 knows it isn't, so it leaves it unmapped and emulates any 
> instruction which accesses it.  The emulator needs to check whether the 
> instruction is intercepted or not.

Instruction intercepts take precedence over exception intercepts. So if
the L2 executes an instruction which the L1 hypervisor wants to
intercept we get this instruction intercept on the host side and
re-inject it.
To my understanding the fault-intercept which causes the emulator to run
can only happen if the instruction causing the fault isn't intercepted
itself.

> Note, I think if the instruction operand is in mmio, we're safe, since 
> the intercept has higher priority than memory access.  But if the 
> instruction itself is on mmio, or if we entered the emulator through smp 
> trickery, then the emulator will execute the instruction in nested guest 
> context.

Right. But if the guest executes code which is on mmio we are doomed
anyway because our instruction emulator does not emulate the whole x86
instruction set, right?

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

