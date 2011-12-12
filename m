Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LLLT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:19:26 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53400 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LLLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111211155347.GA1297@elte.hu>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
Date: Mon, 12 Dec 2011 13:19:15 +0200
X-Google-Sender-Auth: _u7SH5DnDkN7CTKpUlaTwXlBBho
Message-ID: <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 5:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Okay, but look at it from another angle: the top output i
> generate is about 300k characters. 5000 msecs to execute it
> means 16 usecs overhead per character - or about 50k cycles - on
> a top of the class x86 CPU.

I'm seeing 1.5 usecs per character for this little benchmark:

$ cat tick.S
#define DBG_PORT	0xe0
	.code16gcc
	.text
	.globl	_start
	.type	_start, @function
_start:
	mov	$0x64,%cx
	mov	$0xffff,%bx

outer_loop:
inner_loop:
	mov	$0x3f8,%dx
	mov	$0x2e, %al	# .
	out	%al,%dx

	sub	$0x1,%bx
	jne	inner_loop
	
	sub	$0x1,%cx
	jne	outer_loop

	/* not a valid port to force exit */
	outb	%al, $DBG_PORT

$ gcc -nostdinc -c tick.S -o tick.o
$ ld -Ttext=0x00 -nostdlib -static tick.o -o tick.elf
$ objcopy -O binary tick.elf tick.bin
$ perf stat ./vm run ./tests/serial/tick.bin > /dev/null
  Warning: ./tests/serial/tick.bin is not a bzImage. Trying to load it
as a flat binary...

 Performance counter stats for './vm run ./tests/serial/tick.bin':

       9984.468850 task-clock                #    0.995 CPUs utilized
            16,597 context-switches          #    0.002 M/sec
                46 CPU-migrations            #    0.000 M/sec
             1,200 page-faults               #    0.000 M/sec
    32,500,683,485 cycles                    #    3.255 GHz
         [82.17%]
    14,986,643,686 stalled-cycles-frontend   #   46.11% frontend
cycles idle    [83.57%]
     9,400,515,530 stalled-cycles-backend    #   28.92% backend
cycles idle    [67.11%]
    25,213,133,751 instructions              #    0.78  insns per cycle
                                             #    0.59  stalled cycles
per insn [83.57%]
     5,111,389,696 branches                  #  511.934 M/sec
         [83.57%]
        14,565,759 branch-misses             #    0.28% of all
branches         [83.58%]

      10.030175553 seconds time elapsed
