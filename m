Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1C0Ph5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:37:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766Ab1C0Ph4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimYXGQ7BSyuQaqNrW8qp4ETiH8if4-8Gt6LmCyA@mail.gmail.com>
References: <AANLkTimYXGQ7BSyuQaqNrW8qp4ETiH8if4-8Gt6LmCyA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Mar 2011 08:37:24 -0700
Message-ID: <AANLkTikua-zAss=BRA106EqvmawVMUqk5Sc-J=VjvC+8@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request
To: Anca Emanuel <anca.emanuel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, this smells like your /proc cleanups/fixes...

On Sun, Mar 27, 2011 at 2:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi, I'm using latest kernel git.
>
>
> [15117.080119] BUG: unable to handle kernel paging request at fffffffffffffff3

That's "-13" (possibly -EACCES)

> [15117.080152] IP: [<ffffffff811b4989>] vma_stop+0x19/0x40

.. and the code disassembles to

   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	53                   	push   %rbx
   5:	48 83 ec 08          	sub    $0x8,%rsp
   9:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   e:	48 85 f6             	test   %rsi,%rsi
  11:	74 1a                	je     0x2d
  13:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
  17:	74 14                	je     0x2d
  19:	8b 1e                	mov    (%rsi),%ebx
  1b:	48 8d 7b 60          	lea    0x60(%rbx),%rdi
  1f:	e8 eb 2f ed ff       	callq  up_read

where that instruction at 0x19 is the access "mm = vma->vm_mm". So
it's vma that is -EPERM.

I bet it's due to commit ec6fd8a4355c ("report errors in /proc/*/*map*
sanely"), which replaces NULL with various ERR_PTR() cases.

> [15117.080660] Call Trace:
> [15117.080671]  [<ffffffff811b4a3a>] m_stop+0x1a/0x40
> [15117.080685]  [<ffffffff8117d991>] seq_read+0x1e1/0x420
> [15117.080698]  [<ffffffff8115c685>] vfs_read+0xc5/0x190
> [15117.080711]  [<ffffffff8115c851>] sys_read+0x51/0x90
> [15117.080724]  [<ffffffff815b2d02>] system_call_fastpath+0x16/0x1b

Al?

                               Linus
