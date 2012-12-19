Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2LSWFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:05:19 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46379
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab2LSWFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:05:13 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFATCH-01-3O8-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 16:05:04 -0600
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
Message-ID: <20121219220504.GA32212@jshin-Toonie>
References: <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
 <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
 <50CCCFD0.7030704@linux.intel.com>
 <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
 <50CCEE49.3080801@zytor.com>
 <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 01:48:33PM -0800, H. Peter Anvin wrote:
> There are a few very serious problems we need to figure out related to generalizing very early boot.  If this range gets mapped, will the CPU treat it as WB?  If so, with what consequences for either the HT region or the hole below it?

Hm .. I guess I need to read the whole email thread .. but if you can
explain it in short, what are the problems?

Yes the CPU treats it as WB because the region is under TOM2, so by
default it is WB, and also when you create direct mapping page tables,
the PATs mark them as WB.

What we have seen is that even though the kernel never generate memory
accesses in the hole (since E820 says that it is not RAM) when kernel
read/writes memory near the hole, the CPU was prefetching into the
hole because PATs say that it is WB. This resulted in MCE because
there is no physical RAM there.

-Jacob

> 
> Jacob Shin <jacob.shin@amd.com> wrote:
> 
> >On Wed, Dec 19, 2012 at 09:37:51PM +0100, Borislav Petkov wrote:
> >> On Sat, Dec 15, 2012 at 03:17:05PM -0800, H. Peter Anvin wrote:
> >> > On 12/15/2012 03:15 PM, Yinghai Lu wrote:
> >> > >>
> >> > >>That is for the kernel region itself (that code is actually
> >unchanged from
> >> > >>the current code), and yes, we could cap that one to _end if
> >there are
> >> > >>systems which have bugs in that area.  The dynamic page tables
> >map 1G
> >> > >>aligned at a time.
> >> > >
> >> > >dynamic should be 2M too.
> >> > >
> >> > >AMD system:
> >> > >
> >> >
> >>http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=66520ebc2df3fe52eb4792f8101fac573b766baf
> >> > >
> >> > >  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
> >> > >  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
> >> > >  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> >> > >
> >> > >the hole is not 1G aligned.
> >> > >
> >> > >or HT region is from e040000000 ?
> >> > >
> >> > 
> >> > The HT region starts at 0xfd00000000 -- after that reserved region,
> >> > so I have no idea what that particular system is trying to do or
> >> > what is requirements are (nor what its MTRR setup is, since you
> >> > didn't post it.)
> >> 
> >> This is something that Jacob should be able to answer since he's been
> >> dealing with the 1T support.
> >> 
> >> Jacob, how is the HT hole marked on AMD? I know hazily that we do say
> >> "all memory regions cacheable by default if not explicitly marked"
> >but
> >> we need to exclude the HT hole from that, right?
> >> 
> >> So how are we doing that, MTRRs?
> >
> >HT hole is architectural, I guess in manuals somewhere and is:
> >0xfd00000000 ~ 0x10000000000. CPU cannot generate memory read/write in
> >that region.
> >
> >On that above particular system, there is 1TB of total RAM, and since
> >we do not want to loose memory around the HT hole, what BIOS has done
> >is programmed the DRAM controller to move the last 128 GB of memory
> >to above the HT region. There are 8 memory nodes, the last DRAM
> >address of the 7th node is 0xe038000000. Then there is a hole and the
> >first address of the last memory node starts at 1TB.
> >
> >MTRRs only cover under 4GB, and does not cover the HT hole.
> >
> >Yinghai's mm patchset to only direct map regions backed by RAM solves
> >our memory hole around HT area.
> >
> >I've tested Yinghai's patchset (several of early versions)
> >successfully on our above 1TB system. I'll try the latest tip/mm2
> >again sometime later today, but I'm pretty sure it should be fine.
> >
> >Thanks,
> >
> >-Jacob
> >
> >> 
> >> Thanks.
> >> 
> >> -- 
> >> Regards/Gruss,
> >>     Boris.
> >> 
> >> Sent from a fat crate under my desk. Formatting is fine.
> >> --
> >> 
> 
> -- 
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
> 

