Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1AaPlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:41:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1AaPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sk8+BODss4eB/CSVuTufWsVUWWgjy+WKIqXU9hDOW3VElYMJE1zSh7a+DkMrP1HsdO
         lBuaNmFPvoDwgrP7c4p/PCWvmOiYWaXiMFjFlQAEl8jik3fXR5ehNDnRGeBc84TgA1r3
         xgGy6yFIRq3tx+OfftOkb5KjoLMY/NCBFpXEU=
Date: Mon, 31 Jan 2011 16:41:17 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110131154117.GK7459@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021417.D347A1807B7@magilla.sf.frob.com>
 <20110127154600.GE24925@htj.dyndns.org>
 <20110127174857.GG24925@htj.dyndns.org>
 <20110128204030.52D31183C1E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128204030.52D31183C1E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 28, 2011 at 12:40:30PM -0800, Roland McGrath wrote:
> > Okay, just finished ran make check with and without the patchset.
> > Without the patchset, 2.6.38-rc2 failed five tests.  
> 
> Hmm.  I didn't think we were in that poor a state, but it has been quite a
> while since I looked.  I wonder if that's a regression from a few releases
> back, or what.  Oleg and Jan should know better than I do about the state
> of these tests.

Also, the first test of xcheck seems to enter infinite loop.

> > With the patchset six.  The one extra test which failed was
> > attach-sigcont-wait because the tracee now always enters TRACED after
> > PTRACE_ATTACH, which I think is the correct behavior because the previous
> > behavior where a stopped task honors SIGCONT unconditionally if it was
> > delivered before the next ptrace call (any operation other than detach)
> > doesn't make any sense to me in addition to the fact that it was buggy
> > regarding the arch hook.
> 
> Well, I can't say I'm at all sure I agree with your assessment about that.
> But we can investigate further before I make any particular assertions.
> 
> > Is there an actual use case which requires this behavior?  We can try
> > to emulate the original behavior but I don't think it's a sane one.
> 
> Most of those cases were added when Jan ran into a particular problem while
> working on GDB, and some of them from issues that arose with ptrace.  Jan
> is probably the person who knows best about the requirements each test was
> meant to verify.

Jan, do you care to chime in?

> > Another difference was how stopped-detach-sleeping failed.  It failed
> > both with and without the patchset but with the patchset it triggered
> > an assert().  The difference was because the assert() was testing
> > whether the task was in STOPPED state after attach - it's now in
> > TRACED state instead.  With the assert removed, it failed the same
> > way.
> 
> This is probably something that can change in the test.  I think some of
> those /proc/pid/status checks in the tests were either just to match
> expectations based on manifest kernel behavior, but they might also have
> been because it really did matter somehow and it was just easier to discern
> that way than to write a test that reliably found the important race
> condition or whatever it was.  So again we need Jan to help us understand
> the intent of the test and the specific GDB requirements it represents.

I see.  Yeah, if there are users which expect /proc/pid/status to be
certain value, we can either emulate it or delay TRACED transition to
the next PTRACE call *after* ATTACH/wait(2) sequence, but I think both
are quite ugly and would like to avoid if at all possible.

Thank you.

-- 
tejun
