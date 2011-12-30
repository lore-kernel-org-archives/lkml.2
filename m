Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1L3Rbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:31:44 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28104 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1L3Rbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:31:42 -0500
MIME-Version: 1.0
Message-ID: <0c787a22-68ed-49d9-816b-c9a9c1821772@default>
Date: Fri, 30 Dec 2011 09:31:17 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH] staging: zcache: fix serialization bug in zv stats
References: <<1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <d9558871-53ec-4d49-8df4-c09bee100a49@default>
 <4EFDF470.9050104@linux.vnet.ibm.com>
In-Reply-To: <4EFDF470.9050104@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EFDF574.0101,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH] staging: zcache: fix serialization bug in zv stats
> 
> On 12/30/2011 11:02 AM, Dan Magenheimer wrote:
> >> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> >> Sent: Friday, December 30, 2011 9:42 AM
> >> To: Greg Kroah-Hartman
> >> Cc: Seth Jennings; Dan Magenheimer; Brian King; devel@driverdev.osuosl.org; linux-
> >> kernel@vger.kernel.org
> >> Subject: [PATCH] staging: zcache: fix serialization bug in zv stats
> >>
> >> In a multithreaded workload, the zv_curr_dist_counts
> >> and zv_cumul_dist_counts statistics are being corrupted
> >> because the increments and decrements in zv_create
> >> and zv_free are not atomic.
> >>
> >> This patch converts these statistics and their corresponding
> >> increments/decrements/reads to atomic operations.
> >>
> >> Based on v3.2-rc7
> >>
> >> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> >
> > I'm inclined to nack this change, at least unless inside an #ifdef DEBUG,
> > as these counts are interesting to a developer but not useful to a normal
> > end user, whereas the incremental cost for atomic_inc and atomic_dec are
> > non-trivial.  I don't think any off-by-one in these counters could
> > result in a bug and, before promotion from staging, they probably
> > should just go away.  (They are fun to "watch -d" though ;-)
> 
> In my test, it hammers on particular chunk size and the counter is off
> by hundreds :-/
> 
> I too was worried about performance impact, however, my tests showed
> no degradation.  That's probably because there are bigger bottlenecks
> elsewhere.
> 
> Perhaps we can commit this for now, so that the code is correct, and
> revisit this when we try to replace zbud with zsmalloc.  I'm sure
> we'll have to rethink the statistics at that time.
> 
> The only other option, IMO, is the remove the chunk stats altogether
> until we can find a solution that is both fast and correct.
> 
> I think that continuing with incorrect stats, regardless of the degree
> to which they are incorrect, isn't really a viable option.

OK, well I guess as long as this is addressed before promotion
from staging, and until then the heaviest users will be developers
so I agree you are correct that accurate stats are a good thing.
So, consider my nack resolved and:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
