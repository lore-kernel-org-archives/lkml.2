Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1AFTtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:49:14 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38518 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1AFTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:49:13 -0500
X-IronPort-AV: E=Sophos;i="4.60,284,1291593600"; 
   d="scan'208";a="3643717"
Date: Thu, 6 Jan 2011 19:50:26 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Keir Fraser <keir@xen.org>
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag
 set.
In-Reply-To: <1294168856.3582.16.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1101061935070.2390@kaball-desktop>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>  <1293738517-7287-7-git-send-email-konrad.wilk@oracle.com>  <1294161878.3831.654.camel@zakaz.uk.xensource.com>  <20110104184604.GB1505@dumpdata.com>
 <1294168856.3582.16.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Ian Campbell wrote:
> On Tue, 2011-01-04 at 18:46 +0000, Konrad Rzeszutek Wilk wrote: 
> > On Tue, Jan 04, 2011 at 05:24:38PM +0000, Ian Campbell wrote:
> > > On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > > > Only enabled if XEN_DEBUG_FS is enabled.
> > > 
> > > Bit of an odd configuration option to use. Perhaps co-opt
> > > CONFIG_PARAVIRT_DEBUG instead?
> > > 
> > > Or maybe we need a new XEN_DEBUG option? or just make it a developer
> > > only EXTRA_CFLAGS +=-DDEBUG thing?
> > 
> > I think the 'XEN_DEBUG' works better.
> > > 
> > > Is this only temporary until the need for _PAGE_IOMAP is removed anyway?
> > 
> > I was thinking to leave it as a way to weed out bugs, but I could as well
> > just leave it in my "debug" branch and not propose it upstream.
> > 
> > I am not sure how to remove the _PAGE_IOMAP fully. We need some _flag_ to
> > signal 'xen_pte_val' that the PTE should not be looked up in the M2P.
> > 
> > Otherwise, for identity mappings, the value is 0xfffff.. (or 0x55555.. sometimes)
> > and the PTE ends up being messed up. Instead there is a check to see if
> > _PAGE_IOMAP is part of the PTE, and if so, no M2P lookup is done.
> > 
> > I guess we could do the M2P irregardless and just see if it is 0xfffff... and
> > if so just return the PTE without any changes.
> 
> Perhaps this ties in with the m2p overlay which Stefano+Jeremy have been
> working on to deal with granted foreign pages? I/O pages are a bit like
> foreign memory (if you squint enough)...
 
In theory the m2p overlay could be used for this purpose but in practice
the current m2p overlay API needs a struct page, also it might end up
stressing the hashtable too much.

Besides I think Konrad's solution might be simpler: if the m2p returns
one of the two special values we just return mfn from pte_mfn_to_pfn.

Keir, could you confirm that the m2p entries of DOM_IO pages are always
0xffffff or 0x55555?
