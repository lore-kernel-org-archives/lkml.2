Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab1L3R1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:27:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53564 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1L3R1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:27:20 -0500
Message-ID: <4EFDF470.9050104@linux.vnet.ibm.com>
Date: Fri, 30 Dec 2011 11:27:12 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zcache: fix serialization bug in zv stats
References: <<1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>> <d9558871-53ec-4d49-8df4-c09bee100a49@default>
In-Reply-To: <d9558871-53ec-4d49-8df4-c09bee100a49@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11123017-1780-0000-0000-000001FA5EE0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000242; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00100634; UDB=6.00025812; UTC=2011-12-30
 17:27:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2011 11:02 AM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Sent: Friday, December 30, 2011 9:42 AM
>> To: Greg Kroah-Hartman
>> Cc: Seth Jennings; Dan Magenheimer; Brian King; devel@driverdev.osuosl.org; linux-
>> kernel@vger.kernel.org
>> Subject: [PATCH] staging: zcache: fix serialization bug in zv stats
>>
>> In a multithreaded workload, the zv_curr_dist_counts
>> and zv_cumul_dist_counts statistics are being corrupted
>> because the increments and decrements in zv_create
>> and zv_free are not atomic.
>>
>> This patch converts these statistics and their corresponding
>> increments/decrements/reads to atomic operations.
>>
>> Based on v3.2-rc7
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> I'm inclined to nack this change, at least unless inside an #ifdef DEBUG,
> as these counts are interesting to a developer but not useful to a normal
> end user, whereas the incremental cost for atomic_inc and atomic_dec are
> non-trivial.  I don't think any off-by-one in these counters could
> result in a bug and, before promotion from staging, they probably
> should just go away.  (They are fun to "watch -d" though ;-)

In my test, it hammers on particular chunk size and the counter is off
by hundreds :-/

I too was worried about performance impact, however, my tests showed
no degradation.  That's probably because there are bigger bottlenecks
elsewhere.

Perhaps we can commit this for now, so that the code is correct, and
revisit this when we try to replace zbud with zsmalloc.  I'm sure
we'll have to rethink the statistics at that time.

The only other option, IMO, is the remove the chunk stats altogether
until we can find a solution that is both fast and correct.

I think that continuing with incorrect stats, regardless of the degree
to which they are incorrect, isn't really a viable option.

--
Seth

