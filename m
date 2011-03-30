Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab1C3VfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:35:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964948Ab1C3Ve6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:34:58 -0400
Date: Wed, 30 Mar 2011 23:33:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jln@google.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] [226/275] Prevent rt_sigqueueinfo and
	rt_tgsigqueueinfo from spoofing the signal code
Message-ID: <20110330213338.GA20367@redhat.com>
References: <20110330203.501921634@firstfloor.org> <20110330210751.A9ADB3E1A05@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330210751.A9ADB3E1A05@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Andi Kleen wrote:
>
> --- linux-2.6.35.y.orig/kernel/signal.c	2011-03-29 22:50:25.616602954 -0700
> +++ linux-2.6.35.y/kernel/signal.c	2011-03-29 23:03:02.941224912 -0700
> @@ -2410,9 +2410,13 @@
>  		return -EFAULT;
>
>  	/* Not even root can pretend to send signals from the kernel.
> -	   Nor can they impersonate a kill(), which adds source info.  */
> -	if (info.si_code >= 0)
> +	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
> +	 */
> +	if (info.si_code != SI_QUEUE) {
> +		/* We used to allow any < 0 si_code */
> +		WARN_ON_ONCE(info.si_code < 0);
>  		return -EPERM;

Oh, please don't.

Quoting Roland:

	Commit da48524eb206 ("Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
	from spoofing the signal code") made the check on si_code too strict:
	glibc's aio implementation wants to queue signals with SI_ASYNCIO, and
	indeed glibc's tst-aio4 fails with the patched kernel.

If stable needs this change, then it probably needs

	Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
	commit 243b422af9ea9af4ead07a8ad54c90d4f9b6081a

as well.

Oleg.

