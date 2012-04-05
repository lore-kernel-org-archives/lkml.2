Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2DEARY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:17:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29641 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2DEARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:17:21 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-31-4f7ce48f94f7
From: =?ks_c_5601-1987?B?waTIv8H4?= <syr.jeong@samsung.com>
To: =?ks_c_5601-1987?B?J8GkyL/B+Cc=?= <syr.jeong@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Hugh Dickins'" <hughd@google.com>,
        cpgs@samsung.com
Cc: linaro-kernel@lists.linaro.org, "'Rik van Riel'" <riel@redhat.com>,
        linux-mmc@vger.kernel.org, "'Alex Lemberg'" <alex.lemberg@sandisk.com>,
        linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>
References: <201203301744.16762.arnd@arndb.de>
 <201204021145.43222.arnd@arndb.de>
 <alpine.LSU.2.00.1204020734560.1847@eggly.anvils>
 <201204021455.25029.arnd@arndb.de>
In-reply-to: 
Subject: RE: swap on eMMC and other flash
Date: Thu, 05 Apr 2012 09:17:18 +0900
Message-id: <02cc01cd12c1$769421e0$63bc65a0$%jeong@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0Q4KkjjiZK2dGpRMGtovdOdcMT6ABU1rCwAAPa7xAAAB0VEAAfXKIg
Content-language: ko
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Arnd

Hello, 

I'm not clearly understand the history of this e-mail communication because
I joined in the middle of mail thread.
Anyhow I would like to make comments for discard in swap area.
eMMC device point of view, there is no information of files which is used
in System S/W(Linux filesystem).
So...  In the eMMC, there is no way to know the address info of data which
was already erased.
If discard CMD send this information(address of erased files) to eMMC, old
data should be erased in the physical NAND level and get the free space
with minimizing internal merge.

I'm not sure that how Linux manage swap area.
If there are difference of information for invalid data between host and
eMMC device, discard to eMMC is good for performance of IO. It is as same
as general case of discard of user partition which is formatted with
filesystem.
As your e-mail mentioned, overwriting the logical address is the another
way to send info of invalid data address just for the overwrite area,
however it is not a best way for eMMC to manage physical NAND array. In
this case, eMMC have to trim physical NAND array, and do write operation at
the same time. It needs more latency.
If host send discard with invalid data address info in advance, eMMC can
find beat way to manage physical NAND page before host usage(write
operation).
I'm not sure it is the right comments of your concern.
If you need more info, please let me know

Best Regards
Hyojin


-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Monday, April 02, 2012 11:55 PM
To: Hugh Dickins
Cc: linaro-kernel@lists.linaro.org; Rik van Riel; linux-
mmc@vger.kernel.org; Alex Lemberg; linux-kernel@vger.kernel.org; Luca
Porzio (lporzio); linux-mm@kvack.org; Hyojin Jeong; kernel-
team@android.com; Yejin Moon
Subject: Re: swap on eMMC and other flash

On Monday 02 April 2012, Hugh Dickins wrote:
> On Mon, 2 Apr 2012, Arnd Bergmann wrote:
> > 
> > Another option would be batched discard as we do it for file systems:
> > occasionally stop writing to swap space and scanning for areas that 
> > have become available since the last discard, then send discard 
> > commands for those.
> 
> I'm not sure whether you've missed "swapon --discard", which switches 
> on discard_swap_cluster() just before we allocate from a new cluster; 
> or whether you're musing that it's no use to you because you want to 
> repurpose the swap cluster to match erase block: I'm mentioning it in 
> case you missed that it's already there (but few use it, since even 
> done at that scale it's often more trouble than it's worth).

I actually argued that discard_swap_cluster is exactly the right thing to
do, especially when clusters match erase blocks on the less capable devices
like SD cards.

Luca was arguing that on some hardware there is no point in ever submitting
a discard just before we start reusing space, because at that point it the
hardware already discards the old data by overwriting the logical addresses
with new blocks, while issuing a discard on all blocks as soon as they
become available would make a bigger difference. I would be interested in
hearing from Hyojin Jeong and Alex Lemberg what they think is the best time
to issue a discard, because they would know about other hardware than Luca.

	Arnd

