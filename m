Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1CYGxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:53:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1CYGxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ob5/suwH8PQFlvYgbe6Tx5pOl/LY0t9LWEXs9LBuLaLehrYO+9jWrY/JcWN35Dtdan
         +unM7RnOIa3bsKmBxN7q3NQtTMN7tlATtGSjRfboR1E6Fcb5nmtIGaMpIer+dh6XiOx+
         bDDGTMSWxcYdzDUdQGEkjRhWe5ec9nqkWUXFQ=
Date: Fri, 25 Mar 2011 07:53:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325065300.GB1409@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325033956.GB9313@home.goodmis.org>
 <AANLkTikayCJyYVo1MNpg1EN+88bSQNOu=NPW5s_j4shD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikayCJyYVo1MNpg1EN+88bSQNOu=NPW5s_j4shD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven, Linus.

On Thu, Mar 24, 2011 at 09:38:58PM -0700, Linus Torvalds wrote:
> On Thu, Mar 24, 2011 at 8:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > But now, mutex_trylock(B) becomes a spinner too, and since the B's owner
> > is running (spinning on A) it will spin as well waiting for A's owner to
> > release it. Unfortunately, A's owner is also spinning waiting for B to
> > release it.
> >
> > If both A and B's owners are real time tasks, then boom! deadlock.
> 
> Hmm. I think you're right. And it looks pretty fundamental - I don't
> see any reasonable approach to avoid it.

Hmmm... I have an idea.  Will play with it a bit and post if it works
out okay.

> I think the RT issue is a red herring too - afaik, you can get a
> deadlock with two perfectly normal processes too. Of course, for
> non-RT tasks, any other process will eventually disturb the situation
> and you'd get kicked out due to need_resched(), but even that might be
> avoided for a long time if there are other CPU's - leading to tons of
> wasted CPU time.

Yeap, need_resched() currently is the only thing which limits the
duration of spinning when the owner continues to run.

Thanks.

-- 
tejun
