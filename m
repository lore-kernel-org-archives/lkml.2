Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2KVTOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:14:44 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46513 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2KVTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:41 -0500
MIME-Version: 1.0
In-Reply-To: <1353585161.9806.37.camel@jlt4.sipsolutions.net>
References: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
	<CAC5umyibe0tb+HLxx3dbT7gF_nVAAHso1Y0Qb4Q_+y0KNrnvFg@mail.gmail.com>
	<1353585161.9806.37.camel@jlt4.sipsolutions.net>
Date: Thu, 22 Nov 2012 22:29:42 +0900
Message-ID: <CAC5umyj07UmPtoFowqquoOBERaVa4KngJ=cOa8_AgkcJ_EksSw@mail.gmail.com>
Subject: Re: [POC] recoverable fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/22 Johannes Berg <johannes@sipsolutions.net>:

> I thought about something like that, I actually initially played with
> macros like this:
>
> #define FAULT_RECOVERABLE_START(ids)    \
>         /* set up the task state */     \
>  fault_recovery_retry:
>
> #define FAULT_RECOVERABLE_END(ids)      \
>         if (current->encountered_fault) \
>                 goto fault_recovery_retry;
>
> or so. However, the problem is that if you exit the function between
> these points, and this is true for your functions as well, you leave the
> task's fault injection enabled which isn't what you want. So adding
> functions or macros like this didn't really seem right. Also, functions
> (rather than macros) have the problem that the retry can't be
> encapsulated -- note how my macro calls the function again if it failed.
> So with functions like that, you introduce new manually-coded error and
> retry paths, that seemed undesirable.
>
> As you can see in my macro, it's also possible for an allocation to fail
> but the function to succeed, so the function that is called must have a
> return value indicating success or failure. I ran into this with debug
> objects, their allocation failed all the time but obviously the function
> succeeded as debug objects fail gracefully if they can't allocate
> memory.

Oh, I completely missed retrying part in your macro.

I looked into FAULT_INJECT_CALL_RECOVERABLE_FUNCTION again,
then I realized that it is not necessary to be variadic macro.

You can define macro like wait_event() family and use it like below:

        return FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(
                BIT(FAULT_ATTR_SLAB) | BIT(FAULT_ATTR_PAGE_ALLOC),
                _nl80211_remain_on_channel(skb, info));
