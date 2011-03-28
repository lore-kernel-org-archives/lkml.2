Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1C1VZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:25:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1C1VZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P2G1VrCf2zp/vEgRf08V2KrV4/NtForlmxh5CVpYuRICycvvvP2zP+3TrUIuUK5zC7
         KL79hxN5V810/KXGMpUw==
MIME-Version: 1.0
In-Reply-To: <1301346815-6755-1-git-send-email-roland@kernel.org>
References: <1301346815-6755-1-git-send-email-roland@kernel.org>
Date: Mon, 28 Mar 2011 14:24:57 -0700
Message-ID: <BANLkTikB7nz_HKUWOZfGERmh+xSy9Uh0mg@mail.gmail.com>
Subject: Re: [PATCH v2] Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
From: Julien Tinnes <jln@google.com>
To: Roland Dreier <roland@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Klaus Dittrich <kladit@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohh, good catch!

It's not ideal that we have to relax this check, but as long as kernel
codes, SI_USER and SI_TKILL are not spoofable, I think we're in ok
shape.

Thanks,

Julien

On Mon, Mar 28, 2011 at 2:13 PM, Roland Dreier <roland@kernel.org> wrote:
> From: Roland Dreier <roland@purestorage.com>
>
> Commit da48524eb206 ("Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
> from spoofing the signal code") made the check on si_code too strict.
> There are several legitimate places where glibc wants to queue a
> negative si_code different from SI_QUEUE:
>
>  - This was first noticed with glibc's aio implementation, which wants
>   to queue a signal with si_code SI_ASYNCIO; the current kernel
>   causes glibc's tst-aio4 test to fail because rt_sigqueueinfo()
>   fails with EPERM.
>
>  - Further examination of the glibc source shows that getaddrinfo_a()
>   wants to use SI_ASYNCNL (which the kernel does not even define).
>   The timer_create() fallback code wants to queue signals with SI_TIMER.
>
> As suggested by Oleg Nesterov <oleg@redhat.com>, loosen the check to
> forbid only the problematic SI_TKILL case.
>
> Reported-by: Klaus Dittrich <kladit@arcor.de>
> Cc: <stable@kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  kernel/signal.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 324eff5..b2bfa3a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2437,7 +2437,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
>        /* Not even root can pretend to send signals from the kernel.
>         * Nor can they impersonate a kill()/tgkill(), which adds source info.
>         */
> -       if (info.si_code != SI_QUEUE) {
> +       if (info.si_code >= 0 || info.si_code == SI_TKILL) {
>                /* We used to allow any < 0 si_code */
>                WARN_ON_ONCE(info.si_code < 0);
>                return -EPERM;
> @@ -2457,7 +2457,7 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
>        /* Not even root can pretend to send signals from the kernel.
>         * Nor can they impersonate a kill()/tgkill(), which adds source info.
>         */
> -       if (info->si_code != SI_QUEUE) {
> +       if (info->si_code >= 0 || info->si_code == SI_TKILL) {
>                /* We used to allow any < 0 si_code */
>                WARN_ON_ONCE(info->si_code < 0);
>                return -EPERM;
>
