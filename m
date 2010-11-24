Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0KXQhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:37:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52330 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0KXQht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iqArTUiWFxLQaHPJ8za9D0+uwxNuoKJ3fyi0c5TbSdtBvxzHMJccoxoCPkrrFQ8mWP
         88e5fyfINldC4zhDpqXcFweXhORbK55gLlVFbZjQHNzkKXknBMN4i2iQIeeHlUeXwlU9
         a4LJosvBwE+ngQTQ739BQ+F4bqzIMhsTF78fU=
MIME-Version: 1.0
In-Reply-To: <4CED1C87.7010500@tilera.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	<4CDF1945.8090101@tilera.com>
	<AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	<201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com>
	<AANLkTikGj+zG9OqVJseKh4fGqQNnqnJpHgcaaXOL8nNi@mail.gmail.com>
	<4CEA71AD.5010606@tilera.com>
	<AANLkTim1YyujwGZfenU_m52HEJJSFmTg3Wswn2DkqA3a@mail.gmail.com>
	<4CEC2BE7.4060205@tilera.com>
	<AANLkTinx3pcJHGrQq_C-Rgk5g7SxjmpTcD0A50d8d48b@mail.gmail.com>
	<4CED1C87.7010500@tilera.com>
Date: Thu, 25 Nov 2010 00:37:48 +0800
Message-ID: <AANLkTi=eXuRYK=JOx=JQ6fBFB4Hr2ajuO5So42nQm_za@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: fix rwlock so would-be write lockers don't
 block new readers
From: Cypher Wu <cypher.w@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Chris Metcalf <cmetcalf@tilera.com>:
> On 11/23/2010 9:53 PM, Cypher Wu wrote:
>> 2010/11/24 Chris Metcalf <cmetcalf@tilera.com>:
>>> On 11/22/2010 8:36 PM, Cypher Wu wrote:
>>>> Say, if core A try to write_lock() rwlock and current_ticket_ is 0 and
>>>> it write next_ticket_ to 1, when it processing the lock, core B try to
>>>> write_lock() again and write next_ticket_ to 2, then when A
>>>> write_unlock() it seen that (current_ticket_+1) is not equal to
>>>> next_ticket_, so it increment current_ticket_, and core B get the
>>>> lock. If core A try write_lock again before core B write_unlock, it
>>>> will increment next_ticket_ to 3. And so on.
>>>> This may rarely happened, I've tested it yesterday for several hours
>>>> it goes very well under pressure.
>>> This should be OK when it happens (other than starving out the readers, but
>>> that was the decision made by doing a ticket lock in the first place).
>>> Even if we wrap around 255 back to zero on the tickets, the ticket queue
>>> will work correctly.  The key is not to need more than 256 concurrent write
>>> lock waiters, which we don't.
>> If we count on that, should we make 'my_ticket_ = (val >>
>> WR_NEXT_SHIFT) & WR_MASK;'
>
> No, it's OK.  As the comment for the declaration of "my_ticket_" says, the
> trailing underscore reminds us that the high bits are garbage, and when we
> use the value, we do the mask: "((my_ticket_ - curr_) & WR_MASK)".  It
> turned out doing the mask here made the most sense from a code-generation
> point of view, partly just because of the possibility of the counter wrapping.
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
>

If wrap does occurr direct subtraction may cause problem, but
write_lock() is usually only lock very little code, and since two
issue of that call will take us so many cycles that one the same core
the time eslapsed will be enough that wrap will never occurr.


-- 
Cyberman Wu
http://www.meganovo.com
