Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684Ab1FWPjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:39:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab1FWPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:39:21 -0400
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Date: Thu, 23 Jun 2011 16:38:54 +0100
In-Reply-To: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308843536.16742.48.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 17:31 +0200, Joerg Roedel wrote:
> David, I think especially VT-d can benefit from such a callback. I will
> implement support for it in the AMD IOMMU driver and post a patch-set
> soon.
> 
> Any comments, thoughts?

Ick. We *already* do the flushes as appropriate while we're filling the
page tables. So every time we move on from one page table page to the
next, we'll flush the old one. And when we've *done* filling the page
tables for the range we've been asked to map, we flush the last writes
too.

The problem with KVM is that it calls us over and over again to map a
single 4KiB page.

It doesn't seem simple to make use of a 'commit' function, because we'd
have to keep track of *which* page tables are dirty.

I'd much rather KVM just gave us a list of the pages to map, in a single
call. Or even a 'translation' callback we could call to get the physical
address for each page in the range.

-- 
dwmw2

