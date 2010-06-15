Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0FOOqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:46:18 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:35732 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757890Ab0FOOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:46:16 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432N98dN936eM9371Pzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L4290O-01-CO7-02
X-M-MSG: 
Date: Tue, 15 Jun 2010 16:46:01 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "glommer@redhat.com" <glommer@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] Fix AMD C1 TSC desynchronization
Message-ID: <20100615144601.GD15264@amd.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-16-git-send-email-zamsden@redhat.com>
 <4C173E18.6000804@redhat.com>
 <4C174607.4040107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C174607.4040107@redhat.com>
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

On Tue, Jun 15, 2010 at 05:21:11AM -0400, Zachary Amsden wrote:
> On 06/14/2010 10:47 PM, Avi Kivity wrote:
> > On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> >> +    /*
> >> +     * AMD processors can de-synchronize TSC on halt in C1 state, 
> >> because
> >> +     * processors in lower P state will have TSC scaled properly during
> >> +     * normal operation, but will have TSC scaled improperly while
> >> +     * servicing cache probes.  Because there is no way to determine 
> >> how
> >> +     * TSC was adjusted during cache probes, there are two solutions:
> >> +     * resynchronize after halt, or disable C1-clock ramping.
> >> +     *
> >> +     * We implemenent solution 2.
> >> +     */
> >> +#ifdef CONFIG_K8_NB
> >> +    if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD&&
> >> +        boot_cpu_data.x86 == 0x0f&&
> >> +        !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> >> +        struct pci_dev *nb;
> >> +        int i;
> >> +        cache_k8_northbridges();
> >> +        for (i = 0; i<  num_k8_northbridges; i++) {
> >> +            u8 byte;
> >> +            nb = k8_northbridges[i];
> >> +            pci_read_config_byte(nb, 0x87,&byte);
> >> +            if (byte&  1) {
> >> +                printk(KERN_INFO "%s: AMD C1 clock ramping detected, 
> >> performing workaround\n", __func__);
> >> +                disabled_c1_ramp = byte;
> >> +                pci_write_config_byte(nb, 0x87, byte&  0xFC);
> >> +
> >> +            }
> >> +        }
> >> +    }
> >> +#endif

This is dangerous to do as a general thing on all Fam0fh based AMD
systems, especially mobile ones and especially since some distributions
load the kvm modules at boot per default.
The BIOS should set meaningful default values for PMM7 and the
recommended default value for servers already set this bit to zero.

> I agree it is complete hackery.  I do not recommend this patch for 
> upstream inclusion unless it is proposed also by someone more familiar 
> with the hardware.

I will check again with some other people inside AMD, but my current
suggestion would be to not provide kvm-clock to the guest if running on
an AMD Fam0fh processor in an SMP environemnt with PMM7.0 set. This also
sucks in its own way but is safer than just disable clock ramping on all
affected processors.

	Joerg


