Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1C1SGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:06:11 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:59236 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932195Ab1C1SGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <4D90C2C1.70309@df1tl.local.here>
References: <4D90C2C1.70309@df1tl.local.here>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 28 Mar 2011 11:05:45 -0700
Message-ID: <AANLkTimZ7ODhKwgtodZXOVK-J6Smf1CzFNQCjeY3d5ey@mail.gmail.com>
Subject: Re: 2.6.37.6 2.6.38.2 tst-aio4.c
To: Klaus Dittrich <kladit@arcor.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:17 AM, Klaus Dittrich <kladit@arcor.de> wrote:
> With both kernels, 2.6.37.6 and 2.6.38.2 tst-aio4.c of glibc fails.
>
> It successfully completes with 2.6.37.5 and 2.6.38.1 and before.
>
> I appended the code for convinice.

I took a quick look at this, and indeed the program succeeds on 2.6.38
but fails on the latest tip of Linus's tree.  I'm pretty sure that the obvious
place to look, my patch "aio: wake all waiters when destroying ctx" is not
to blame, both because the patch is obviously correct :) and also because
this test is using the glibc aio implementation, which doesn't use the
kernel's aio code at all.

Indeed, an strace of the program shows that on old kernels, the child thread
does

rt_sigqueueinfo(16143, SIGRT_17, {si_signo=SIGRT_17,
si_code=SI_ASYNCIO, si_pid=16143, si_uid=1000, si_value={int=0,
ptr=0}}) = 0

while on the new kernel, it gets EPERM:

rt_sigqueueinfo(17198, SIGRT_17, {si_signo=SIGRT_17,
si_code=SI_ASYNCIO, si_pid=17198, si_uid=1000, si_value={int=0,
ptr=0}}) = -1 EPERM (Operation not permitted)

I'll take a look to see which -stable patch might be to blame.

 - R.
