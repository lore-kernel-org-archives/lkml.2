Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1DBQhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 12:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab1DBQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 12:37:47 -0400
Date: Sat, 2 Apr 2011 18:37:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] avr32: Don't acquire siglock when reading sighand
	action
Message-ID: <20110402163722.GA2973@redhat.com>
References: <1301511856-9370-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301511856-9370-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Matt Fleming wrote:
>
> From: Matt Fleming <matt.fleming@linux.intel.com>
>
> There's no need to acquire the siglock when simply reading the action
> handler. We would need to lock it if we were modifying the handler or
> we were protecting it from modification across function calls, but if
> we're just reading it, there's no need to lock it

Agreed, ->siglock buys nothing.

But,

> --- a/arch/avr32/kernel/traps.c
> +++ b/arch/avr32/kernel/traps.c
> @@ -106,9 +106,7 @@ void _exception(long signr, struct pt_regs *regs, int code,
>  	if (is_global_init(current)) {

is_global_init() is not right in theory, /sbin/init can be multithreaded.
And, this doesn't cover the sub-namespace inits... I'd suggest to check
SIGNAL_UNKILLABLE, but looking closer I think you can simply remove this
code.

The comment says:

	/*
	 * Init gets no signals that it doesn't have a handler for.
	 * That's all very well, but if it has caused a synchronous
	 * exception and we ignore the resulting signal, it will just
	 * generate the same exception over and over again and we get
	 * nowhere.  Better to kill it and let the kernel panic.
	 */

This is correct, but please look at force_sig_info(), it already does
what you need:

	* We don't want to have recursive SIGSEGV's etc, for example,
	* that is why we also clear SIGNAL_UNKILLABLE.

Oleg.

