Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2CKAMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 19:12:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43271 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2CKAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 19:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2012 16:12:20 -0800
X-Google-Sender-Auth: gP41pmZJyOqDWIBVUlxpCngpjLY
Message-ID: <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
Subject: Re: [PATCH 1/9] exec: add a global execve counter
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 3:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>
> Given that consideration this patch introduces two counters:
> A global atomic execve counter that will be incremented on every
> do_execve_common() call, and an atomic exec_id member for the task_struct.

This seems horribly expensive on most 32-bit architectures, including
very much x86-32. That atomic64_inc_return() is not cheap.  It's
possible that it's basically an impossible operation to do atomically
on certain platforms, causing it to use some random spinlock instead.

I wonder if we couldn't make something much cheaper, since we don't
actually care about it being globally incrementing, we just care about
it being globally unique. IOW, it could easily be a 56-bit per-cpu
counter along with the CPU number in the high bits or something like
that. Avoiding the whole atomicity issue, and thus avoiding the main
reason those things are really expensive.

IOW, something like

   cpu = get_cpu();
   .. increment percpu 64-bit counter ..
   id = counter * MAX_CPUS + cpu;
   put_cpu(cpu);

or equivalent would seem to be a potentially much cheaper approach.

              Linus
