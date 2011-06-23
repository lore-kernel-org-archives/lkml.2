Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab1FWMW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:22:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37689 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab1FWMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:22:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ip80ADiIelhC0Hek2rP8eHLW5+GCf6nCdloX3kmrQd7+mWopZBFD+8KV6zA1tk5neI
         TdU0kRnYxg/ZUMivcbLkR6yeXFbiPud1hrgev/7RN2oA1N7YwV73qnXEVIFHUPf+vzqF
         fXDDtghxTaBVrbBUN7IPSGkeMcppltL24BXas=
Date: Thu, 23 Jun 2011 14:22:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110623122253.GM30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210834.GC20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210834.GC20549@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jun 22, 2011 at 11:08:34PM +0200, Oleg Nesterov wrote:
> Kill tracehook_notify_death(), reimplement the logic in its caller,
> exit_notify().
> 
> This also fixes a minor bug, if the exiting task is the group_leader
> and it is traced by its real_parent, tracehook_notify_death() returns
> task->exit_signal or SIGCHLD depending on thread_group_empty(), this
> looks strange.

Maybe we should do the above in a separate patch?

> -	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
> +	if (thread_group_leader(tsk) && tsk->exit_signal != SIGCHLD &&

Hmmm... it probably depends on POV but wouldn't (exit_signal != -1 &&
exit_signal != SIGCHLD) be easier?  The logic here is about demoting
specials sigs to SIGCHLD under certain circumstances and the check is
there to prevent promoting -1 to SIGCHLD.  I agree the detached() is
more distracting than helping but thread_group_leader() seems
unnecessarily indirect.

Thanks.

-- 
tejun
