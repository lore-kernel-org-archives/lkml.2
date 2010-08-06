Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348Ab0HFD7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:59:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0HFD7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=bV92YXbgcr1PUdZnzYOT/CPLv2sUQQgLyperjqFJCemEj1IYU+OtjBbd4gw2bsOv8m
         aFjR/EkkXpHCmbz8VnXOb3ENd4qnIWDHCAE/PmK9D4J1ffpSp0Yxko6oglAiTenQCPw1
         U9RpgH2eVUuRMi4b2Uye+hLxIh/IjiJ9Ffdwg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/3] lib: vsprintf: optimised put_dec_trunc() and put_dec_full()
Date: Fri, 6 Aug 2010 05:58:58 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
In-Reply-To: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008060558.59019.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
> The put_dec_trunc() and put_dec_full() functions were based on
> a code optimised for processors with 8-bit ALU but even then
> they failed to satisfy the same constraints

"Failed"? Interesting wording. Yes, the code won't map easily
onto 8-bit ALU, for the simple reason Linux kernel
does not support any 8-bit CPUs, and by going to wider register
I was able to process 5 decimal digits at once, not 4.
It was done deliberately. It is not a "failure".

Your code isn't 8-bit ALU optimized either.

Do you think a bit of smear of previous code
would help your to be accepted?

> and in fact 
> required at least 16-bit ALU (because at least one number they
> operate in can take 9 bits).

Yes, as explained above.

> This version of those functions proposed by this patch goes
> further and uses the full capacity of a 32-bit ALU and instead
> of splitting the number into nibbles and operating on them it
> performs the obvious algorithm for base conversion expect it
> uses optimised code for dividing by ten (ie. no division is
> actually performed).

(1) "expect" is a typo
(2) No, _this_ patch does not eliminate division. Next one does.
Move this part of changelong to the next patch, where it belongs.


> + * Decimal conversion is by far the most typical, and is used for
> + * /proc and /sys data. This directly impacts e.g. top performance
> + * with many processes running.
> + *
> + * We optimize it for speed using ideas described at
> + * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.

Do you have author's permission to do it?
Document it in the comment please.


> + * '(num * 0xcccd) >> 19' is an approximation of 'num / 10' that gives
> + * correct results for num < 81920.  Because of this, we check at the
> + * beginning if we are dealing with a number that may cause trouble
> + * and if so, we make it smaller.

This comment needs to be moved to the code line where the opration
is performed.


> + * (As a minor note, all operands are always 16 bit so this function
> + * should work well on hardware that cannot multiply 32 bit numbers).
> + *
> + * (Previous a code based on

English is a bit broken in the line above.


-- 
vda
