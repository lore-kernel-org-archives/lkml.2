Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BFPvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:51:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab2BFPvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:51:43 -0500
Message-ID: <4F2FF70D.5020603@suse.de>
Date: Mon, 06 Feb 2012 16:51:41 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
References: <1328536531-19034-1-git-send-email-jack@suse.cz> <4F2FF4EC.1000104@linux.vnet.ibm.com>
In-Reply-To: <4F2FF4EC.1000104@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 04:42 PM, Srivatsa S. Bhat wrote:
> On 02/06/2012 07:25 PM, Jan Kara wrote:
> 
>> When discovery of lots of disks happen in parallel, we call
>> invalidate_bh_lrus() once for each disk from partitioning code resulting in a
>> storm of IPIs and causing a softlockup detection to fire (it takes several
>> *minutes* for a machine to execute all the invalidate_bh_lrus() calls).
>>
>> Fix the issue by allowing only single invalidation to run using a mutex and let
>> waiters for mutex figure out whether someone invalidated LRUs for them while
>> they were waiting.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/buffer.c |   23 ++++++++++++++++++++++-
>>  1 files changed, 22 insertions(+), 1 deletions(-)
>>
>>   I feel this is slightly hacky approach but it works. If someone has better
>> idea, please speak up.
>>
> 
> 
> Something related that you might be interested in:
> https://lkml.org/lkml/2012/2/5/109
> 
> (This is part of Gilad's patchset that tries to reduce cross-CPU IPI
> interference.)
> 
Yes, but this is only part of the equation.

When booting a machine with lots of disks chances are that each CPU
_will_ have LRU BHs attached to it (due to partitions table
reading). However, these LRU BHs have nothing to do with the device
in question. So we wouldn't even need to send IPIs here.
Sadly we seem to lack the facilities to figure that out
(I'm not an expert in that area to tell for sure :-).

So the best we can hope for is to serialise the IPIs to not overload
system with tons of IPIs.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
