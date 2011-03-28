Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1C1Swd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab1C1Swc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:52:32 -0400
Date: Mon, 28 Mar 2011 19:42:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julien Tinnes <jln@google.com>,
        Klaus Dittrich <kladit@arcor.de>
Subject: Re: [PATCH] Allow rt_sigqueueinfo and rt_tgsigqueueinfo to use
	si_code == SI_ASYNCIO
Message-ID: <20110328174230.GB11649@redhat.com>
References: <1301336640-16348-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301336640-16348-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Roland Dreier wrote:
>
> Commit da48524eb206 ("Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
> from spoofing the signal code") made the check on si_code too strict:
> glibc's aio implementation wants to queue signals with SI_ASYNCIO, and
> indeed glibc's tst-aio4 fails with the patched kernel.
>
> Fix this by loosening the new check to allow SI_ASYNCIO as well.

Heh.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2437,7 +2437,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
>  	/* Not even root can pretend to send signals from the kernel.
>  	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
>  	 */
> -	if (info.si_code != SI_QUEUE) {
> +	if (info.si_code != SI_QUEUE && info.si_code != SI_ASYNCIO) {

I am starting to think that "plan B" was better.

	if (info.si_code >= 0 || info.si_code == SI_TKILL)
		return -EPERM;

Although we should probably keep WARN_ON_ONCE() anyway.

Oleg.

