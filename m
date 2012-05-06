Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2EFMbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 08:31:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50350 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2EFMbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 08:31:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 95.21.35.138
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/uRaanE/X/V2rdtByI5mVL
Date: Sun, 6 May 2012 14:31:00 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG on fs/inode.c:1442 (linux 3.3.1 and 3.3.2)
Message-ID: <20120506123100.GI1927@vicerveza.homeunix.net>
References: <20120415215601.GV1927@vicerveza.homeunix.net>
 <20120418114844.GA22295@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120418114844.GA22295@quack.suse.cz>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 01:48:44PM +0200, Jan Kara wrote:
>   Hello,
> 
> On Sun 15-04-12 23:56:01, Lluís Batlle i Rossell wrote:
> > destroying my openvpn client connection (SIGINT to openvp), in linux 3.3.1 and
> > now also in 3.3.2, I noticed this BUG in dmesg (attached).
> > 
> > It's a vanilla 3.3.2, at this shot.
> > 
> > I know it never happened to me in any 3.2, but I did not try 3.3.0.
> > 
> > I attach the .config. And I have the debug info for this kernel too, if this
> > helps someone find a fix. But I imagine it's easy to reproduce.
>   From the first look it would seem as use after free bug but can you
> please post disassembly of iput() function from your kernel? I.e. you load
> vmlinux in gdb and run 'disass iput'. Thanks.

Sorry for the delay. Here it is, for 3.3.2:

