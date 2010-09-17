Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0IQR3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:29:52 -0400
Received: from smtp.nokia.com ([147.243.1.47]:45749 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab0IQR3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:29:51 -0400
Date: Fri, 17 Sep 2010 20:28:34 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "Doyu Hiroshi (Nokia-MS/Helsinki)" <hiroshi.doyu@nokia.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
Message-ID: <20100917172834.GK20325@esdhcp04044.research.nokia.com>
References: <20100629.074423.71111160.Hiroshi.DOYU@nokia.com> <20100810.184903.214240645.Hiroshi.DOYU@nokia.com> <1284740327.32322.24.camel@e102109-lin.cambridge.arm.com> <20100917.200640.71092280.Hiroshi.DOYU@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917.200640.71092280.Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/10 19:06 +0200, Doyu Hiroshi (Nokia-MS/Helsinki) wrote:
> Hi Catalin,
> 
> From: ext Catalin Marinas <catalin.marinas@arm.com>
> Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
> Date: Fri, 17 Sep 2010 18:18:47 +0200
> 
> > On Tue, 2010-08-10 at 18:49 +0300, Hiroshi DOYU wrote:
> >> Now there's not much difference with the attached patch, a new version
> >> of alias.
> >> 
> >> / # modprobe kmemleak-special-test use_alias=0
> >> / # time echo scan > /sys/kernel/debug/kmemleak
> >> real    0m 2.30s
> >> user    0m 0.00s
> >> sys     0m 2.30s
> >> 
> >> / # modprobe kmemleak-special-test use_alias=1
> >> / # time echo scan > /sys/kernel/debug/kmemleak
> >> real    0m 3.91s
> >> user    0m 0.00s
> >> sys     0m 3.91s
> > 
> > So to understand - the first case is memory scanning without any aliases
> > configured. The second case is the alias scanning using a separate
> > prio_tree. The impact seems to be quite big.
> > 
> > But I wouldn't complicate the code with the callback mechanism,
> > especially when loadable modules are considered. Is the pointer
> > conversion always linear? Maybe we can just add an offset to the
> > scan_area structure that is used for conversion rather than a callback.
> >
> > Another advantage of the linear offset would be that we can avoid the
> > call for removing the conversion.
> > 
> > Is this feasible for your needs?
> 
> The formula is:
> 
>   new_value = virt_to_phys(original address) | each attributes;
> 
> Attribute bits must be ingored. So the conversion is:
> 
>   new_value &= ~each attributes;
>   original address = phys_to_virt(new_value);
> 
> Could adding an offset to the scan_area solve this case?
>
> > No point really in making it too
> > generic if the simple offset would (hopefully) do.
> 
> I guess other iommu pagetable may be same?

I wondered if having a scaling factor would be useful for the case
where pages are allocated, and the page address is separated from
the offset. (Did I see this in SG lists?)

I'm glad that we're all converging on an efficient solution.

Phil
