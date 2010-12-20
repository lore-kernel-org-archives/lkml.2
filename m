Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab0LTPGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0LTPGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:06:54 -0500
Date: Mon, 20 Dec 2010 15:59:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 04/16] ptrace: kill tracehook_notify_jctl()
Message-ID: <20101220145956.GC11583@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> tracehook_notify_jctl() aids in determining whether and what to report
> to the parent when a task is stopped or continued.  The function also
> adds an extra requirement that siglock may be released across it,
> which is currently unused and quite difficult to satisfy in
> well-defined manner.

OK. I agree, tracehook_notify_jctl() looks very unobvious, especially
because it is not really used currently.

The patch looks correct, except

> @@ -1853,21 +1850,19 @@ relock:
>  	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
>  		int why;
>
> -		if (signal->flags & SIGNAL_CLD_CONTINUED)
> +		if (task_ptrace(current) ||
> +		    (signal->flags & SIGNAL_CLD_CONTINUED))
>  			why = CLD_CONTINUED;
>  		else
>  			why = CLD_STOPPED;

Hmm, I can't understand this.

task_ptrace() should not turn CLD_STOPPED in CLD_CONTINUED?

Looking ahead, it _seems_ that the next patches keep this logic,
could you explain?

Oleg.

