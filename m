Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2LUWiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:38:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37099 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2LUWio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:38:44 -0500
Date: Fri, 21 Dec 2012 17:38:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v6 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121221223824.GC1102@phenom.dumpdata.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <50CA6918.5060806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA6918.5060806@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 03:47:36PM -0800, H. Peter Anvin wrote:
> There are obviously good bits to this patchset, but I'm really
> starting to think the "pseudo-linear mode" via a trap handler --
> meaning we can access all of memory without any extra effort --
> makes more sense.  In fact, that way we could just build the full
> page tables without worrying about incremental bootstrap, depending
> on if that is a complexity win or not.
> 
> Either way, this is for native only: the Xen domain builder or other
> similar entry paths should be setting up page tables that cover all
> of memory; I'm hoping Konrad and Stefano can confirm this.

We do setup __ka space for everything everything we need to a fault.

Prior to 3.5 we could have blown over to the MODULES_SPACE if the guest
was booted with more than 128GB. That is now fixed so most of the
space _after_ the ramdisk in the __ka space can be blown away
and we use __va. We do this "cleanup" in xen_pagetable_init stage.


Which works as a long as cleanup_highmap only cleans up to
max_pfn_mapped (which in Xen case covers up to the RAMdisk).

The layout of __ka space is as follow:

 kernel
 ramdisk
 an array called P2M for which we use __ka address until xen_pagetable_init
          at which point we blow away any __ka entries for it.
 start_info (we swap over to use __va before generic code is run).
 the initial page-tables (for which the kernel uses __va address). we blow
         away the __ka entries when  xen_pagetable_init is called.

This __ka cleanup business was done for 64-bit only as the 32-bit
code scared me.


Hm, why that function is called xen_pagetable_init seems a bit silly.
> 
> The only reason to go with another approach I can think of is if it
> makes 32/64-bit unification cleaner.
> 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
