Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0HZDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:09:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38668 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0HZDJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HLSC9O0tY3jxU06xOmjN+SWJGMg1EP9fs7rgLCx3nB/UHpJI+nnrwNeRh/ntIooA2i
         mU/yzKFtW03Q6DlYpHOnRc3Z1F+ecnUu947GrcTkf83552hAtVBkNn23ITHG6AO3jEpK
         pf2jSUOq8rzfGtLyQPUXNaGNSj2K14De2Sdts=
MIME-Version: 1.0
In-Reply-To: <20100825.153424.246521475.davem@davemloft.net>
References: <20100825110049.F3C9.A69D9226@jp.fujitsu.com>
	<20100825.153424.246521475.davem@davemloft.net>
Date: Thu, 26 Aug 2010 12:09:55 +0900
X-Google-Sender-Auth: sQ_6CeFS01eDKIguZyKk9VxyIhM
Message-ID: <AANLkTinPhzMSQ01AXZmDQw8h4OnuS8yoQu7eKog637LL@mail.gmail.com>
Subject: Re: [PATCH] tcp: select(writefds) don't hang up when a peer close connection
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for quick responce!


>> SUS defined 'ready for writing' of select() as following.
>>
>> |  A descriptor shall be considered ready for writing when a call to an output
>> |  function with O_NONBLOCK clear would not block, whether or not the function
>> |  would transfer data successfully.
>>
>> That said, EPIPE situation is clearly one of 'ready for writing'.
>
> How Linux should behave is defined by many things, and often it is
> simply defined by how we've behaved for a very long time.  This is
> because changing behavior can often break as many applications as it
> can fix.  Standards don't necessarily tell us how we must behave,
> since often is it impractical to follow their definions.
>
> And in this case here, I call into question the behavior of Ruby and
> the application from two perspectives:
>
> 1) Unlike all of the other conditions signalled by poll() this is
>   one the application explicitly created and therefore knows about.
>
>   If the application calls close() or shutdown() with the send flag
>   set, IT KNOWS what is going to happen on a write() attempt.

Umm??

Probably my example is not so good. That's not my point.
In the example application, client and server socket is in the same process.
But it's NOT generic. usually, client and server are another process. then,
client can't expect when server close socket.

The most big matter is, this is can't be avoided in userland. In addition,
EVERY application don't want application hang up. we don't hesitate
userland change.

> 2) Ruby and this script will have to deal with the past 13 years
>   worth of Linux kernels.  Even if I were to apply this fix now
>   it is not going to propagate onto a user's system any time soon.
>
>   Many systems would never ever get this fix.
>
>   Therefore it behooves Ruby and this script to make a very reasonable
>   change, which is to track when close() or send shutdown() calls occur
>   and behave appropriately on a write() call.
>
> I'm therefore not applying this patch, because not only can applications
> handle this properly with information they already have, the change has
> the potential to break applications.

At first, I was thinking two fix plan.
 1) this patch
 2) adding POLLWRHUP as POLLRDHUP.

However I couldn't find any regression rick in (1). then I did choice (1).

So, Can you please tell us what rick you worry? My thinking is, If
select(writefds)
returned, an application naturally call to write. (why not? If not,
why do you call select?)
and write return EPIPE. every network application have EPIPE error checking.

But, there is any rick. I can remake a patch as (2).

Thanks.
