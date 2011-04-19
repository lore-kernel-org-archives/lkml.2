Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1DSQ37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1DSQ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:29:58 -0400
Date: Tue, 19 Apr 2011 18:29:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stas Sergeev <stsp@aknet.ru>, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
Message-ID: <20110419162909.GC23914@redhat.com>
References: <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <20110419161301.GA23914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419161301.GA23914@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Oleg Nesterov wrote:
>
> I'll try to check these patches from the correctness pov tomorrow,
> but to be honest I hope someone will nack them before I start ;)

OK, I briefly looked at 3/3. It looks certainly wrong.

	notif = do_signal_parent(...);
	if (notif != DEATH_REAP) {
	....

do_signal_parent() must not return DEATH_REAP (this means that
leader->exit_signal becomes -1), but this can happen and this is bug.

I can be wrong, but iirc this was already discussed, probably when
you sent the very first version which had the same problem. That is
why (in particular) do_notify_parent() does

	BUG_ON(tsk->group_leader != tsk || !thread_group_empty(tsk))

but you simply removed this check to hide the problem.



Also. I didn't actually read the patch yet, but iiuc: if a task T does
PR_DETACH and then exits, init can't reap it until the old parent does
wait. This can confuse the poor admin, he can see the zombies with
ppid = 1 and there is no way to understand why.

Oleg.

