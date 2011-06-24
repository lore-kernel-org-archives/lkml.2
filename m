Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1FXIIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:08:46 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:6719
	"EHLO CH1EHSOBE013.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530Ab1FXIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:08:37 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNABXJ-02-1RO-02
X-M-MSG: 
Date: Fri, 24 Jun 2011 10:08:05 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: David Woodhouse <dwmw2@infradead.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
Message-ID: <20110624080805.GG13255@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
 <1308843536.16742.48.camel@i7.infradead.org>
 <20110623172053.GV25383@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110623172053.GV25383@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 01:20:53PM -0400, Chris Wright wrote:
> * David Woodhouse (dwmw2@infradead.org) wrote:
> > I'd much rather KVM just gave us a list of the pages to map, in a single
> > call.
> 
> This makes most sense to me.

But how is this supposed to work with arbitrary page-sizes? When we
define the interface as

	int iommu_map(struct iommu_domain *domain,
		      unsigned long iova,
		      struct page **pages,
		      int num_pages);

how does the IOMMU driver know which page-sizes are the best to use?
Sure, it can check if the pages in the list are physically contiguous,
but that is really bad design.
The information about the right page-sizes is already available in the
caller and the best is to pass this information down to the iommu
driver (which then maps the region with the best-fitting page-sizes it
supports). I would rather change the interface to something like

	int iommu_map(struct iommu_domain *domain,
		      unsigned long iova,
		      phys_addr_t phys_addr,
		      size_t len);

In this interface the caller specifies that the system physical region
starting at phys_addr, ending at phys_addr+len-1 should be mapped at
iova. The IOMMU driver already knows that this region is physically
contiguous and can apply the right page-sizes itself.

This interface is also much friendlier to the caller because there is no
need to build a list of pages. And yes, there will be more users of the
iommu-api than KVM in the future.

The page-table page cache-flushing problem on VT-d can be solved with
the iommu_commit() function like I described in an previous email. This
one can be used for a number of things necessary on other iommus too
(like flushing io/tlbs) so that this interface makes sense for all iommu
hardware supported by the iommu-api.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

