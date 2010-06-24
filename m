Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0FXQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:09:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0FXQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:09:43 -0400
Date: Thu, 24 Jun 2010 18:09:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mauro@elte.hu" <mauro@elte.hu>
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624160937.GQ578@basil.fritz.box>
References: <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
 <20100624132032.GA4474@kryptos.osrc.amd.com>
 <20100624133323.GN578@basil.fritz.box>
 <20100624134609.GB30323@elte.hu>
 <20100624140143.GO578@basil.fritz.box>
 <20100624154124.GA6647@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624154124.GA6647@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 05:41:24PM +0200, Borislav Petkov wrote:
> > If you don't do something
> > (like killing or recovery) you could end up in a loop or consume
> > corrupted data or something else bad. 
> > 
> > So the error has to have a fail safe path from detection to handling.
> 
> So we are talking about a more involved and "could-sleep" error
> recovery.

That's one case, there are other too.

> 
> > That's quite different from logging or performance counting etc.
> > where dropping events on overload is normal and expected.
> 
> So I went back and reread the whole thread, and correct me if I'm
> wrong but the whole run softirq after NMI has one use case for now -
> "could-sleep" error handling for MCEs _only_ on x86. So you're changing

Nope, there are multiple use cases. Today it's background MCE
and possibly perf if it ever decides to share code
with the rest of the kernel instead of wanting to be Bork of Linux. 
Future ones would be more MCE errors and also non MCE errors like NMIs.

> a bunch of generic and x86 kernel code just for error handling. Hmm,
> that's a kinda big hammer in my book.

Actually no, it would just make the current code slightly cleaner
and somewhat more general.  But for most cases it works without it.
> 
> A slimmer solution is a much better way to go, IMHO. I think Peter said
> something about irq_exit(), which should be just fine.

The "slimmer solution" is there, but it has some limitations.
I merely said that softirqs would be useful for solving these limitations
(but are not strictly needed)

Anyways slimmer solution was even originally proposed, 
just some of the earlier review proposed softirqs instead.
So Ying posts softirqs and then he gets now flamed for posting
softirqs.  Overall there wasn't much consistency in the suggestions,
three different reviewers suggested three incompatible approaches.

Anyways if there are no softirqs that's fine too, the error
handler can probably live with not having that.

> But AFAICT an arch-specific solution would be even better, e.g.
> if you call into your deferred work helper from paranoid_exit in
> <arch/x86/kernel/entry_64.S>. I.e, something like

Yes that helps for part of the error handling (in fact this
has been implemented), but that does not solve the self interrupt
problem which requires delaying until next cli.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
