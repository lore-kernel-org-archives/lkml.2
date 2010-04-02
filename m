Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0DBSWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:22:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55175 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0DBSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:22:36 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <greg@kroah.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
	<tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
	<20100331151719.8a92b302.akpm@linux-foundation.org>
	<20100402160447.GA19920@redhat.com>
	<20100402160512.GB19920@redhat.com>
	<alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 02 Apr 2010 11:22:29 -0700
In-Reply-To: <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org> (Linus Torvalds's message of "Fri\, 2 Apr 2010 10\:46\:24 -0700 \(PDT\)")
Message-ID: <m14ojtogt6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, stable@kernel.org, sukadev@us.ibm.com, serue@us.ibm.com, linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, catalin.marinas@arm.com, greg@kroah.com, alan@linux.intel.com, akpm@linux-foundation.org, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 2 Apr 2010, Oleg Nesterov wrote:
>>
>> release_one_tty(tty) can be called when tty still has a reference
>> to pgrp/session. In this case we leak the pid.
>
> Hmm. Maybe we should have cleared this in tty_release() already. We 
> already do some of the session clearing there (but we clear the session in 
> the _tasks_ associated with the tty, not the tty session pointer).
>
> But:
>
>> The patch needs the ack from someone who understand tty magic.
>
> I think the patch is simpler than worrying about the much more complex 
> release logic. So I think I actually prefer this patch over something that 
> tries to be clever in tty_release.
>
> We might even push it into "free_tty_struct()", although I think that the 
> only non-release_one_tty() callers of that are the ones that allocated the 
> tty but due to some failure never connected it to anything. So on the 
> whole I think you picked the right spot.
>
> So I'll ACK it. But maybe Alan sees some problem/issue I didn't see.

I agree.   However we made it to release_one_tty with pids we need
to free them, before we free the tty structure itself.

My general paranoia would suggest setting the pids to NULL.  So that
we don't have the chance of a use after free.

Eric
