Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0FIHbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:31:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:26444 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab0FIHbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:31:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,389,1272870000"; 
   d="scan'208";a="286753071"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 9 Jun 2010 15:30:37 +0800
Subject: RE: [RFC PATCH v7 11/19] Use callback to deal with
 skb_release_data() specially.
Thread-Topic: [RFC PATCH v7 11/19] Use callback to deal with
 skb_release_data() specially.
Thread-Index: AcsEv1zsEy3/uOyoS2OIkT/IYr0aZwC5FrUg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D791100848EA1@shsmsx502.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-4-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-6-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-7-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-8-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-9-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-10-git-send-email-xiaohui.xin@intel.com>
	 <1275732899-5423-11-git-send-email-xiaohui.xin@intel.com>
 <1275749773.5238.244.camel@edumazet-laptop>
In-Reply-To: <1275749773.5238.244.camel@edumazet-laptop>
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
>Sent: Saturday, June 05, 2010 10:56 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; davem@davemloft.net; herbert@gondor.apana.org.au;
>jdike@linux.intel.com
>Subject: Re: [RFC PATCH v7 11/19] Use callback to deal with skb_release_data() specially.
>
>Le samedi 05 juin 2010 à 18:14 +0800, xiaohui.xin@intel.com a écrit :
>> From: Xin Xiaohui <xiaohui.xin@intel.com>
>>
>> If buffer is external, then use the callback to destruct
>> buffers.
>>
>> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
>> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
>> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
>> ---
>>  net/core/skbuff.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 37587f0..418457c 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -385,6 +385,11 @@ static void skb_clone_fraglist(struct sk_buff *skb)
>>
>>  static void skb_release_data(struct sk_buff *skb)
>>  {
>> +	/* check if the skb has external buffers, we have use destructor_arg
>> +	 * here to indicate
>> +	 */
>> +	struct skb_external_page *ext_page = skb_shinfo(skb)->destructor_arg;
>> +
>
>Oh well. This is v7 of your series, and nobody complained yet ?
>
>This is a new cache miss on a _critical_ path.

Ok, I would remove the declaration here to avoid the new cache miss.

>
>
>>  	if (!skb->cloned ||
>>  	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>>  			       &skb_shinfo(skb)->dataref)) {
>> @@ -397,6 +402,12 @@ static void skb_release_data(struct sk_buff *skb)
>>  		if (skb_has_frags(skb))
>>  			skb_drop_fraglist(skb);
>>
>> +		/* if the skb has external buffers, use destructor here,
>> +		 * since after that skb->head will be kfree, in case skb->head
>> +		 * from external buffer cannot use kfree to destroy.
>> +		 */
>
>Why not deferring here the access to skb_shinfo(skb)->destructor_arg ?

And references skb_shinfo(skb)->destructor_arg here.

>
>> +		if (dev_is_mpassthru(skb->dev) && ext_page && ext_page->dtor)
>> +			ext_page->dtor(ext_page);
>>  		kfree(skb->head);
>>  	}
>>  }
>
>if (dev_is_mpassthru(skb->dev)) {
>	struct skb_external_page *ext_page =
>				skb_shinfo(skb)->destructor_arg;
>	if (ext_page && ext_page->dtor)
>		ext_page->dtor(ext_page);
>}
>
>destructor_arg should me moved before frags[] if you really want to use it.

Thanks for the patch. But why destructor_arg before frags[] is better than after frags[]?
skb_release_data() will reference both of them........

>
>diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>index bf243fc..b136d90 100644
>--- a/include/linux/skbuff.h
>+++ b/include/linux/skbuff.h
>@@ -202,10 +202,11 @@ struct skb_shared_info {
>         */
>        atomic_t        dataref;
>
>-       skb_frag_t      frags[MAX_SKB_FRAGS];
>        /* Intermediate layers must ensure that destructor_arg
>         * remains valid until skb destructor */
>        void *          destructor_arg;
>+
>+       skb_frag_t      frags[MAX_SKB_FRAGS];
> };
>
> /* We divide dataref into two halves.  The higher 16 bits hold references
>
>

