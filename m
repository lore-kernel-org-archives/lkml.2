Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab0DWORa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:17:30 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:19299
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751434Ab0DWOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:17:27 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMab9bhzz1202hzz6ff19hz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C2CJ-01-6FL-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:17:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] KVM: SVM: Sync cr0 and cr3 to kvm state before
 nested handling
Message-ID: <20100423141706.GE31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-4-git-send-email-joerg.roedel@amd.com>
 <894CCCC7-6E35-499D-9EF6-57A9123B969C@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <894CCCC7-6E35-499D-9EF6-57A9123B969C@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:17:06.0620 (UTC) FILETIME=[A75977C0:01CAE2EF]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 03:50:20PM +0200, Alexander Graf wrote:
> 
> On 22.04.2010, at 12:33, Joerg Roedel wrote:
> 
> > This patch syncs cr0 and cr3 from the vmcb to the kvm state
> > before nested intercept handling is done. This allows to
> > simplify the vmexit path.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> > arch/x86/kvm/svm.c |   15 ++++++---------
> > 1 files changed, 6 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index c480d7f..5ad9d80 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -1799,10 +1799,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
> > 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
> > 	nested_vmcb->save.idtr   = vmcb->save.idtr;
> > 	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
> > -	if (npt_enabled)
> > -		nested_vmcb->save.cr3    = vmcb->save.cr3;
> > -	else
> > -		nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
> > +	nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
> 
> 
> Why don't we need this anymore again?

Because arch.cr3 contains always the current l2-cr3. This wasn't the
case before because the sync was done after the nested handling. But now
we do it before a vmexit can happen and are safe to just use arch.cr3.

	Joerg


