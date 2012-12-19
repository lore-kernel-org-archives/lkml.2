Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2LSWzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:55:21 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32262 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab2LSWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:55:14 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFAVNT-02-16Y-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 16:55:06 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219225505.GA2968@jshin-Toonie>
References: <50CCCFD0.7030704@linux.intel.com>
 <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
 <50CCEE49.3080801@zytor.com>
 <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D23EE8.7030904@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 02:25:44PM -0800, H. Peter Anvin wrote:
> On 12/19/2012 02:05 PM, Jacob Shin wrote:
> >On Wed, Dec 19, 2012 at 01:48:33PM -0800, H. Peter Anvin wrote:
> >>There are a few very serious problems we need to figure out related to generalizing very early boot.  If this range gets mapped, will the CPU treat it as WB?  If so, with what consequences for either the HT region or the hole below it?
> >
> >Hm .. I guess I need to read the whole email thread .. but if you can
> >explain it in short, what are the problems?
> >
> >Yes the CPU treats it as WB because the region is under TOM2, so by
> >default it is WB, and also when you create direct mapping page tables,
> >the PATs mark them as WB.
> >
> >What we have seen is that even though the kernel never generate memory
> >accesses in the hole (since E820 says that it is not RAM) when kernel
> >read/writes memory near the hole, the CPU was prefetching into the
> >hole because PATs say that it is WB. This resulted in MCE because
> >there is no physical RAM there.
> >
> 
> IOW, epic f*ckup.
> 
> The problem is that before we have awareness of the memory map, we
> need to map things in order to access them.  This is a big problem
> and right now there are ridiculous heuristics.  I have been working
> on mapping on demand, but there are concerns about the boundaries
> (i.e. what happens if the mapping spill over into a pit like this.)
> 
> This kind of stuff is really not acceptable.  A region which will
> cause malfunction if prefetched should not be WB in the MTRR system
> (I include TOM* in that.)  The real question is what we can do to
> mitigate the damage.

Well, really the problem is with any memory hole above 4GB that is too
big to be covered by variable range MTRRs as UC. Because the kernel
use to just simply do init_memory_mapping for 4GB ~ top of memory,
any memory hole above 4GB are marked as WB in PATs.

How is this handled in Intel architecture? If there are memory holes
that are too big to be covered by variable range MTRRs as UC, are
there other MTRR like CPU registers that the BIOS programs?


Thanks,

-Jacob

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

