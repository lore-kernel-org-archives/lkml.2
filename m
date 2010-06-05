Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0FERmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0FERmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:42:20 -0400
Date: Sat, 5 Jun 2010 19:40:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
	buffer mechanism
Message-ID: <20100605174034.GA13506@redhat.com>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net> <4C08BCB5.7020201@bitmath.org> <20100604191308.GA10942@redhat.com> <4C09574B.3030807@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C09574B.3030807@bitmath.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 06/04, Henrik Rydberg wrote:
>
> But additional usage documentation ought to be
> in place, in other words. Noted.

Yes, thanks.

Especially a small example (even in pseudo-code) in buflock.h can help
the reader to quickly understand how this buflock actually works.

> > Whatever we do, buflock_read() can race with the writer and read
> > the invalid item.
>
> True. However, one could argue this is a highly unlikely case given the
> (current) usage.

Agreed, but then I'd strongly suggest you to document this in the header.
The possible user of this API should know the limitations.

> Or, one could remedy it by not wrapping the indexes modulo SIZE.

You mean, change the implementation? Yes.

One more question. As you rightly pointed out, this is similar to seqlocks.
Did you consider the option to merely use them?

IOW,
	struct buflock_writer {
		seqcount_t	lock;
		unsigned int	head;
	};

In this case the implementation is obvious and correct.

Afaics, compared to the current implentation it has the only drawback:
the reader has to restart if it races with any write, while with your
code it only restarts if the writer writes to the item we are trying
to read.

> Regarding the barriers used in the code, would it be possible to get a picture
> of exactly how bad those operations are for performance?

Oh, sorry I don't know, and this obvioulsy differs depending on arch.
I never Knew how these barriers actually work in hardware, just have
the foggy ideas about the "side effects" they have ;)

And I agree with Dmitry, the last smp_Xmb() in buflock_write/read looks
unneeded. Both helpers do not care about the subsequent LOAD/STORE's.

write_seqcount_begin() has the "final" wmb, yes. But this is because
it does care. We are going to modify something under this write_lock,
the result of these subsequent STORE's shouldn't be visible to reader
before it sees the result of ++sequence.

> Is it true that a
> simple spinlock might be faster on average, for instance?

May be. But without spinlock's the writer can be never delayed by
reader. I guess this was your motivation.

Oleg.

