Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2KVUoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:44:34 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2KVUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:30 -0500
Message-ID: <1353591668.9806.42.camel@jlt4.sipsolutions.net>
Subject: Re: [POC] recoverable fault injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 14:41:08 +0100
In-Reply-To: <CAC5umyj07UmPtoFowqquoOBERaVa4KngJ=cOa8_AgkcJ_EksSw@mail.gmail.com> (sfid-20121122_142945_571324_3A28FF80)
References: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
	 <CAC5umyibe0tb+HLxx3dbT7gF_nVAAHso1Y0Qb4Q_+y0KNrnvFg@mail.gmail.com>
	 <1353585161.9806.37.camel@jlt4.sipsolutions.net>
	 <CAC5umyj07UmPtoFowqquoOBERaVa4KngJ=cOa8_AgkcJ_EksSw@mail.gmail.com>
	 (sfid-20121122_142945_571324_3A28FF80)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 22:29 +0900, Akinobu Mita wrote:

> > As you can see in my macro, it's also possible for an allocation to fail
> > but the function to succeed, so the function that is called must have a
> > return value indicating success or failure. I ran into this with debug
> > objects, their allocation failed all the time but obviously the function
> > succeeded as debug objects fail gracefully if they can't allocate
> > memory.
> 
> Oh, I completely missed retrying part in your macro.
> 
> I looked into FAULT_INJECT_CALL_RECOVERABLE_FUNCTION again,
> then I realized that it is not necessary to be variadic macro.
> 
> You can define macro like wait_event() family and use it like below:
> 
>         return FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(
>                 BIT(FAULT_ATTR_SLAB) | BIT(FAULT_ATTR_PAGE_ALLOC),
>                 _nl80211_remain_on_channel(skb, info));

Oh, right, good point. Maybe even pass the entire line, and the
evaluation of whether the function failed. Then we don't have to have
the assumption of it returning an int with the 0/-ERR behaviour:

int ret;

FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(
	BIT(FAULT_ATTR_SLAB) | BIT(FAULT_ATTR_PAGE_ALLOC),
	ret = _nl80211_remain_on_channel(skb, info),
	ret != 0);

return ret;


Ok that's kinda ugly too ... hmm.

johannes

