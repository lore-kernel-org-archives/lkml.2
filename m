Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1FASuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:50:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1FASuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:50:05 -0400
Date: Wed, 1 Jun 2011 20:47:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 01/17] ptrace: remove silly wait_trap variable from
	ptrace_attach()
Message-ID: <20110601184743.GA6504@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <1306710760-16440-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Tejun Heo wrote:
>
> Local variable wait_trap is used to determine whether to call
> wait_event() on TRAPPING or not, which doesn't change or optimize
> anything.  Remove it.
>
> ...
>
> -	if (wait_trap)
> -		wait_event(current->signal->wait_chldexit,
> -			   !(task->group_stop & GROUP_STOP_TRAPPING));
> +	wait_event(current->signal->wait_chldexit,
> +		   !(task->group_stop & GROUP_STOP_TRAPPING));
>  	return retval;

Well, it doesn't change anything, but only if ptrace_attach() succeeds.
The caller should not wait if STOP_TRAPPING was already set by another
tracer and we are going to fail. Afaics, nothing really bad can happen
but still this doesn't look very clean.

And. Please note that this patch is buggy until 8/17 "use bit_waitqueue
for TRAPPING", wait_event(current->signal->wait_chldexit) can hang forever
in this case since we are not ->parent.

I agree, wait_trap should go away. We can hit STOP_TRAPPING after attach
if we change detach to set this bit. But perhaps it would be more clean
to not call wait_event/wait_bit unconditionally anyway, we can check
retval == 0.

Oleg.

