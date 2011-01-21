Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1AURHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:07:21 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34612 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882Ab1AURHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:07:21 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7juzENEVM1kKqCHyajVg1yfWHVLcfLVed1UIdyCJsZwa61n
 igTXmdOnp0fX4ciyFI2JVves4cqTCqWPaekWDC8h_hL_LuCjfeybQvjE0kxA
 E2MvKWzw25POJMepK6YNBdTa.ynax5p2lKgibhAQRH5TNpyloqMLHjgeOwuD
 BjSTfBDEbuOdsqnoA4vkxWUz5T9kxzjJtxFWaAWUiVp69RIDVuMlUPSviU4w
 kDVCiqcyk.d0-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:07:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110121165425.GB11687@Krystal>
Message-ID: <alpine.DEB.2.00.1101211101510.15418@router.home>
References: <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:

> I'm again probably missing something, but what is "clumsy" about defining a
> structure like the following to ensure proper alignment of the target
> pointer (instead of adding a runtime test) ?
>
> struct cmpxchg_double {
> #if __BYTE_ORDER == __LITTLE_ENDIAN
>         unsigned long low, high;
> #else
>         unsigned long high, low;
> #endif
> } __attribute__((packed, aligned(2 * sizeof(unsigned long))));
>
> (note: packed here along with "aligned" does _not_ generate ugly bytewise
> read/write memory ops like "packed" alone. The use of "packed" is to let the
> compiler down-align the structure to the value requested, instead of uselessly
> aligning it on 32-byte if it chooses to.)
>
> The prototype could then look like:
>
> bool __this_cpu_generic_cmpxchg_double(pcp, oval_low, oval_high, nval_low, nval_high);
>
> With:
>   struct cmpxchg_double *pcp

That does not conform to the parameter conventions in other this_cpu_ops.
The first parameter is a variable because the notion of a pointer is
problematic given that percpu operations use a segment prefix to relocate
pointers. You would be implicitly passing a 128 bit argument although the
compiler may not need to generate code for that.

> I think Christoph's point is that he wants to alias this with a pointer. Well,
> this can be done cleanly with:
>
> union {
>         struct cmpxchg_double casdbl;
>         struct {
>                 void *ptr;
>                 unsigned long cpuid_tid;
>         } t;
> }

There is no need for aliases with the existing implementation.

How will the macro check the parameters now?

> Thoughts ?

Could you actually try to write a patch instead running through points
that we have discussed earlier?
