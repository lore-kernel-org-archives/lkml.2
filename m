Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153Ab2J2REt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:04:49 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:44190
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804Ab2J2REr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:04:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(z21eIz98dI9371I936eI103dK1432I4015Izz1202h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MCNZFO-02-1BG-02
X-M-MSG: 
Date: Mon, 29 Oct 2012 12:04:36 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ben Hutchings <ben@decadent.org.uk>, Mark Lord <kernel@teksavvy.com>,
        Yinghai Lu <yinghai@kernel.org>, Willy Tarreau <w@1wt.eu>,
        <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
Message-ID: <20121029170436.GA6604@jshin-Toonie>
References: <508E002B.4090200@teksavvy.com>
 <20121029064643.GE574@1wt.eu>
 <508E913D.2080104@teksavvy.com>
 <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
 <20121029144722.GA23217@jshin-Toonie>
 <20121029165823.GA6614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121029165823.GA6614@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:58:23AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Oct 29, 2012 at 09:47:22AM -0500, Jacob Shin wrote:
> > On Mon, Oct 29, 2012 at 02:40:58PM +0000, Ben Hutchings wrote:
> > > On Mon, 2012-10-29 at 10:22 -0400, Mark Lord wrote:
> > > > On 12-10-29 02:46 AM, Willy Tarreau wrote:
> > > > > On Mon, Oct 29, 2012 at 12:03:55AM -0400, Mark Lord wrote:
> > > > >> My server here runs the 3.4.xx series of "stable" kernels.
> > > > >> Until today, it was running 3.4.9.
> > > > >> Today I tried to upgrade it to 3.4.16.
> > > > >> It hangs in setup.c.
> > > > >>
> > > > >> I've isolated the fault down to this specific change
> > > > >> that was made between 3.4.9 and 3.4.16.
> > > > >> Reverting this change allows the system to boot/run normally again.
> > > > >>
> > > > >>
> > > > >> --- linux-3.4.9/arch/x86/kernel/setup.c	2012-08-15 11:17:17.000000000 -0400
> > > > >> +++ linux-3.4.16/arch/x86/kernel/setup.c	2012-10-28 13:36:33.000000000 -0400
> > > > >> @@ -927,8 +927,21 @@
> > > > >>
> > > > >>  #ifdef CONFIG_X86_64
> > > > >>  	if (max_pfn > max_low_pfn) {
> > > > >> -		max_pfn_mapped = init_memory_mapping(1UL<<32,
> > > > >> -						     max_pfn<<PAGE_SHIFT);
> > > > >> +		int i;
> > > > >> +		for (i = 0; i < e820.nr_map; i++) {
> > > > >> +			struct e820entry *ei = &e820.map[i];
> > > > >> +
> > > > >> +			if (ei->addr + ei->size <= 1UL << 32)
> > > > >> +				continue;
> > > > >> +
> > > > >> +			if (ei->type == E820_RESERVED)
> > > > >> +				continue;
> > > > >> +
> > > > >> +			max_pfn_mapped = init_memory_mapping(
> > > > >> +				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
> > > > >> +				ei->addr + ei->size);
> > > > >> +		}
> > > > >> +
> > > > >>  		/* can we preseve max_low_pfn ?*/
> > > > >>  		max_low_pfn = max_pfn;
> > > > >>  	}
> > > > > 
> > > > > For the record, it is this commit introduced in 3.4.16 :
> > > > > 
> > > > > commit efd5fa0c1a1d1b46846ea6e8d1a783d0d8a6a721
> > > > > Author: Jacob Shin <jacob.shin@amd.com>
> > > > > Date:   Thu Oct 20 16:15:26 2011 -0500
> > > > > 
> > > > >     x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
> > > > >     
> > > > >     commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a upstream.
> > > > >     
> > > > >     On systems with very large memory (1 TB in our case), BIOS may report a
> > > > >     reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> > > > >     these from the direct mapping.
> > > > >     
> > > > >     [ hpa: this should be done not just for > 4 GB but for everything above the legacy
> > > > >       region (1 MB), at the very least.  That, however, turns out to require significant
> > > > >       restructuring.  That work is well underway, but is not suitable for rc/stable. ]
> > > > >     
> > > > >     Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > > > >     Link: http://lkml.kernel.org/r/1319145326-13902-1-git-send-email-jacob.shin@amd.com
> > > > >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > > >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > 
> > > > > Willy
> > > > 
> > > > 
> > > > Thanks, Willy.
> > > > 
> > > > I've also now downloaded linux-3.7.0-rc3, and it boots/runs without need for patching.
> > > > So there's a fix somewhere in between that perhaps could also get backported to -stable.
> > > 
> > > Might well be:
> > > 
> > > commit 1f2ff682ac951ed82cc043cf140d2851084512df
> > > Author: Yinghai Lu <yinghai@kernel.org>
> > > Date:   Mon Oct 22 16:35:18 2012 -0700
> > > 
> > >     x86, mm: Use memblock memory loop instead of e820_RAM
> > > 
> > > However I'm not sure that this loop is correct either.  Yinghai, does
> > > your version definitely iterate in increasing pfn order?  If not then
> > > the max_pfn_mapped assignment must be conditional.
> > 
> > Hi, I believe these two commits in mainline should fix Alexander's failing
> > machien:
> > 
> > 844ab6f993b1d32eb40512503d35ff6ad0c57030
> > f82f64dd9f485e13f29f369772d4a0e868e5633a
> > 
> > This thread has some more details:
> > 
> > https://lkml.org/lkml/2012/10/21/157
> > 
> > Sorry, and thanks!
> 
> Thanks, I've queued these up now.

Thanks,

And also unrelated to Alexander's panic, but related to the commit in question
1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a

These two commits from Yinghai should also be backported into stable, or I
think it is already in progress (I saw an email out to Yinghai saying that the
patch did not apply cleanly, and needs to be manually backported):

6ede1fd3cb404c0016de6ac529df46d561bd558b
1f2ff682ac951ed82cc043cf140d2851084512df

Right Yinghai?

Thanks!

-Jacob

> 
> greg k-h
> 

