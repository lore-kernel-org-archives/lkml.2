Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0KYLqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:46:50 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:37908
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab0KYLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:46:48 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zzbb2dK1432N98dN9371P10d1Izz1202hzz15d4Rz32i691h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCFVDP-01-AMD-02
X-M-MSG: 
Date: Thu, 25 Nov 2010 12:46:40 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
Message-ID: <20101125114640.GC6031@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
 <4CED63DC.20608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CED63DC.20608@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 02:13:32PM -0500, Avi Kivity wrote:
> On 11/24/2010 08:18 PM, Joerg Roedel wrote:
> > Hi Avi, Hi Marcelo,
> >
> > here is a patch-set to make the instruction emulator aware of nested
> > virtualization. It basically works by introducing a new callback into
> > the x86_ops to check if a decoded instruction must be intercepted. If it
> > is intercepted the instruction emulator returns straight into the guest.
> >
> > I am not entirely happy with this solution because it partially
> > duplicates the code in the x86_emulate_insn function.
> 
> My big worry is that it makes svm.c aware of internal emulator variable, 
> so it makes it harder to hack on the emulator.

I don't think so, the structure of the code in svm.c follows the same
structures (even in a simpler way) as in the x86_emulate_insn()
function. Someone who changes the internal data structures of the
emulator can easily change svm.c too. This person will even recognize
the need for this automatically because svm.c will not compile anymore
when the data structure is changed.
On the other side, implementing this in the emulator itself would
require a person to learn about very low-level svm internals to get
everything right (or the changes easily break the code which is more
likely).

> So I don't think there's a problem with coding the svm intercepts in 
> emulate.c.  This is no different than emulating any AMD-specific 
> instruction in the emulator - we're emulating an instruction in exactly 
> the way it is specified in the manual.

That would make sense if the Nested-SVM code is implemented in the
generic code so that it is usable from VMX too. But that is not the case
and also not really doable.

> Something you could do is allocate bits for the intercept bit number and 
> exit code in opcode->flags.  This way most unconditional intercepts 
> happen outside the instruction switch: generic code reads the intercept 
> bit, the intercept word (via a callback), if the bit is set, returns the 
> exit code.  That should completely kill the diffstat.  We only need to 
> be careful wrt the order of the intercept check and the other permission 
> checks.

We have a lot of intercepts where this does not work. There is no 1-1
mapping between an opcode and an intercept. Some opcodes can result in
multiple different intercepts (mov cr, mov dr), sometimes multiple
intructions result in one intercept (rdmsr/wrmsr, in/out). The later
ones even need special handling because the differences between the
different instructions are encoded in the exit_info fields. All this
would expose svm-internals like the vmcb structure into the generic
code.
I think hacking all this in the emulator itself also makes it more
complex than it is today and the changes will likely break at some point
when somone hacks on the emulator. And the situation will not get better
when Nested-VMX gets merged and needs to do the same.

We basically have two choices here:

	a) We expose svm internals into the emulator
	b) We expose emulator internals into svm

Both choices are not really good from a software-design point-of-view.
But I think option b) is the better one because it is easier to cope with
and thus less likely to break when changing the emulator code.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

