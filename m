Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1IWLRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:17:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53809 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab1IWLRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:17:52 -0400
Subject: Re: [PATCH 5/5] ptrace: implement PTRACE_LISTEN
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
In-Reply-To: <1308043218-23619-6-git-send-email-tj@kernel.org>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
	 <1308043218-23619-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 12:17:30 +0100
Message-ID: <1316776650.5262.26.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 11:20 +0200, Tejun Heo wrote:

[...]

> +	case PTRACE_LISTEN:
> +		/*
> +		 * Listen for events.  Tracee must be in STOP.  It's not
> +		 * resumed per-se but is not considered to be in TRACED by
> +		 * wait(2) or ptrace(2).  If an async event (e.g. group
> +		 * stop state change) happens, tracee will enter STOP trap
> +		 * again.  Alternatively, ptracer can issue INTERRUPT to
> +		 * finish listening and re-trap tracee into STOP.
> +		 */
> +		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
> +			break;
> +
> +		si = child->last_siginfo;
> +		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
> +			break;

I've only just noticed this. You really don't want to break out of the
switch while holding sighand->siglock. This should read,

		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP)) {
			unlock_task_sighand(child, &flags);
			break;
		}

-- 
Matt Fleming, Intel Open Source Technology Center

