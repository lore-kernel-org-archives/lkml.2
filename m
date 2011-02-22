Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1BVIR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:17:58 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:60418 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1BVIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:17:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h4B/o+ZjD6P27R1VKqKj36MnTgBTpEfqHaUTg2UVatDXkBP01ZJR7T7gjYVwFID2gX
         eNjWsr3ngEEb/TwnXkKkDy2PWa5GJsQsw4cL/LR951nhAoxZY6jqI4HbEH9PP2wnHb/8
         sevTVwELCg+3CHW0NFFMvtAPNJG3epJ8XNkA8=
Date: Tue, 22 Feb 2011 09:17:52 +0100
From: Tejun Heo <tj@kernel.org>
To: "pantherchen@versanet.de" <pantherchen@versanet.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110222081752.GP31267@htj.dyndns.org>
References: <4D62CE9C.7090806@versanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62CE9C.7090806@versanet.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Dmitry and lkml)

Hello,

On Mon, Feb 21, 2011 at 09:44:12PM +0100, pantherchen@versanet.de wrote:
> I'm experiencing a significant boot time regression (almost +50%)
> starting with 2.6.38-rc1 (see boot charts before [0], and after [1]
> - note the long uninterruptible sleep of kworker/0:1).

Comparing the two boot charts, the uninterruptible sleeps in
kowrker/0:1 seems to be the same one from kseriod.  They're about the
same duration.  kseriod is replaced with a work item, so that explains
it.

> After doing some bisecting and thorough testing this merge seems to
> be the first one showing the regression: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=23d69b09b78c4876e134f104a3814c30747c53f1
> ("Merge branch 'for-2.6.38' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq").
> 
> However, a kernel built from the branch 'for-2.6.38' at
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq doesn't show the
> behavior.
> 
> I also tried to cherry-pick those 33 commits, applying them to the
> last good commit from Linus' tree (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4ead36407b41eae942c8c9f70ef963cd369c90e2)
> and it also doesn't show the regression.
> 
> Do you know what's going on here? I'm just an end user and I've
> definitely run out of ideas.
> 
> Thanks in advance for your help,
> 
> Hernando Torque
> Thanks
> 
> [0]: http://launchpadlibrarian.net/64639927/27-12-intel.png
> [1]: http://launchpadlibrarian.net/64640030/38-4-intel.png

>From the boot chart, two things are noticeable.

1. kworker/0:1's uninterruptible sleeps start later than kserio's.

   It could be that cpu 0 was busy running other stuff and thus cmwq
   delayed executing serio_event_work; however, if we look at the CPU
   usage, that doesn't seem likely.  The CPU is not busy at all and if
   the CPU isn't busy, cmwq wouldn't introduce any noticeable delay in
   work item execution.

   Another possibility is the rescuer concurrency depletion bug is
   delaying execution of queued work items early during boot.  This
   was fixed recently.  Can you please give a shot at 2.6.38-rc6 and
   see whether anything is different?

2. Most of the delay is caused by xorg starting up much later.  xorg
   seems to start up in parallel with the kseriod sleeps in 2.6.37 but
   on 2.6.38 it seems to wait for the serio_event_work to finish.

   I have no idea what xorg is waiting for.  Dmitry, any clue?

Thanks.

-- 
tejun
