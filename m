Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0DWOvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:51:50 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:47722
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754115Ab0DWOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:51:48 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMzz1202hzzz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C3XM-01-8X4-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:51:20 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: SVM: Fix nested nmi handling
Message-ID: <20100423145120.GL31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-2-git-send-email-joerg.roedel@amd.com>
 <622FCBB5-826D-4392-A521-7E395507398B@suse.de>
 <20100423141355.GD31537@amd.com>
 <85D89C34-806C-4376-89BA-5BFD413F5396@suse.de>
 <20100423142258.GG31537@amd.com>
 <013159C3-277C-447C-B64B-D2196AF851F9@suse.de>
 <20100423143159.GJ31537@amd.com>
 <768234E2-FF02-42AC-B04C-00D98B19B1C0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <768234E2-FF02-42AC-B04C-00D98B19B1C0@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:51:20.0736 (UTC) FILETIME=[6FB2B200:01CAE2F4]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 04:42:52PM +0200, Alexander Graf wrote:
> 
> On 23.04.2010, at 16:31, Joerg Roedel wrote:
> 
> > On Fri, Apr 23, 2010 at 04:24:54PM +0200, Alexander Graf wrote:
> >> 
> >> On 23.04.2010, at 16:22, Joerg Roedel wrote:
> > 
> >>> No, nested_svm_nmi runs in atomic context where we can't emulate a
> >>> vmexit. We set exit_required and emulate the vmexit later.
> >> 
> >> So we modify the L2 rflags and then trigger a #vmexit, leaving the l2
> >> state broken?
> > 
> > No, the rflags are changed in enable_nmi_window which isn't called when
> > we run nested and the nested hypervisor intercepts nmi. So it only runs
> > in the !nested case where it can't corrupt L2 state.
> 
> Last time I checked the code enable_nmi_window was the function
> triggering the #vmexit,

Yes, thats the bug which this patch fixes :-)

>so it should run in that exact scenario. If what you say is true, where
>do we #vmexit instead then?

After setting exit_required we run into svm.c:svm_vcpu_run. There the
exit_required flag is checked and if set, the function immediatly
returns without doing a vmrun. A few cycles later we run into
svm.c:handle_exit() where at the beginning exit_required is checked, and
if set the vmexit is emulated.

	Joerg


