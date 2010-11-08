Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0KHIjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:39:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:50464 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0KHIjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="345820087"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Mon, 8 Nov 2010 16:39:04 +0800
Subject: RE: Re:[PATCH v14 06/17] Use callback to deal with
 skb_release_data() specially.
Thread-Topic: Re:[PATCH v14 06/17] Use callback to deal with
 skb_release_data() specially.
Thread-Index: Act/HmvBSTiY/7fyS5GA3ORaOZJIugAAa7Pw
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D79338D121C55@shsmsx502.ccr.corp.intel.com>
References: <1288861663.2659.47.camel@edumazet-laptop>
	 <1289203430-5935-1-git-send-email-xiaohui.xin@intel.com>
 <1289204686.2478.375.camel@edumazet-laptop>
In-Reply-To: <1289204686.2478.375.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>Sent: Monday, November 08, 2010 4:25 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; davem@davemloft.net; herbert@gondor.apana.org.au;
>jdike@linux.intel.com
>Subject: Re: Re:[PATCH v14 06/17] Use callback to deal with skb_release_data() specially.
>
>Le lundi 08 novembre 2010 à 16:03 +0800, xiaohui.xin@intel.com a écrit :
>> From: Xin Xiaohui <xiaohui.xin@intel.com>
>>
>> >> Hmm, I suggest you read the comment two lines above.
>> >>
>> >> If destructor_arg is now cleared each time we allocate a new skb, then,
>> >> please move it before dataref in shinfo structure, so that the following
>> >> memset() does the job efficiently...
>> >
>> >
>> >Something like :
>> >
>> >diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> >index e6ba898..2dca504 100644
>> >--- a/include/linux/skbuff.h
>> >+++ b/include/linux/skbuff.h
>> >@@ -195,6 +195,9 @@ struct skb_shared_info {
>> > 	__be32          ip6_frag_id;
>> > 	__u8		tx_flags;
>> > 	struct sk_buff	*frag_list;
>> >+	/* Intermediate layers must ensure that destructor_arg
>> >+	 * remains valid until skb destructor */
>> >+	void		*destructor_arg;
>> > 	struct skb_shared_hwtstamps hwtstamps;
>> >
>> > 	/*
>> >@@ -202,9 +205,6 @@ struct skb_shared_info {
>> > 	 */
>> > 	atomic_t	dataref;
>> >
>> >-	/* Intermediate layers must ensure that destructor_arg
>> >-	 * remains valid until skb destructor */
>> >-	void *		destructor_arg;
>> > 	/* must be last field, see pskb_expand_head() */
>> > 	skb_frag_t	frags[MAX_SKB_FRAGS];
>> > };
>> >
>> >
>>
>> Will that affect the cache line?
>
>What do you mean ?
>
>> Or, we can move the line to clear destructor_arg to the end of __alloc_skb().
>> It looks like as the following, which one do you prefer?
>>
>> Thanks
>> Xiaohui
>>
>> ---
>>  net/core/skbuff.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index c83b421..df852f2 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -224,6 +224,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>>
>>  		child->fclone = SKB_FCLONE_UNAVAILABLE;
>>  	}
>> +	shinfo->destructor_arg = NULL;
>>  out:
>>  	return skb;
>>  nodata:
>
>I dont understand why you want to do this.
>
>This adds an instruction, makes code bigger, and no obvious gain for me,
>at memory transactions side.
>
>If integrated in the existing memset(), cost is an extra iteration to
>perform the clear of this field.
>
Ok. Thanks for this explanation and will update with your solution.

Thanks
Xiaohui


