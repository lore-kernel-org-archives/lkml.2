Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2LSOsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:48:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33479
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516Ab2LSOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:48:00 -0500
Message-ID: <50D1D373.5060301@kernel.dk>
Date: Wed, 19 Dec 2012 15:47:15 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Shaohua Li <shli@fusionio.com>, Neil Brown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
References: <50CF89EB.2030109@kernel.dk> <20121218092554.GA3823@gmail.com> <50D056A5.3040501@kernel.dk> <CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com>
In-Reply-To: <CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-18 17:49, Linus Torvalds wrote:
> On Tue, Dec 18, 2012 at 3:42 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Bah. Does the below fix it up for you?
> 
> Grr. This is still bullshit.
> 
> Doing this:
> 
>     alignment = sector << 9;
> 
> is fundamentally crap, because 'sector_t' may well be 32-bit
> (non-large-block device case). And we're supposed (surprise surprise)
> to be able to handle devices larger than 4GB in size.
> 
> So doing *any* of these calculations in bytes is pure and utter crap.
> You need to do them in sectors. That's what "sector_t" means, and
> that's damn well how everything should work. Anything that works in
> bytes is simply pure crap. And don't talk to me about 64-bit math and
> doing it in "u64" or "loff_t", that's just utterly moronic too.
> 
> Besides, "sector_div()" is only sensible when you're looking for the
> remainder of a sector number. That's true in the first case (sector
> really is a sector number - it's the starting sector of the
> partition), but the source of alignment and granularity are actually
> just "unsigned int" (and that's in bytes, not sectors), so using
> sector_t afterwards is crazy too. You should have used just '%'.
> Looking around, there are other places where this idiocy happens too
> (blkdev_issue_discard() seems to think the granularity/alignments are
> sector_t's too, for example).
> 
> Anyway, here's a patch to fix the crazy types and the bogus second
> "sector_div()". It's whitespace-damaged, because not only have I not
> tested it, I also think somebody needs to look at things in general.
> The whole "discard_alignment" handling is extremely odd. I don't think
> it should be called "alignment" at all - because it isn't. It's an
> alignment *offset*. Look at the normal (non-discard) case, where it's
> called "alignment_offset" like it should be.
> 
> So the math is confused, the types are confused, and the naming is
> confused. Please, somebody check this out, because now *I* am
> confused.

It should all just be in sectors. The limits set are in bytes (could be
sectors too, but doesn't matter so much), but any interface operates in
sectors.

I'm happy with your proposed fix. I think you should shove it in there,
then I'll make sure we get it cleaned up for 3.9.

> And btw, that whole commit happened too f*cking late too. When I get a
> pull request, it should damn well have been tested already, and it
> should have been developed *before* the merge window started. Not the
> day before the pull request.

Of course it's been tested. Granted it got moved over too late (as 1 of
2 that did), but I've run the branch on a multitude of systems.
Apparently none of them hit the case of having a zero granularity
reported, so never hit the bug.

-- 
Jens Axboe

