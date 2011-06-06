Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab1FFQgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:36:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61591 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1FFQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:36:35 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <20110606153557.GE1953@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com> <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
 <20110606153557.GE1953@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Jun 2011 19:36:13 +0300
Message-ID: <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 6:35 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> On Mon, Jun 06, 2011 at 11:15:30AM -0400, Ohad Ben-Cohen wrote:
>
>> This is insufficient; users need somehow to tell what page sizes are
>> supported by the underlying hardware (we can't assume host page-sizes,
>> and we want to use bigger pages whenever possible, to relax the TLB
>> pressure).
> /
> What does the IOMMU-API user need this info for? On the x86 IOMMUs these
> details are handled transparently by the IOMMU driver.

That's one way to do that, but then it means duplicating this logic
inside the different IOMMU implementations.

Take the OMAP (and seemingly MSM too) example: we have 4KB, 64KB, 1MB
and 16MB page-table entries. When we map a memory region, we need to
break it up to a minimum number of pages (while validating
sizes/alignments are sane). It's not complicated, but it can be nice
if it'd be implemented only once.

In addition, unless we require 'va' and 'pa' to have the exact same
alignment, we might run into specific page configuration that the
IOMMU implementation cannot restore on ->unmap, since unmap only takes
'va' and 'order'. So we will either have to supply 'pa' too, or have
the implementation remember the mapping in order to unmap it later.
That begins to be a bit messy...