ffffffff8113b340 <iput>:
ffffffff8113b340:       55                      push   %rbp
ffffffff8113b341:       48 89 e5                mov    %rsp,%rbp
ffffffff8113b344:       48 83 ec 20             sub    $0x20,%rsp
ffffffff8113b348:       48 89 5d e8             mov    %rbx,-0x18(%rbp)
ffffffff8113b34c:       4c 89 65 f0             mov    %r12,-0x10(%rbp)
ffffffff8113b350:       4c 89 6d f8             mov    %r13,-0x8(%rbp)
ffffffff8113b354:       e8 a7 3d 24 00          callq  ffffffff8137f100 <mcount>
ffffffff8113b359:       48 85 ff                test   %rdi,%rdi
ffffffff8113b35c:       48 89 fb                mov    %rdi,%rbx
ffffffff8113b35f:       74 24                   je     ffffffff8113b385 <iput+0x45>
ffffffff8113b361:       f6 87 98 00 00 00 40    testb  $0x40,0x98(%rdi)
ffffffff8113b368:       0f 85 89 01 00 00       jne    ffffffff8113b4f7 <iput+0x1b7>
ffffffff8113b36e:       48 8d b7 80 00 00 00    lea    0x80(%rdi),%rsi
ffffffff8113b375:       48 8d bf 10 01 00 00    lea    0x110(%rdi),%rdi
ffffffff8113b37c:       e8 2f b4 0a 00          callq  ffffffff811e67b0 <_atomic_dec_and_lock>
ffffffff8113b381:       85 c0                   test   %eax,%eax
ffffffff8113b383:       75 13                   jne    ffffffff8113b398 <iput+0x58>
ffffffff8113b385:       48 8b 5d e8             mov    -0x18(%rbp),%rbx
ffffffff8113b389:       4c 8b 65 f0             mov    -0x10(%rbp),%r12
ffffffff8113b38d:       4c 8b 6d f8             mov    -0x8(%rbp),%r13
ffffffff8113b391:       c9                      leaveq 
ffffffff8113b392:       c3                      retq   
ffffffff8113b393:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
ffffffff8113b398:       f6 83 98 00 00 00 08    testb  $0x8,0x98(%rbx)
ffffffff8113b39f:       4c 8b 63 28             mov    0x28(%rbx),%r12
ffffffff8113b3a3:       4d 8b 6c 24 30          mov    0x30(%r12),%r13
ffffffff8113b3a8:       0f 85 4b 01 00 00       jne    ffffffff8113b4f9 <iput+0x1b9>
ffffffff8113b3ae:       49 8b 45 20             mov    0x20(%r13),%rax
ffffffff8113b3b2:       48 85 c0                test   %rax,%rax
ffffffff8113b3b5:       0f 84 a5 00 00 00       je     ffffffff8113b460 <iput+0x120>
ffffffff8113b3bb:       48 89 df                mov    %rbx,%rdi
ffffffff8113b3be:       ff d0                   callq  *%rax
ffffffff8113b3c0:       85 c0                   test   %eax,%eax
ffffffff8113b3c2:       0f 85 b0 00 00 00       jne    ffffffff8113b478 <iput+0x138>
ffffffff8113b3c8:       41 f6 44 24 53 40       testb  $0x40,0x53(%r12)
ffffffff8113b3ce:       0f 85 b4 00 00 00       jne    ffffffff8113b488 <iput+0x148>
ffffffff8113b3d4:       48 83 8b 98 00 00 00    orq    $0x10,0x98(%rbx)
ffffffff8113b3db:       10 
ffffffff8113b3dc:       be 01 00 00 00          mov    $0x1,%esi
ffffffff8113b3e1:       48 89 df                mov    %rbx,%rdi
ffffffff8113b3e4:       e8 67 d7 00 00          callq  ffffffff81148b50 <write_inode_now>
ffffffff8113b3e9:       48 8b 83 98 00 00 00    mov    0x98(%rbx),%rax
ffffffff8113b3f0:       a8 08                   test   $0x8,%al
ffffffff8113b3f2:       0f 85 17 01 00 00       jne    ffffffff8113b50f <iput+0x1cf>
ffffffff8113b3f8:       48 83 e0 ef             and    $0xffffffffffffffef,%rax
ffffffff8113b3fc:       48 83 c8 20             or     $0x20,%rax
ffffffff8113b400:       48 8b 93 e0 00 00 00    mov    0xe0(%rbx),%rdx
ffffffff8113b407:       48 89 83 98 00 00 00    mov    %rax,0x98(%rbx)
ffffffff8113b40e:       48 8d 83 e0 00 00 00    lea    0xe0(%rbx),%rax
ffffffff8113b415:       48 39 d0                cmp    %rdx,%rax
ffffffff8113b418:       74 2e                   je     ffffffff8113b448 <iput+0x108>
ffffffff8113b41a:       48 8b 8b e8 00 00 00    mov    0xe8(%rbx),%rcx
ffffffff8113b421:       48 89 4a 08             mov    %rcx,0x8(%rdx)
ffffffff8113b425:       48 89 11                mov    %rdx,(%rcx)
ffffffff8113b428:       48 89 83 e0 00 00 00    mov    %rax,0xe0(%rbx)
ffffffff8113b42f:       48 89 83 e8 00 00 00    mov    %rax,0xe8(%rbx)
ffffffff8113b436:       48 8b 43 28             mov    0x28(%rbx),%rax
ffffffff8113b43a:       ff 0c 25 84 3c 65 81    decl   0xffffffff81653c84
ffffffff8113b441:       83 a8 10 01 00 00 01    subl   $0x1,0x110(%rax)
ffffffff8113b448:       48 89 df                mov    %rbx,%rdi
ffffffff8113b44b:       e8 50 fd ff ff          callq  ffffffff8113b1a0 <evict>
ffffffff8113b450:       48 8b 5d e8             mov    -0x18(%rbp),%rbx
ffffffff8113b454:       4c 8b 65 f0             mov    -0x10(%rbp),%r12
ffffffff8113b458:       4c 8b 6d f8             mov    -0x8(%rbp),%r13
ffffffff8113b45c:       c9                      leaveq 
ffffffff8113b45d:       c3                      retq   
ffffffff8113b45e:       66 90                   xchg   %ax,%ax
ffffffff8113b460:       8b 43 48                mov    0x48(%rbx),%eax
ffffffff8113b463:       85 c0                   test   %eax,%eax
ffffffff8113b465:       74 11                   je     ffffffff8113b478 <iput+0x138>
ffffffff8113b467:       48 83 bb c8 00 00 00    cmpq   $0x0,0xc8(%rbx)
ffffffff8113b46e:       00 
ffffffff8113b46f:       0f 85 53 ff ff ff       jne    ffffffff8113b3c8 <iput+0x88>
ffffffff8113b475:       0f 1f 00                nopl   (%rax)
ffffffff8113b478:       48 8b 83 98 00 00 00    mov    0x98(%rbx),%rax
ffffffff8113b47f:       e9 78 ff ff ff          jmpq   ffffffff8113b3fc <iput+0xbc>
ffffffff8113b484:       0f 1f 40 00             nopl   0x0(%rax)
ffffffff8113b488:       48 8b 83 98 00 00 00    mov    0x98(%rbx),%rax
ffffffff8113b48f:       80 cc 01                or     $0x1,%ah
ffffffff8113b492:       a8 87                   test   $0x87,%al
ffffffff8113b494:       48 89 83 98 00 00 00    mov    %rax,0x98(%rbx)
ffffffff8113b49b:       0f 85 e4 fe ff ff       jne    ffffffff8113b385 <iput+0x45>
ffffffff8113b4a1:       48 8d 83 e0 00 00 00    lea    0xe0(%rbx),%rax
ffffffff8113b4a8:       48 3b 83 e0 00 00 00    cmp    0xe0(%rbx),%rax
ffffffff8113b4af:       0f 85 d0 fe ff ff       jne    ffffffff8113b385 <iput+0x45>
ffffffff8113b4b5:       48 8b 53 28             mov    0x28(%rbx),%rdx
ffffffff8113b4b9:       ff 04 25 84 3c 65 81    incl   0xffffffff81653c84
ffffffff8113b4c0:       48 8b 8a 00 01 00 00    mov    0x100(%rdx),%rcx
ffffffff8113b4c7:       48 89 41 08             mov    %rax,0x8(%rcx)
ffffffff8113b4cb:       48 89 8b e0 00 00 00    mov    %rcx,0xe0(%rbx)
ffffffff8113b4d2:       48 8d 8a 00 01 00 00    lea    0x100(%rdx),%rcx
ffffffff8113b4d9:       48 89 8b e8 00 00 00    mov    %rcx,0xe8(%rbx)
ffffffff8113b4e0:       48 89 82 00 01 00 00    mov    %rax,0x100(%rdx)
ffffffff8113b4e7:       48 8b 43 28             mov    0x28(%rbx),%rax
ffffffff8113b4eb:       83 80 10 01 00 00 01    addl   $0x1,0x110(%rax)
ffffffff8113b4f2:       e9 8e fe ff ff          jmpq   ffffffff8113b385 <iput+0x45>
ffffffff8113b4f7:       0f 0b                   ud2    
ffffffff8113b4f9:       be 76 05 00 00          mov    $0x576,%esi
ffffffff8113b4fe:       48 c7 c7 fe 3b 55 81    mov    $0xffffffff81553bfe,%rdi
ffffffff8113b505:       e8 b6 7d f0 ff          callq  ffffffff810432c0 <warn_slowpath_null>
ffffffff8113b50a:       e9 9f fe ff ff          jmpq   ffffffff8113b3ae <iput+0x6e>
ffffffff8113b50f:       be 8a 05 00 00          mov    $0x58a,%esi
ffffffff8113b514:       48 c7 c7 fe 3b 55 81    mov    $0xffffffff81553bfe,%rdi
ffffffff8113b51b:       e8 a0 7d f0 ff          callq  ffffffff810432c0 <warn_slowpath_null>
ffffffff8113b520:       48 8b 83 98 00 00 00    mov    0x98(%rbx),%rax
ffffffff8113b527:       e9 cc fe ff ff          jmpq   ffffffff8113b3f8 <iput+0xb8>
ffffffff8113b52c:       0f 1f 40 00             nopl   0x0(%rax)

