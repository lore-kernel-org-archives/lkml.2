Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0FGIRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:17:11 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:56871 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932445Ab0FGIRJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:17:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=USCg2Bhjk52PspP2xZ2Hv9Cq6SJmA0aZWYN0/D0rqXbVOFZCiP+Z5asHfrbMrpEO;
  h=Received:Subject:Mime-Version:Content-Type:From:In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:To:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <87pr03gu1c.fsf@basil.nowhere.org>
Date: Mon, 7 Jun 2010 01:17:02 -0700
Cc: Stephen Hemminger <shemminger@vyatta.com>, xiaohui.xin@intel.com,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
       davem@davemloft.net, herbert@gondor.hengli.com.au,
       jdike@linux.intel.com
Content-Transfer-Encoding: 8BIT
Message-Id: <40119F5E-A745-4C50-8053-D5A701266AD5@earthlink.net>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com> <20100606161348.427822fb@nehalam> <87pr03gu1c.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.1078)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec791667d7d306784d9e723f07d9cd48c714350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.202.111.27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2010, at 12:51 AM, Andi Kleen wrote:

> Stephen Hemminger <shemminger@vyatta.com> writes:
> 
>> Still not sure this is a good idea for a couple of reasons:
>> 
>> 1. We already have lots of special cases with skb's (frags and fraglist),
>>   and skb's travel through a lot of different parts of the kernel.  So any
>>   new change like this creates lots of exposed points for new bugs. Look
>>   at cases like MD5 TCP and netfilter, and forwarding these SKB's to ipsec
>>   and ppp and ...
>> 
>> 2. SKB's can have infinite lifetime in the kernel. If these buffers come from
>>   a fixed size pool in an external device, they can easily all get tied up
>>   if you have a slow listener. What happens then?
> 
> 3. If they come from an internal pool what happens when the kernel runs 
> low on memory? How is that pool balanced against other kernel
> memory users?
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

In general,

When an internal pool is created/used, their SHOULD be a reason.
Maybe, to keep allocation latency to a min, OR ...

Now IMO, 

internal pool objects should have a ref count and
if that count is 0, then under memory pressure and/or num 
of objects are above a high water mark, then they are freed,

OR if there is a last reference age field, then the object is to be 
cleaned if dirty, then freed,  

Else, the pool is allowed to grow if the number of objects in the
pool is below a set max (max COULD equal Infinity).



Mitchell Erblich