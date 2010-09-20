Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0ITPE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:04:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab0ITPE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IcIobix3+DNnpee6cj6Uyb7bFhMsz90i5iW4mZkl5yK/DBGiHkNFeZ8K+XF1HZBCze
         wgPfBwOTHsgsT3Z2mirvVdD4yF8CIarHd0AP+xKSHtF4eG6btMXybI2NGOywQ5c2p3X8
         U3F4Ier4dLowgezLtDSA7Ay/XFVtBj9wZF0IM=
MIME-Version: 1.0
In-Reply-To: <4C91B6BE.8020300@trash.net>
References: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com> <4C91B6BE.8020300@trash.net>
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, 20 Sep 2010 23:04:33 +0800
Message-ID: <AANLkTikZeFrS9pj6jxmOxqY6dsaAf1U+FAXe5jNwQ-nV@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] netfilter: save the hash of the tuple in the
 original direction for latter use
To: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 2:18 PM, Patrick McHardy <kaber@trash.net> wrote:
> On 21.08.2010 00:49, Changli Gao wrote:
>> Since we don't change the tuple in the original direction, we can save it
>> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
>> use.
>
> I like this idea. We could actually do the same for the reply tuple
> and invalidate the saved hash in case the reply tuple is changed
> (nf_conntrack_alter_reply()), which only happens when NAT is used.
>

We can't do that, as the unconfirmed ct owned maybe dropped, and
pre-computing will wast CPU cycles in this case.

>> __hash_conntrack() is split into two steps: ____hash_conntrack() is used
>> to get the raw hash, and __hash_bucket() is used to get the bucket id.
>
> This patch uses underscores a bit excessively, how about renaming:
>
> - ____hash_conntrack() => hash_conntrack_raw()
> - __hash variables => hash
> - hash variables => bucket

OK. Thanks.

>
>> @@ -408,7 +438,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>>               return NF_ACCEPT;
>>
>>       zone = nf_ct_zone(ct);
>> -     hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>> +     /* reuse the __hash saved before */
>> +     hash = hash_bucket(*(unsigned long *)&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev, net);
>
> Please try to stay at least close to the 80 characters limit.
>

OK. Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
