Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab2ILPah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:30:37 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55476 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab2ILPaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:30:18 -0400
Date: Wed, 12 Sep 2012 17:30:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120912153016.GA12103@aftab.osrc.amd.com>
References: <1347403947-20187-1-git-send-email-johunt@akamai.com>
 <504FC2E9.4010708@akamai.com>
 <20120912085140.GA12277@aftab.osrc.amd.com>
 <5050824B.9050006@akamai.com>
 <5050857F.5060207@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050857F.5060207@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 07:52:15AM -0500, Josh Hunt wrote:
> I wanted to add that we started seeing this back in 3.0. I didn't go
> back any farther, but know it was not occurring in 2.6.38. The issue
> in 3.0 appeared to be that we shift left k8_dbam_to_chip_select()
> and there was also another shift in amd64_csrow_nr_pages(). It looks
> like that second shift has been replaced by a more recent patch,
> which actually checks to see if the csrow is enabled and then counts
> nr_pages again adding that to the first calculation, still resulting
> in the size being double.

Yes, you're basically right. Here's what I see from here:

In 2009 I added

commit 603adaf6b3e37450235f0ddb5986b961b3146a79
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Mon Dec 21 14:52:53 2009 +0100

    amd64_edac: fix K8 chip select reporting

    Fix the case when amd64_debug_display_dimm_sizes() reports only half the
    amount of DRAM on it because it doesn't account for when the single DCT
    operates in 128-bit mode and merges chip selects from different DIMMs.

which was supposed to fix a bug-report of DRAM chip selects being halved
in reporting.

But,

commit 41d8bfaba70311c2fa0666554ef160ea8ffc9daf
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Tue Jan 18 19:16:08 2011 +0100

    amd64_edac: Improve DRAM address mapping
    
    Drop static tables which map the bits in F2x80 to a chip select size in
    favor of functions doing the mapping with some bit fiddling. Also, add
    F15 support.


two years later reworked the whole DBAM to chip select sizes mapping for
all families. But it left in the clumsy workaround above for K8 only,
thus the double shifting.

So, long story short, reverting 603adaf6b3e37450235f0ddb5986b961b3146a79
should probably fix the issue since it is not needed anymore.

Let me run it here to make sure I'm not missing anything else.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
