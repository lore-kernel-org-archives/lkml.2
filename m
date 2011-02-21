Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1BUR2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:28:17 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56334 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1BUR2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:28:15 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGZ9UT-02-0ZL-02
X-M-MSG: 
Date: Mon, 21 Feb 2011 18:28:07 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
Message-ID: <20110221172807.GD16508@amd.com>
References: <4D57F677.3090004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D57F677.3090004@redhat.com>
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

On Sun, Feb 13, 2011 at 10:19:19AM -0500, Avi Kivity wrote:
> On 02/09/2011 07:29 PM, Joerg Roedel wrote:
> > Hi Avi, Marcelo,
> >
> > here is the patch-set to implement the TSC-scaling feature of upcoming
> > AMD CPUs. When this feature is supported the CPU provides a new MSR
> > which holds a multiplier for the hardware TSC which is applied on the
> > value rdtsc[p] and reads of MSR 0x10. This feature can be used to
> > emulate a given tsc frequency for the guest.
> > Patch 1 is not directly related to this patch-set because it only fixes
> > a bug which prevented me from testing these patches. In fact it fixes
> > the same bug Andre sent a patch for. But after the discussion about his
> > patch he told me to just post my patch and thus here it is.
> >
> 
> Questions:
> - the tsc multiplier really is a multiplier, right?  Not an addend that 
> is added every cycle.

Yes, it is a real multiplier. But writes to the TSC-MSR will change the
unscaled TSC value.

> 
> So
> 
>      wrmsr(TSC, 1e9)
>      wrmsr(TSC_MULT, 2.0000)
>      t = rdtsc()
> 
> will return about 2e9, not 1e9 + 2*(time to execute the code snippet) ?

Right. And if you exchange the two wrmsr calls it will still give you
the same result.

> - what's the cost of wrmsr(TSC_MULT)?

Hard to tell by now because I only have numbers for pre-production
hardware. 

> There are really two ways to implement this feature.  One is fully 
> generic, like you did.  The other is to implement it at the host level - 
> have a sysfs file and/or kernel parameter for the desired tsc frequency, 
> write it once, and forget about it.  Trust management to set the host 
> tsc frequency to the same value on all hosts in a migration cluster.

The motivation here is mostly the flexibility. Scale the TSC for the
whole migration cluster only makes sense if all hosts there support the
feature. But the most likely scenario is that existing migration
clusters will be extended by new machines and guests will be migrated
there. And these guests should be able to see the same TSC frequency on
the new host as the had on the old one. The older machines in the
cluster may even have different TSC frequencys. With this flexible
implementation those scenarios are possible. A host-wide setting for the
scaling will make the feature useless in those (common) scenarios.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

