Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2DQSfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2DQSfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:35:47 -0400
Date: Tue, 17 Apr 2012 20:35:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
	force_sig()
Message-ID: <20120417183513.GA1037@redhat.com>
References: <20120413004446.GA8376@redhat.com> <20120413182051.GA11149@sergelap> <20120413192455.GA24464@redhat.com> <20120416135931.GB4234@sergelap> <20120416153843.GA9302@redhat.com> <20120416162402.GA7995@sergelap> <20120416212606.GA27490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416212606.GA27490@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Oleg Nesterov wrote:
>
> I'll investigate and report tomorrow.

Thanks again Serge, everything is clear. Afaics this needs another
(almost off-topic) patch.

Please forget about sys_reboot() for the moment. There is a minor
and known problem with SIGKILL && SIGNAL_UNKILLABLE. If you send
SIGKILL from the parent namespace to cinit, this doesn't make it
SIGNAL_GROUP_EXIT immediately. Only after cinit actually dequeues
SIGKILL it does do_group_exit() and set this flag. This should be
fixed anyway, but not now.

And this explain the problem. Note that your test-case does
sys_reboot() from the init process, and reboot_pid_ns() does

	kill(pid_ns->child_reaper, SIGKILL);

	do_exit(0);

so it sends SIGKILL to itself and exit. This means that cinit
(current) obviously can't dequeue SIGKILL, and without
SIGNAL_GROUP_EXIT wait_task_zombie() ignores
signal->group_exit_code.

That is why the patch makes a difference.

But why reboot_pid_ns() does do_exit? Yes, it was copied from
sys_reboot() and I didn't notice. It should use do_group_exit(),
and sys_reboot() too. This is the patch I am going to send, but
I'll try to think a bit more.

Thanks!

Oleg.

