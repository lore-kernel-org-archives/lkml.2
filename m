Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab1CXSWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988Ab1CXSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:22:32 -0400
Date: Thu, 24 Mar 2011 14:22:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
Message-ID: <20110324182221.GF1239@redhat.com>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
 <20110324084819.GH30812@elte.hu>
 <4D8B6569.2030001@gmail.com>
 <20110324163332.GA2414@elte.hu>
 <4D8B7570.40101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B7570.40101@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 07:46:40PM +0300, Cyrill Gorcunov wrote:
> >> The read of a proper MSR register was missed so instead of a counter the 
> >> configration register is tested (it has ARCH_P4_UNFLAGGED_BIT always cleared) 
> >> and unflagged overflows never have been catched. Fix it by reading a proper 
> >> MSR register.
> > 
> > So what effect does this have on the regular perf user? Please try to describe 
> > the real-life effect of the bug/problem fixed here.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Unflagged overflows never have been catched due to missed read of a register which
> is to signalize about it, and as result unknown nmi may happen leading to
> "Dazen and confused" message. That is what supposed to be in changelog?

I think Ingo is looking for something like this:

When an NMI happens on a P4, the perf nmi handler checks the configuration
register to see if the overflow bit is set or not before taking
appropriate action.  Unfortunately, various P4 machines had a broken
overflow bit, so a backup mechanism was implemented.  This mechanism
checked to see if the counter rolled over or not.

A previous commit that implemented this backup mechanism was broken.
Instead of reading the counter register, it used the configuration
register to determine if the counter rolled over or not.  Reading that bit
would give incorrect results.

This would lead to 'Dazed and confused' messages for the end user when
using the perf tool (or if the nmi watchdog is running).

The fix is to read the counter register before determining if the counter
rolled over or not.

Cheers,
Don
