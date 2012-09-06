Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2IFJEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2IFJEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:04:45 -0400
Message-ID: <50486727.7060509@redhat.com>
Date: Thu, 06 Sep 2012 11:04:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/3] target: try satisfying memory requests with higher-order
 allocations
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com> <1346896698.4162.403.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1346896698.4162.403.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 03:58, Nicholas A. Bellinger ha scritto:
>> This patch series fixes this problem by using higher-order allocations
>> to build the data scatterlist.  The problem is that iscsi assumes that the
>> scatterlist consists of single pages, which is not true anymore.  So
>> patch 2 has to introduce some relatively complicated changes to
>> iscsi_map_iovec and iscsi_unmap_iovec.
> 
> So enabling multi-page per SGL support is a feature that has been
> dormant within target core for a long time.  It's about time that we
> start taking advantage of it again.  ;)

Yeah, I noticed some preparation for it in tcm_fc/tfc_io.c, though too
late (they look a lot like my iscsi changes, it would have saved me some
time!).

While this is obviously not to be taken lightly, I disagree with making
this a per-fabric choice.  With a properly organized (and bisectable)
series, it should be relatively easy to review and to get right.  I
looked a bit more closely now and there are no changes needed to other
targets (actually there is a change needed in tcm_qla2xxx, but the code
is currently disabled).

There are however changes to transport_kmap_data_sg needed and a few
other places.

I definitely agree with your other comments, including making max_order
a DEF_DEV_ATTRIB.  In addition, the default max_order should be capped
based on queue_max_sectors(q) if applicable, to avoid hitting this scenario:

       /*
        * XXX: if the length the device accepts is shorter than the
        *      length of the S/G list entry this will cause and
        *      endless loop.  Better hope no driver uses huge pages.
        */

Paolo

>> While doing this, I noticed something strange in iscsit_do_crypto_hash_sg.
>> Patch 1 adds a warning about it.
>>
> 
> Mmmmm, looks like a separate bug with DataDigest enabled.  
> 
>> The approach may be completely wrong and it needs more testing anyway.
>> Please review!
>>
> 
> Adding my comments inline.
> 
> Thanks Paolo!
> 
> --nab
> 
>> Paolo
>>
>> Paolo Bonzini (3):
>>   tcm_iscsi: warn on incorrect precondition for iscsit_do_crypto_hash_sg
>>   tcm_iscsi: support multiple sizes in the scatterlist
>>   target: try satisfying memory requests with contiguous blocks
>>
>>  drivers/target/iscsi/iscsi_target.c      |  106 +++++++++++++++++++++++++-----
>>  drivers/target/iscsi/iscsi_target_core.h |    2 +-
>>  drivers/target/target_core_transport.c   |   58 ++++++++++++++---
>>  3 files changed, 138 insertions(+), 28 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe target-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

