Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2CRTC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:02:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57738 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2CRTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120313005855.GA24639@redhat.com>
References: <20120313005855.GA24639@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 12:02:04 -0700
X-Google-Sender-Auth: aIHfO_KAxuSImWoldl1JVnqzxm8
Message-ID: <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 5:58 PM, Dave Jones <davej@redhat.com> wrote:
>
> While trying to reproduce the i915 memory corruption problem with hibernate,
> I've hit the following use-after-free quite a few times, by running my
> syscall fuzzer and hibernating/resuming in a loop.
>
> oops below on 3.3rc7, but same problem also affects 3.2.9, and probably
> many versions before that.
>
> RIP: proc_sys_poll+0x4e/0x90
> Code: 00 48 89 fb 48 89 f1 48 8b 40 30 4c 8b 60 e8 b8 45 01 00 00 49 83 7c 24 28 00 74 2e 49 8b 74 24 30 48 85 f6 74 24 48 85 c9 75 32 <8b> 16 b8 45 01 00 00 48 63 d2 49 39 d5 74 10 8b 06 48 98 48 89

The code is:

   0:	48 89 fb             	mov    %rdi,%rbx
   3:	48 89 f1             	mov    %rsi,%rcx
   6:	48 8b 40 30          	mov    0x30(%rax),%rax
   a:	4c 8b 60 e8          	mov    -0x18(%rax),%r12
   e:	b8 45 01 00 00       	mov    $0x145,%eax
  13:	49 83 7c 24 28 00    	cmpq   $0x0,0x28(%r12)
  19:	74 2e                	je     0x49
  1b:	49 8b 74 24 30       	mov    0x30(%r12),%rsi
  20:	48 85 f6             	test   %rsi,%rsi
  23:	74 24                	je     0x49
  25:	48 85 c9             	test   %rcx,%rcx
  28:	75 32                	jne    0x5c
  2a:*	8b 16                	mov    (%rsi),%edx     <-- trapping instruction
  2c:	b8 45 01 00 00       	mov    $0x145,%eax
  31:	48 63 d2             	movslq %edx,%rdx
  34:	49 39 d5             	cmp    %rdx,%r13
  37:	74 10                	je     0x49
  39:	8b 06                	mov    (%rsi),%eax

and that load is from

    poll_wait(filp, &table->poll->wait, wait);

where the testing of %rsi and %rcx are the "if (p && wait_address)"
check in poll_wait(), and %rsi is "table->poll" if I read it all
correctly.

And the 6b6b6b6b6b6b6b6b pattern is obviously POISON_FREE, so
apparently 'table' has already been freed.

I suspect the whole sysctl 'poll' code is seriously broken, since it
seems to depend on those ctl_table pointers being stable over the
whole open/close sequence, but if somebody unregisters the sysctl,
it's all gone. The ctl_table doesn't have any refcounting etc, and I
suspect that your hibernate sequence ends up unregistering some sysctl
(perhaps as part of a module unload?)

The sysctl poll code was added fairly recently, I'm adding the guilty
parties and some other relevant people to the cc.

Oh, how I hate sysctl's. Misdesigned from the start.

                   Linus
