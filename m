Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0EaI2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:28:11 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25694 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0EaI2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:28:09 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527154435.GS22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk> <20100527072240.GM22536@laptop>
	 <1274957469.13159.20.camel@localhost> <20100527120737.GN22536@laptop>
	 <1274973693.15516.67.camel@localhost>  <20100527154435.GS22536@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 11:25:52 +0300
Message-ID: <1275294352.2678.102.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 May 2010 08:27:56.0282 (UTC) FILETIME=[2BAC15A0:01CB009B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 01:44 +1000, Nick Piggin wrote:
> > if (supers_dirty)
> > 	bdi_arm_supers_timer();
> > set_current_state(TASK_INTERRUPTIBLE);
> > schedule();

> But we cannot do the above, because again the timer might go off
> before we set current state. We'd lose the wakeup and never wake
> up again.
> 
> Putting it inside set_current_state() should be OK. I suppose.

Hmm, but it looks like we cannot do that either. If we do

set_current_state(TASK_INTERRUPTIBLE);
if (supers_dirty)
	bdi_arm_supers_timer();
schedule();

and the kernel is preemptive, is it possible that we get preempted
before we run 'bdi_arm_supers_timer()', but after we do
'set_current_state(TASK_INTERRUPTIBLE)'. And we will never wake up if
the timer armed in mark_sb_dirty() went off.

So it looks like this is the way to go:

/*
 * Disable preemption for a while to make sure we are not
 * preempted before the timer is armed.
 */
preempt_disable();
set_current_state(TASK_INTERRUPTIBLE);
if (supers_dirty)
	bdi_arm_supers_timer();
preempt_enable();
schedule();

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

