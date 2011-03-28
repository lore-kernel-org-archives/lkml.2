Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1C1U1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:27:54 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:40537 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753928Ab1C1U1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110328174230.GB11649@redhat.com>
References: <1301336640-16348-1-git-send-email-roland@kernel.org> <20110328174230.GB11649@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 28 Mar 2011 13:27:31 -0700
X-Google-Sender-Auth: 4UKqlgNUDdrdYGsHkY7-QU6c-0s
Message-ID: <AANLkTi=3vXEW3r4Z9v=QF_Dj2WL6m8S7ATDQvSy7mPbg@mail.gmail.com>
Subject: Re: [PATCH] Allow rt_sigqueueinfo and rt_tgsigqueueinfo to use
 si_code == SI_ASYNCIO
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julien Tinnes <jln@google.com>,
        Klaus Dittrich <kladit@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:42 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> I am starting to think that "plan B" was better.
>
>        if (info.si_code >= 0 || info.si_code == SI_TKILL)
>                return -EPERM;

Indeed.  Grepping further in glibc finds sysdeps/unix/sysv/linux/aio_sigqueue.c:

        /* We must pass the information about the data in a siginfo_t
           value.  */
        info.si_signo = timer->event.sigev_signo;
        info.si_code = SI_TIMER;
        info.si_pid = timer->creator_pid;
        info.si_uid = getuid ();
        info.si_value = timer->event.sigev_value;

        INLINE_SYSCALL (rt_sigqueueinfo, 3, info.si_pid, info.si_signo, &info);

and sysdeps/unix/sysv/linux/gai_sigqueue.c:

  /* We must pass the information about the data in a siginfo_t value.  */
  info.si_signo = sig;
  info.si_code = SI_ASYNCNL;
  info.si_pid = caller_pid;
  info.si_uid = __getuid ();
  info.si_value = val;

  return INLINE_SYSCALL (rt_sigqueueinfo, 3, info.si_pid,
                         sig, __ptrvalue (&info));

where SI_ASYNCNL is -60, which the kernel doesn't know about.

Updated patch coming in a minute.

Thanks,
  Roland
