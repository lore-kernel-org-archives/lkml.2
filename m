Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1HWSrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:47:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1HWSrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:47:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Date: Tue, 23 Aug 2011 20:46:33 +0200
Message-ID: <2337681.paSeVyBarJ@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E53F282.10908@suse.cz>
References: <13141210141189@kroah.org> <4E53F282.10908@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PkoYC66685HPU80EFiSyX/Rl6KKODtqHBgsWNU5uGNG
 rH1RySrEEEEFLgHhLjDELG+gBeSGn1Yghx929rwyoqXr5Fumb4
 7jh1hcMONlC+bWb8m5wsqil5v6gzVyj9LABP6adFJr8cEJ9D3M
 V+nfDqNBs1PD06DPhPx+EHwYJ5By8v/R9gUUxRgTXjO1vEKdFD
 jBzXo9PaO8mOSJiO1u/IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 August 2011 20:33:38 Jiri Slaby wrote:

> It looks like I need tty_locked to fix system stalls in
> tty_wait_until_sent in the end. Like with the patch attached. But if
> someone finds another way to fix this in short-term, it would be great.
>
> 
> @@ -153,8 +154,14 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
>  #endif
>  	if (!timeout)
>  		timeout = MAX_SCHEDULE_TIMEOUT;
> -	if (wait_event_interruptible_timeout(tty->write_wait,
> -			!tty_chars_in_buffer(tty), timeout) >= 0) {
> +
> +	if (tty_locked()) /* e.g. uart (holds) vs. tty_ioctl (does not) */
> +		retval = wait_event_interruptible_timeout_tty(tty->write_wait,
> +			!tty_chars_in_buffer(tty), timeout);
> +	else
> +		retval = wait_event_interruptible_timeout(tty->write_wait,
> +			!tty_chars_in_buffer(tty), timeout);
> 
> 

According to http://kernelnewbies.org/BigKernelLock, I concluded back then
that tty_wait_until_sent would always be called without BTM held. Has that
changed recently, or did I miss a caller that holds the BTM?

The only caller that used to call it with BKL was tty_set_ldisc, and that
got changed to release the BTM before calling it. If there is another
caller, can it do the same?

	Arnd
