Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2C1U0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:26:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59396 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab2C1U02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <1332965129.2325.12.camel@edumazet-glaptop>
References: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
	<1332965129.2325.12.camel@edumazet-glaptop>
Date: Wed, 28 Mar 2012 22:26:26 +0200
Message-ID: <CAPwCz7_tnjq32duJSDj21LpRe5TFvGGszH4joQr1DGTjNd7GcA@mail.gmail.com>
Subject: Re: [REGRESSION][PATCH] bpf_jit drops the ball on indirect negative
 mem references
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Matt Evans <matt@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/28 Eric Dumazet <eric.dumazet@gmail.com>:
> On Wed, 2012-03-28 at 21:15 +0200, Jan Seiffert wrote:
>> Consider the following test program:
>>
>> #include <stdio.h>
>> #include <sys/types.h>
>> #include <sys/socket.h>
>> #include <netinet/in.h>
>> #include <pcap-bpf.h>
>>
>> #define die(x) do {perror(x); return 1;} while (0)
>> struct bpf_insn udp_filter[] = {
>>       /*   0 */ BPF_STMT(BPF_LDX|BPF_W|BPF_IMM, -1048576+(0)), /* leax        net[0] */
>>       /*   1 */ BPF_STMT(BPF_LD|BPF_B|BPF_IND, 0),             /* ldb [x+0] */
>>       /*   2 */ BPF_STMT(BPF_RET|BPF_A, 0),                    /* ret a */
>> };
>
> When this point was raised some weeks ago, we wanted to see a _real_ use
> of negative mem reference.
>
> You provide a test program but what this filter is supposed to do
> exactly ?
>

Say you have a UDP socket, and you want to filter for bogus source
addresses (drop already in kernel to save the context switch).
To have only one bpf program for ipv4 and ipv6 (you have to checked
the same bogus v4 addresses in mapped space), there is a point where
it elegant to have a negative offset saved in the X register.
This is how i found the Bug.

But use case or not, the jits behavior is different than the interpreter.

Example (not the complete program):

struct bpf_insn UDPPValid[] = {
        /*   0 */ BPF_STMT(BPF_LDX|BPF_W|BPF_IMM, -1048576+(12)),
        /*   1 */ BPF_STMT(BPF_LD|BPF_B|BPF_ABS, -1048576+(0)),
        /*   2 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xf0),
        /*   3 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x40, 22 - 4, 0),
        /*   4 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x60, 5 - 5, 39 - 5),
        /*   5 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0, 12 - 6, 0),
        /*   6 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x20010DB8, 39 - 7, 0),
        /*   7 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x20010002, 18 - 8, 0),
        /*   8 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xfffffff0),
        /*   9 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x20010010, 39 - 10, 0),
        /*  10 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xff000000),
        /*  11 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xff000000, 39 - 12, 37 - 12),
        /*  12 */ BPF_STMT(BPF_LD|BPF_W|BPF_ABS, -1048576+(12)),
        /*  13 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0, 0, 37 - 14),
        /*  14 */ BPF_STMT(BPF_LD|BPF_W|BPF_ABS, -1048576+(16)),
        /*  15 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xffff, 21 - 16, 0),
        /*  16 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x0064FF9B, 21 - 17, 0),
        /*  17 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0, 39 - 18, 37 -
18),
        /*  18 */ BPF_STMT(BPF_LD|BPF_W|BPF_ABS, -1048576+(12)),
        /*  19 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xffff0000),
        /*  20 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0, 39 - 21, 37 -
21),
        /*  21 */ BPF_STMT(BPF_LDX|BPF_W|BPF_IMM, -1048576+(20)),
        /*  22 */ BPF_STMT(BPF_LD|BPF_W|BPF_IND, 0),
        /*  23 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xffffffff, 39 - 24,
0),
        /*  24 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xffffff00),
        /*  25 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xC0000000, 39 - 26,
0),
        /*  26 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xC0000200, 39 - 27,
0),
        /*  27 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xC6336400, 39 - 28,
0),
        /*  28 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xCB007100, 39 - 29,
0),
        /*  29 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xC0586300, 39 - 30,
0),
        /*  30 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xfffe0000),
        /*  31 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xC6120000, 39 - 32,
0),
        /*  32 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xff000000),
        /*  33 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0, 39 - 34, 0),
        /*  34 */ BPF_STMT(BPF_ALU|BPF_AND|BPF_K, 0xf0000000),
        /*  35 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xE0000000, 39 - 36,
0),
        /*  36 */ BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0xF0000000, 39 - 37,
0),
        /*  37 */ BPF_STMT(BPF_LD|BPF_W|BPF_LEN, 0),
        /*  38 */ BPF_STMT(BPF_RET|BPF_A, 0),
        /*  39 */ BPF_STMT(BPF_RET|BPF_K, 0),
};

>
>

Greetings
Jan

-- 
˙qɐɥ ʇɟnɐʞǝƃ ʎɐqǝ ıǝq ɹnʇɐʇsɐʇ ǝuıǝ ɹıɯ ɥɔı sɐp lɐɯ ǝʇzʇǝl sɐp ʇsı sɐp
'ʇɯɯɐpɹǝʌ
