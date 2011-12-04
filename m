Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1LDPuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 10:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1LDPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 10:50:51 -0500
Date: Sun, 4 Dec 2011 16:45:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][v2] Add reboot_pid_ns to handle the reboot syscall
Message-ID: <20111204154543.GA23805@redhat.com>
References: <1322956280-13831-1-git-send-email-daniel.lezcano@free.fr> <1322956280-13831-2-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322956280-13831-2-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Daniel Lezcano wrote:
>
> @@ -32,6 +32,8 @@ struct pid_namespace {
>  #endif
>  	gid_t pid_gid;
>  	int hide_pid;
> +	int reboot;
> +	spinlock_t reboot_lock;
>  };

Well. I was thinking about the serialization too, but this
->reboot_lock asks for v3 imho ;)

First of all, do we really care? force_sig(SIGKILL, child_reaper)
can't race with itself, it does nothing if init is already killed.

So why it is important to protect pid_ns->reboot? Yes, it is possible
to change it again if two callers do sys_reboot() "at the same time".
But in this case we can't predict which caller wins anyway, so why
should we worry?

IOW. Say, we have the 2 tasks doing HALT and RESTART in parallel.
It is possible that HALT sets ->reboot and kills init first, then
RESTART changes ->reboot and the second force_sig() does nothing.
In this case we can simply pretend that RESTART wins and the dying
init kills HALT before it calls sys_reboot().

In any case. Even if you want to serialize, instead of adding the
new lock reboot_pid_ns() can simply do:

	if (cmpxchg(&pid_ns->reboot, 0, reboot) != 0)
		return -EBUSY;

this looks much simpler to me.

Oleg.

