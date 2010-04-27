Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0D0N2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:28:20 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:7180 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755741Ab0D0N2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:28:18 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM9371Pab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1JEQS-01-BF6-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 15:28:01 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Message-ID: <20100427132801.GI11097@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
 <4BD6DF7C.1090203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6DF7C.1090203@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 13:28:01.0834 (UTC) FILETIME=[75C5C8A0:01CAE60D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:58:36PM +0300, Avi Kivity wrote:
> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> >This patch introduces two fields in vcpu_arch for x86:
> >
> >	* fault_address
> >	* fault_error_code
> >
> >This will be used to correctly propagate page faults back
> >into the guest when we could have either an ordinary page
> >fault or a nested page fault. In the case of a nested page
> >fault the fault-address is different from the original
> >address that should be walked. So we need to keep track
> >about the real fault-address.
> >We could also remove the current path of the error_code to
> >the fault. But this change is too invasive and outside the
> >scope of this patch set. It will be changed and tested
> >seperatly.
> >
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/include/asm/kvm_host.h |    3 +++
> >  arch/x86/kvm/paging_tmpl.h      |    4 ++++
> >  2 files changed, 7 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index d9dfc8c..8426870 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -298,6 +298,9 @@ struct kvm_vcpu_arch {
> >  	/* Used for two dimensional paging emulation */
> >  	struct kvm_mmu nested_mmu;
> >
> >+	unsigned long fault_address;
> 
> Probably a problem on i386.  How does npt handle faults when the
> guest is using pae paging and the host (in our case the guest...)
> isn't?  I see it uses exit_info_2 for the address, which is a u64.

This shouldn't be an issue. If we run on 32bit host with nested paging
the guest can't have more than 4gb of addressable memory because of the
page table limitations (nested page table is always in host format).

> So we probably need to upgrade gva_t to a u64.  Please send this as
> a separate patch, and test on i386 hosts.
> 
> >+	int fault_error_code;
> 
> unsigned.

Right. I'll fix it.

> Maybe put the two in a struct, easier to pass around.

Yeah, makes it easier to read.

	Joerg


