Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1FSA4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 20:56:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1FSA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 20:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A88tmte1REcUa/vM1+HIfGsd48irBUWCVpYiyaZ7BoRs282Zpzb2MetbuYqDMq7Yit
         MXIQ+swI7rmcY6JA0fnkIEg6Waa/8p+qPtzQK/+oP8EtgOiC8m6WfP4TDOMvg5dLxZwl
         yfP6q7Qt1ybcqvjvrA8v5+bWn/kEMpc30iWBs=
Subject: Re: tracing kernel panics
From: Calvin Owens <jcalvinowens@gmail.com>
To: Shane <software.research.development@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
References: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jun 2011 19:56:25 -0500
Message-ID: <1308444985.2268.16.camel@Mozart>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-18 at 19:12 -0500, Shane wrote:
> [  330.829809] Pid: 0, comm: swapper Not tainted 2.6.36-gentoo-r5 #8 /Bochs
> [  330.829809] RIP: 0010:[<ffffffff8148c3f3>]  [<ffffffff8148c3f3>]
> fib_table_lookup+0x48/0x9e
> [  330.829809] RSP: 0018:ffff880001e038f0  EFLAGS: 00010246
> [  330.829809] RAX: 0000000000000000 RBX: ffff88001f1edac0 RCX: 0000000000000018
> [  330.829809] RDX: 00000000000000c0 RSI: ffff88001f1edac0 RDI: 00000000000000c0
> [  330.829809] RBP: ffff880001e03920 R08: ffffffff81c48a10 R09: ffff880001e03b48
> [  330.829809] R10: 000000001564a8c0 R11: 00000000fe64a8c0 R12: 0001e00000010100
> [  330.829809] R13: 000000001e0488c0 R14: ffff880001e039f0 R15: ffff880001e03a30
> [  330.829809] FS:  0000000000000000(0000) GS:ffff880001e00000(0000)
> [  330.829809] Code: 14 ae aa 81 e8 86 89 0c 00 48 8b 9b 20 01 00 00
> eb 52 44 8b 6b 20 4c 8b 63 08 45 23 6e 0c 48 89 de 44 89 ef e8 9f f7
> ff ff 89 c0 <4d> 8b 24 c4 eb 1b 8b 4b 1c 49 8d 7c 24 10 4c 89 fa 4c 89
> f6 e8
> [  330.829809] RIP  [<ffffffff8148c3f3>] fib_table_lookup+0x48/0x9e
> [  330.829809]  RSP <ffff880001e038f0>

The first panic disassembles as:

        00000000  14AE              adc al,0xae
        00000002  AA                stosb
        00000003  81E886890C00      sub eax,0xc8986
        00000009  488B9B20010000    mov rbx,[rbx+0x120]
        00000010  EB52              jmp short 0x64
        00000012  448B6B20          mov r13d,[rbx+0x20]
        00000016  4C8B6308          mov r12,[rbx+0x8]
        0000001A  45236E0C          and r13d,[r14+0xc]
        0000001E  4889DE            mov rsi,rbx
        00000021  4489EF            mov edi,r13d
        00000024  E89FF7FFFF        call dword 0xfffffffffffff7c8
        00000029  89C0              mov eax,eax
        0000002B  <4D>8B24C4        mov r12,[r12+rax*8] <--------------
        0000002F  EB1B              jmp short 0x4c
        00000031  8B4B1C            mov ecx,[rbx+0x1c]
        00000034  498D7C2410        lea rdi,[r12+0x10]
        00000039  4C89FA            mov rdx,r15
        0000003C  4C89F6            mov rsi,r14
        0000003F  E8                db 0xe8
        
Assuming there really is a function at 0xfffffffffffff7c8 (that's 2103
bytes from the top of the kernel address space, which seems weird),
than, also assuming ndisasm is decoding this correctly, (which it
definitely isn't at the beginning and the end), it seems like that
function was called with the arguments "12" and "ffff88001f1edac0", and
the return value of that function was used as an index in an array of
some sort. It would seem that r12 (which was 0001e00000010100,
apparently functioning as the base of the array) is somewhere it
shouldn't be, because the function returned zero, and the attempt to
access that address blew up.

Somebody smarter than me will probably give you better answers, but I
thought I'd give it a shot.

Cheers,
 -- Calvin

