Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0LPKR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:17:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64101 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0LPKR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gS/mh+fcF/jJevTECNIuTyjnNBFs6qerZipZN/35ijH1u9/GfcNxGDT+8DyS4j4Ou8
         DpiohXrmJwf91U09V0kFLynjC4C4eFw4YUf0JxylsiOJE/Rr519OwBrnhn6upi3Y46oD
         e457Pe4EqAKvYNwS7wOV1Yy6VH5Yw+uaiTbB4=
MIME-Version: 1.0
In-Reply-To: <buowrnakze2.fsf@dhlpc061.dev.necel.com>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
	<20101215125626.25f7d648.akpm@linux-foundation.org>
	<4D092D15.7030700@zytor.com>
	<AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
	<4D093580.9000303@zytor.com>
	<buowrnakze2.fsf@dhlpc061.dev.necel.com>
Date: Thu, 16 Dec 2010 11:17:25 +0100
Message-ID: <AANLkTim+cbxPxgS+13anHQRdN42uLci6z48hbiyWFdaV@mail.gmail.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Miles Bader <miles@gnu.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 7:25 AM, Miles Bader <miles@gnu.org> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>> In this case it this_cpu_*_test_bit() return an int, but they act as a
>>> bool and are used in if()s; where is the catch?
>>
>> If they aren't, and are stored in a variable for whatever reason, then
>> the || form will generate additional instructions to booleanize the
>> value for no good reason.
>
> It doesn't actually have to "booleanize" the value if it's used in a
> boolean context though (and, AFAICT, usually won't).
>
> My vague impression is that when used in a boolean context, gcc will
> often generate the same or "equivalent" code for both variants -- but
> sometimes a||b seems to generate better code; e.g.:
>
>   static inline int test1a (int a, int b) { return a ? 1 : b; }
>   int test1b (int a, int b) { if (test1a (a,b)) return a+b; else return 37; }
>
>   static inline int test2a (int a, int b) { return a || b; }
>   int test2b (int a, int b) { if (test2a (a,b)) return a+b; else return 37; }
>

I think hpa was talking about some code where gcc can not optimize out
the assignment (e.g. volatile, complex code, using the int outside
conditional expressions, etc.).

>=>
>
> test1b:
>        testl   %edi, %edi
>        jne     .L2
>        movl    $37, %eax
>        testl   %esi, %esi
>        jne     .L2
>        rep
>        ret
> .L2:
>        leal    (%rsi,%rdi), %eax
>        ret
>
> test2b:
>        leal    (%rsi,%rdi), %edx
>        movl    $37, %eax
>        orl     %edi, %esi
>        cmovne  %edx, %eax
>        ret
>
>        .ident  "GCC: (Debian 4.5.1-8) 4.5.1"
>
>
> -Miles
>
> --
> Is it true that nothing can be known?  If so how do we know this?  -Woody Allen
>
