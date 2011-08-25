Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1HYQLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:11:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39447 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1HYQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:11:33 -0400
Date: Thu, 25 Aug 2011 18:11:19 +0200
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825161119.GK2803@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-7-git-send-email-tj@kernel.org>
 <20110824223412.GG28444@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824223412.GG28444@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Wed, Aug 24, 2011 at 03:34:12PM -0700, Matt Helsley wrote:
> > -	/* We don't want this task to be frozen prematurely */
> > -	clear_freeze_flag(tsk);
> 
> This patch doesn't look quite right. Perhaps that's because I'm
> unclear why any of the freezer flags matter in the do_exit() path. How
> can the task enter the refrigerator in do_exit()? Isn't it true that
> we don't enter the syscall return path and thus can't freeze
> anyway (the last thing it should do is schedule())? Or is this another
> kthread quirk?

There are paths where try_to_freeze() is called explicitly.  None of
those is called from exit path AFAICT but it is a theoretical
possibility and I think it isn't a terrible idea to explicitly declare
an exiting task unfreezable.

> Couldn't TIF_FREEZE already be set? Setting PF_NOFREEZE only ensures
> the flag won't get set "after" this point. To fix this I think we'd need
> something more like:
> 
> 	current->flags |= PF_NOFREEZE;
> 	smp_wmb();
> 	clear_freeze_flag(tsk);

TIF_FREEZE being set doesn't matter all that much.  Ultimately,
PF_NOFREEZE is observed by the task itself.  freezing() is false - it
either doesn't enter refrigerator at all or exits immediately without
scheduling out.

> This patch also fiddles with the timing of adjusting or checking three
> different pieces of task state:
> 
> 	exit_state
> 	flags (PF_NOFREEZE)
> 	thread flags (TIF_FREEZE)
> 
> each of which get set/cleared at different times from the new
> line adding PF_NOFREEZE to the flags. So I'm a little nervous that
> we might be missing some important details.

Sure, that's one of the problems I wanted to clarify with this patch
series.  The rules are quite simple now.

* Whether a task enters and stays inside freezer is determined by
  freezing().

* Related PF_ flags are manipulated only by the task itself and thus
  the latest state is always visible when the task tests freezing().

* Freezer trying to freeze or thaw a task updates states and
  freezing() result reflects the change considering both the task's
  freezing settings and the freezing conditions in effect.  Freezer is
  responsible for ensuring the target task goes through at least one
  freezing() test after the state is updated.

So, no race condition.

Thanks.

-- 
tejun
