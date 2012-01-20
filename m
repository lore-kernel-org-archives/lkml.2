Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2ATMOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:14:47 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:40500
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab2ATMOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:14:44 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0KCEcVG013653
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <20120120110111.GB30612@arm.com> (Catalin Marinas's message of
	"Fri, 20 Jan 2012 11:01:11 +0000")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab> <20120119140058.GA19036@arm.com>
	<gik44nrc52.fsf@karga.hank.lab> <20120119153732.GB20558@arm.com>
	<gi1uqvwpt2.fsf@mx10.gouders.net> <gimx9jv50u.fsf@mx10.gouders.net>
	<giipk7v2hv.fsf@mx10.gouders.net> <20120120110111.GB30612@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 20 Jan 2012 13:14:38 +0100
Message-ID: <gi7h0mpo41.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 20 Jan 2012 13:14:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Jan 19, 2012 at 08:52:44PM +0000, Dirk Gouders wrote:
>> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
>> I want to note that in my config CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is
>> set which causes kmemleak_disable() to be called in kmemleak_init().
>
> Thanks for the investigation. Could you please try the patch below?
> Thanks.

Hi Catalin,

I tested it and that patch solves the problems here.

Thanks a lot for your help,

Dirk

>
> From 09e7bd41ff3fd07e4c5eea7bbb0a045921eb5944 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Fri, 20 Jan 2012 10:42:40 +0000
> Subject: [PATCH] kmemleak: Disable early logging when kmemleak is off by
>  default
>
> Commit b6693005 (kmemleak: When the early log buffer is exceeded, report
> the actual number) deferred the disabling of the early logging to
> kmemleak_init(). However, when CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y, the
> early logging was no longer disabled causing __init kmemleak functions
> to be called even after the kernel freed the init memory. This patch
> disables the early logging during kmemleak_init() if kmemleak is left
> disabled.
>
> Reported-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  mm/kmemleak.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index f9f7310..45eb621 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1757,6 +1757,7 @@ void __init kmemleak_init(void)
>  
>  #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
>  	if (!kmemleak_skip_disable) {
> +		atomic_set(&kmemleak_early_log, 0);
>  		kmemleak_disable();
>  		return;
>  	}
