Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab1IKCFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 22:05:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39333 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682Ab1IKCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 22:05:30 -0400
Date: Sun, 11 Sep 2011 11:05:23 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in
 'data' parameter
Message-ID: <20110911020523.GL29319@htj.dyndns.org>
References: <201109072340.31460.vda.linux@googlemail.com>
 <20110908004438.GC3987@mtj.dyndns.org>
 <20110908181747.GA28120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908181747.GA28120@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 08, 2011 at 08:17:47PM +0200, Oleg Nesterov wrote:
> > There are places which assume ->ptrace is protected by siglock.
> 
> Really? Once again, I agree. But _afaics_ currently this is not strictly
> needed. PT_PTRACED/PT_SEIZED should not go away under ->siglock, yes, but
> it seems that it is fine to set them.

Hmmm.... I haven't checked each direction.  Maybe we don't strictly
need it on setting it but I definitely was assuming that ->ptrace was
protected by siglock while coding recent ptrace changes.  Can't the
following happen?

* ptracer seizes child, sets PT_PTRACED and then OR PT_SEIZED.

* ptracee enters signal delivery path with group stop scheduled.
  PT_PTRACED is visible and group stop is transformed into
  JOBCTL_TRAP_STOP.

* ptracee enters do_jobct_trap().  PT_SEIZED is still not visible and
  it takes the path for the old behavior.

* ptracer SEIZE'd and expects PTRACE_EVENT_STOP but it gets the old
  no-siginfo trap.

> > and linking are protected by siglock
> 
> Hmm. Could you explain this? Why do want __ptrace_link under ->siglock ?

Because it's much simpler to assume that w/ siglock locked, everything
including ->parent is set up properly w.r.t. ->ptrace.

Thanks.

-- 
tejun
