Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1HDRFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:05:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60903 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1HDRF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110804064436.GA16247@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-3-git-send-email-minipli@googlemail.com>
	<20110804064436.GA16247@gondor.apana.org.au>
Date: Thu, 4 Aug 2011 19:05:25 +0200
Message-ID: <CA+rthh_nx2bvM71M=AdUuhEpT7EbhB5DbwkT=5zNF7MO-TGyHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
From: Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 8:44 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Jul 24, 2011 at 07:53:14PM +0200, Mathias Krause wrote:
>>
>> With this algorithm I was able to increase the throughput of a single
>> IPsec link from 344 Mbit/s to 464 Mbit/s on a Core 2 Quad CPU using
>> the SSSE3 variant -- a speedup of +34.8%.
>
> Were you testing this on the transmit side or the receive side?

I was running an iperf test on two directly connected systems. Both sides
showed me those numbers (iperf server and client).

> As the IPsec receive code path usually runs in a softirq context,
> does this code have any effect there at all?

It does. Just have a look at how fpu_available() is implemented:

,-[ arch/x86/include/asm/i387.h ]
| static inline bool irq_fpu_usable(void)
| {
|     struct pt_regs *regs;
|
|     return !in_interrupt() || !(regs = get_irq_regs()) || \
|         user_mode(regs) || (read_cr0() & X86_CR0_TS);
| }
`----

So, it'll fail in softirq context when the softirq interrupted a kernel thread
or TS in CR0 is set. When it interrupted a userland thread that hasn't the TS
flag set in CR0, i.e. the CPU won't generate an exception when we use the FPU,
it'll work in softirq context, too.

With a busy userland making extensive use of the FPU it'll almost always have
to fall back to the generic implementation, right. However, using this module
on an IPsec gateway with no real userland at all, you get a nice performance
gain.

> This is pretty similar to the situation with the Intel AES code.
> Over there they solved it by using the asynchronous interface and
> deferring the processing to a work queue.
>
> This also avoids the situation where you have an FPU/SSE using
> process that also tries to transmit over IPsec thrashing the
> FPU state.

Interesting. I'll look into this.

> Now I'm still happy to take this because hashing is very different
> from ciphers in that some users tend to hash small amounts of data
> all the time.  Those users will typically use the shash interface
> that you provide here.
>
> So I'm interested to know how much of an improvement this is for
> those users (< 64 bytes).

Anything below 64 byte will i(and has to) be padded to a full block, i.e. 64
bytes.

> If you run the tcrypt speed tests that should provide some useful info.

I've summarized the mean values of five consecutive tcrypt runs from two
different systems. The first system is an Intel Core i7 2620M based notebook
running at 2.70 GHz. It's a Sandy Bridge processor so could make use of the
AVX variant. The second system was an Intel Core 2 Quad Xeon system running at
2.40 GHz -- no AVX, but SSSE3.

Since the output of tcrypt is a little awkward to read, I've condensed it
slightly to make it (hopefully) more readable. Please interpret the table as
follow: The triple in the first column is (byte blocks | bytes per update |
updates), c/B is cycles per byte.

Here are the numbers for the first system:

                               sha1-generic            sha1-ssse3 (AVX)
 (  16 |   16 |   1):     9.65 MiB/s, 266.2 c/B     12.93 MiB/s, 200.0 c/B
 (  64 |   16 |   4):    19.05 MiB/s, 140.2 c/B     25.27 MiB/s, 105.6 c/B
 (  64 |   64 |   1):    21.35 MiB/s, 119.2 c/B     29.29 MiB/s,  87.0 c/B
 ( 256 |   16 |  16):    28.81 MiB/s,  88.8 c/B     37.70 MiB/s,  68.4 c/B
 ( 256 |   64 |   4):    34.58 MiB/s,  74.0 c/B     47.16 MiB/s,  54.8 c/B
 ( 256 |  256 |   1):    37.44 MiB/s,  68.0 c/B     69.01 MiB/s,  36.8 c/B
 (1024 |   16 |  64):    33.55 MiB/s,  76.2 c/B     43.77 MiB/s,  59.0 c/B
 (1024 |  256 |   4):    45.12 MiB/s,  58.0 c/B     88.90 MiB/s,  28.8 c/B
 (1024 | 1024 |   1):    46.69 MiB/s,  54.0 c/B    104.39 MiB/s,  25.6 c/B
 (2048 |   16 | 128):    34.66 MiB/s,  74.0 c/B     44.93 MiB/s,  57.2 c/B
 (2048 |  256 |   8):    46.81 MiB/s,  54.0 c/B     93.83 MiB/s,  27.0 c/B
 (2048 | 1024 |   2):    48.28 MiB/s,  52.4 c/B    110.98 MiB/s,  23.0 c/B
 (2048 | 2048 |   1):    48.69 MiB/s,  52.0 c/B    114.26 MiB/s,  22.0 c/B
 (4096 |   16 | 256):    35.15 MiB/s,  72.6 c/B     45.53 MiB/s,  56.0 c/B
 (4096 |  256 |  16):    47.69 MiB/s,  53.0 c/B     96.46 MiB/s,  26.0 c/B
 (4096 | 1024 |   4):    49.24 MiB/s,  51.0 c/B    114.36 MiB/s,  22.0 c/B
 (4096 | 4096 |   1):    49.77 MiB/s,  51.0 c/B    119.80 MiB/s,  21.0 c/B
 (8192 |   16 | 512):    35.46 MiB/s,  72.2 c/B     45.84 MiB/s,  55.8 c/B
 (8192 |  256 |  32):    48.15 MiB/s,  53.0 c/B     97.83 MiB/s,  26.0 c/B
 (8192 | 1024 |   8):    49.73 MiB/s,  51.0 c/B    116.35 MiB/s,  22.0 c/B
 (8192 | 4096 |   2):    50.10 MiB/s,  50.8 c/B    121.66 MiB/s,  21.0 c/B
 (8192 | 8192 |   1):    50.25 MiB/s,  50.8 c/B    121.87 MiB/s,  21.0 c/B

For the second system I got the following numbers:

                               sha1-generic            sha1-ssse3 (SSSE3)
 (  16 |   16 |   1):    27.23 MiB/s, 106.6 c/B     32.86 MiB/s,  73.8 c/B
 (  64 |   16 |   4):    51.67 MiB/s,  54.0 c/B     61.90 MiB/s,  37.8 c/B
 (  64 |   64 |   1):    62.44 MiB/s,  44.2 c/B     74.16 MiB/s,  31.6 c/B
 ( 256 |   16 |  16):    77.27 MiB/s,  35.0 c/B     91.01 MiB/s,  25.0 c/B
 ( 256 |   64 |   4):   102.72 MiB/s,  26.4 c/B    125.17 MiB/s,  18.0 c/B
 ( 256 |  256 |   1):   113.77 MiB/s,  20.0 c/B    186.73 MiB/s,  12.0 c/B
 (1024 |   16 |  64):    89.81 MiB/s,  25.0 c/B    103.13 MiB/s,  22.0 c/B
 (1024 |  256 |   4):   139.14 MiB/s,  16.0 c/B    250.94 MiB/s,   9.0 c/B
 (1024 | 1024 |   1):   143.86 MiB/s,  15.0 c/B    300.98 MiB/s,   7.0 c/B
 (2048 |   16 | 128):    92.31 MiB/s,  24.0 c/B    105.45 MiB/s,  21.0 c/B
 (2048 |  256 |   8):   144.42 MiB/s,  15.0 c/B    265.21 MiB/s,   8.0 c/B
 (2048 | 1024 |   2):   149.57 MiB/s,  15.0 c/B    323.97 MiB/s,   7.0 c/B
 (2048 | 2048 |   1):   150.47 MiB/s,  15.0 c/B    335.87 MiB/s,   6.0 c/B
 (4096 |   16 | 256):    93.65 MiB/s,  24.0 c/B    106.73 MiB/s,  21.0 c/B
 (4096 |  256 |  16):   147.27 MiB/s,  15.0 c/B    273.01 MiB/s,   8.0 c/B
 (4096 | 1024 |   4):   152.61 MiB/s,  14.8 c/B    335.99 MiB/s,   6.0 c/B
 (4096 | 4096 |   1):   154.15 MiB/s,  14.0 c/B    356.67 MiB/s,   6.0 c/B
 (8192 |   16 | 512):    94.32 MiB/s,  24.0 c/B    107.34 MiB/s,  21.0 c/B
 (8192 |  256 |  32):   148.61 MiB/s,  15.0 c/B    277.13 MiB/s,   8.0 c/B
 (8192 | 1024 |   8):   154.21 MiB/s,  14.0 c/B    342.22 MiB/s,   6.0 c/B
 (8192 | 4096 |   2):   155.78 MiB/s,  14.0 c/B    364.05 MiB/s,   6.0 c/B
 (8192 | 8192 |   1):   155.82 MiB/s,  14.0 c/B    363.92 MiB/s,   6.0 c/B

Interestingly the Core 2 Quad still rocks out the shiny new Core i7. In any
case the sha1-ssse3 module was faster than sha1-generic -- as expected ;)

Mathias
