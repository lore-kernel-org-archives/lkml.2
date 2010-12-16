Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0LPOPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:15:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49978 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LPOPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:15:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k6qchOOtBjitHVkDEPiBUBZv74AmXli6Aus4CPQ86hT45yvP7SCVwKtqnTvjUUgbv4
         3rcy7iSo/KqtfuAqLCQI0mQiaXmDLyzIVJKhYNw98LqbQuMlJFIjJ1EkxWrKyKA2CKcI
         SnKAhG5I+IVi4AOm7TzRASpU4/Chx+mRRRkzM=
MIME-Version: 1.0
In-Reply-To: <4D0A1C40.7060502@panasas.com>
References: <12853.1292353313@jrobl>
	<AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
	<4D08BF5D.1060509@panasas.com>
	<20101215.100055.226772943.davem@davemloft.net>
	<4D09E185.2040600@panasas.com>
	<AANLkTin3v0BLYAuuqTgEzKgSOpVg4GJaJCEds=2ePrBH@mail.gmail.com>
	<4D0A1C40.7060502@panasas.com>
Date: Fri, 17 Dec 2010 01:15:44 +1100
Message-ID: <AANLkTiksAkqrMtVDgxhm5s+jqMaKoUhbTaWsXfKJ9QOy@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: Nick Piggin <npiggin@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Miller <davem@davemloft.net>, hooanon05@yahoo.co.jp,
        npiggin@kernel.dk, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 1:03 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 12/16/2010 03:13 PM, Nick Piggin wrote:
> static inline int dentry_memcmp_long(const unsigned char *cs,
>                                const unsigned char *ct, ssize_t count)
> {
>        int ret;
>        const unsigned long *ls = (const unsigned long *)cs;
>        const unsigned long *lt = (const unsigned long *)ct;
>
>        while (count > 8) {
>                ret = (*cs != *ct);
>                if (ret)
>                        break;
>                cs++;
>                ct++;
>                count-=8;
>        }
>        if (count) {
>                unsigned long t = *ct & ((0xffffffffffffffff >> ((8 - count) * 8))
>                ret = (*cs != t)
>        }
>
>        return ret;
> }
>
> Same as yours but just to avoid the branch inside the loop
> and slightly smaller code.

That's true, it should make the branch more predictable too. Well,
maybe. I'm going to leave it as-is for now, but I would welcome any
test results or ideas for improvements.


> BTW: On some ARCHs ++foo is faster than foo++
>     and Also, is there a reason not to write the above loop as:
>
>     while(c-- && (ret = (*cs++ != *ct++)))
>                ;

gcc should turn it into the same thing these days. I prefer avoiding
expressions with side effects in control statements (other than a
simple counter).

Thanks,
Nick
