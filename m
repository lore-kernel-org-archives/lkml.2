Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0G2HSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 03:18:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:49084 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0G2HSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 03:18:40 -0400
Date: Thu, 29 Jul 2010 16:17:31 +0900
To: hpa@zytor.com
Cc: konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C50B4C2.2070807@zytor.com>
References: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
	<20100728223816.GB32739@phenom.dumpdata.com>
	<4C50B4C2.2070807@zytor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 16:17:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 15:52:50 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 07/28/2010 03:38 PM, Konrad Rzeszutek Wilk wrote:
> > 
> > Long term I think the driverization is the way to go, and..
> > 
> > I think the flow a). check if we need SWIOTLB b), check all IOMMUs, c).
> > recheck SWIOTLB in case no IOMMUs volunteered MUST be preserved
> > irregardless if we driverize the IOMMUs/SWIOTLB or not.
> > 
> > Perhaps we should get together at one of these Linux conferences and
> > think this one through? Beers on me.
> > 
> 
> I don't understand point (a) here.  (c) simply seems like the fallback
> case, and in the case we are actively forcing swiotlb we simply skip
> step (b).

Looks like (a) is too simplified. The actual XEN code (a) is:

+int __init pci_xen_swiotlb_detect(void)
+{
+
+	/* If running as PV guest, either iommu=soft, or swiotlb=force will
+	 * activate this IOMMU. If running as PV privileged, activate it
+	 * irregardlesss.
+	 */
+	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
+	    (xen_pv_domain()))
+		xen_swiotlb = 1;
+
+	/* If we are running under Xen, we MUST disable the native SWIOTLB.
+	 * Don't worry about swiotlb_force flag activating the native, as
+	 * the 'swiotlb' flag is the only one turning it on. */
+	if (xen_pv_domain())
+		swiotlb = 0;
+
+	return xen_swiotlb;

It does things more complicated than checking if swiotlb usage is
forced.

Looks like we need to call Xen specific code twice, (a) and (c), I
dislike it though.


btw, (c) is not the fallback case (i.e. if we can't find hardware
IOMMU, we enable swiotlb). We use both hardware IOMMU and swiotlb on
some systems.
