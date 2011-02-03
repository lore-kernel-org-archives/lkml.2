Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1BCKDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:03:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1BCKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:03:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MrpEdLLUUwULUqdQMrmZrfjdtV7J86PgvVHZfuDRbUZZghutpPITEns4qfPzjQc+2T
         0/05N9/rw4pvVZu/lZt0Dg3DxU9KTfUSZfa07EZTRzOBtCCEV2s2i+VDXoUKwTfVDrNr
         aliCgvgLBoKXiHgSDBrHiUSoa1HUiZygi9fX0=
Date: Thu, 3 Feb 2011 11:02:53 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from
 ptrace_stop() iff the task is trapping for group stop
Message-ID: <20110203100253.GE2570@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-9-git-send-email-tj@kernel.org>
 <20110128213009.340C7183C1E@magilla.sf.frob.com>
 <20110131112634.GG7459@htj.dyndns.org>
 <20110202055711.368B6183D88@magilla.sf.frob.com>
 <20110202105303.GD24115@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202105303.GD24115@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Wed, Feb 02, 2011 at 11:53:03AM +0100, Tejun Heo wrote:
> You'll have to show a lot more details on how to untangle "the entire
> web of assumptions and ramifications" so that we can reverse the
> current priority without causing noticeable behavior differences to
> the existing users.  I don't agree what you suggest is "plain
> obviously desirable" but that's almost beside the point.  I really
> can't see how that would be realistically possible at this point.
> 
> So, can you please elaborate how to reverse that and at the same time
> avoid breaking existing assumptions?

I've been thinking about this and the more I think about it I don't
see how we can make this priority flipping without adversely affecting
the expect userland behavior.

For example, if a gdb traced task is instructed to participate in a
group stop and then hits a ptrace trap, it would have to participate
in the group stop as it enters ptrace trap, right?  gdb's wait(2)
would complete indicating ptrace trap.  After the user tells the task
to continue, the task shouldn't resume until SIGCONT is received;
however, at this point, there's no way for gdb to tell what's going on
with the tracee.  It'll wait with its input prompt disabled until
someone sends SIGCONT from outside to the tracee.  Please note that ^C
wouldn't do anything either in this state.

So, as I wrote before, I don't think we can change this at this point.
If ptrace behaved like that from the beginning, gdb would have behaved
differently and worked around those cases but that hasn't been the
case and I don't see any way we can flip the priority and get away
with it without impacting the current users significantly.

If I'm missing something, please enlighten me.

Thank you.

-- 
tejun
