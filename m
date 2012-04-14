Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2DNQ2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:28:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34093 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DNQ2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120414161953.GA18140@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 09:28:29 -0700
X-Google-Sender-Auth: QEOuxvoHjVi2PlTtMIx2u15oRBg
Message-ID: <CA+55aFy9NsL6pGPs1gBQntpbCr0EUYFnWUUBj2-JGOLspryGvQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock() and rcu_read_unlock()
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 9:19 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> It also compiles this:
>
>        void rcu_read_unlock_code(void)
>        {
>                rcu_read_unlock();
>        }
>
> to this:
>
>        000000e0 <rcu_read_unlock_code>:
>          e0:   64 a1 00 00 00 00       mov    %fs:0x0,%eax
>          e6:   83 f8 01                cmp    $0x1,%eax
>          e9:   74 0d                   je     f8 <rcu_read_unlock_code+0x18>
>          eb:   64 ff 0d 00 00 00 00    decl   %fs:0x0
>          f2:   c3                      ret
>          f3:   90                      nop
>          f4:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
>          f8:   64 c7 05 00 00 00 00    movl   $0x80000000,%fs:0x0
>          ff:   00 00 00 80
>         103:   64 a1 00 00 00 00       mov    %fs:0x0,%eax
>         109:   85 c0                   test   %eax,%eax
>         10b:   75 0c                   jne    119 <rcu_read_unlock_code+0x39>
>         10d:   64 c7 05 00 00 00 00    movl   $0x0,%fs:0x0
>         114:   00 00 00 00
>         118:   c3                      ret
>         119:   8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
>         120:   e8 fc ff ff ff          call   121 <rcu_read_unlock_code+0x41>
>         125:   eb e6                   jmp    10d <rcu_read_unlock_code+0x2d>
>
> It is therefore not at all clear to me that the final patch in this
> series is worthwhile.

Yeah, the read-unlock does not seem to be worth inlining as-is. As
mentioned earlier, it tends to be the rcu_read_lock() that we really
want to inline anyway (not just because it's small, but also because
the call clobbers registers, and that has other bad interaction).

                   Linus
