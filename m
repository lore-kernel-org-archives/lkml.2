Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2CATKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:10:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2CATKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:10:21 -0500
Date: Thu, 1 Mar 2012 20:03:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Chan <benchan@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: abort core dump piping only due to a fatal signal
Message-ID: <20120301190322.GA9638@redhat.com>
References: <1330626227-32257-1-git-send-email-benchan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330626227-32257-1-git-send-email-benchan@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Ben Chan wrote:
>
> This patch makes wait_for_dump_helpers() not to abort piping the core
> dump data when the crashing process has received any but a fatal signal
> (SIGKILL). The rationale is that a crashing process may still receive
> uninteresting signals such as SIGCHLD when its core dump data is being
> redirected to a helper application. While it's necessary to allow
> terminating the core dump piping via SIGKILL,

Noe that SIGKILL doesn't really work. IOW, there are more problems.

> it's practically more
> useful for the purpose of debugging and crash reporting if the core dump
> piping is not aborted due to other non-fatal signals.

Yes.

> Addresses http://code.google.com/p/chromium-os/issues/detail?id=21559

Heh. please look at https://bugzilla.redhat.com/show_bug.cgi?id=759213

> @@ -2031,7 +2031,7 @@ static void wait_for_dump_helpers(struct file *file)
>  	pipe->readers++;
>  	pipe->writers--;
>
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {

No, it is not that simple. This can't fix all problems and in fact
this check should be simply removed (but not right now).

Oh. I'll try to send the fix, well, soon. The problem is that I
already promised this before ;)

See also http://marc.info/?l=linux-kernel&m=131989970411759

Oleg.

