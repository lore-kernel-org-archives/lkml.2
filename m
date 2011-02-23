Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1BWV0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:26:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1BWV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:26:22 -0500
Date: Wed, 23 Feb 2011 22:25:41 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110223212541.GV31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
 <20110223165550.GP31195@random.random>
 <4D65691E.9080600@internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D65691E.9080600@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 06:37:58AM +1030, Arthur Marsh wrote:
> kswapd-high_wmark + compaction-kswapd-2 - kswapd0 CPU up to 11 percent 
> and slightly less pronounced slowdowns of MIDI playback compared to 
> previous patches.
> 
> kswapd-high_wmark + compaction-no-kswapd-3 - kswapd0 CPU up to 2.3 
> percent and no noticable slowdown of MIDI playback.
> 
> Mel Gorman's mm/compaction.c patch - kswapd0 CPU up to 20 percent and no 
> noticable slowdown of MIDI playback.
> 
> Thanks everyone for the help with this.

Ok then I think it's safer to go with compaction-no-kswapd-3.

I also created a git tree in case anybody else wants to test in easier
way.

git clone --reference linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
(or "git clone git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git")
cd aa
git checkout -f 3d74399aaece29047beba13a81650538af8db67a
(compaction-kswapd+compaction_alloc_lowlat)
git checkout -f f048d0082bd3c6a1cc3f5e67aa5ef83d1561ec27
(compaction-no-kswapd+rest+compaction_alloc_lowlat)
git checkout -f 859e705548f7377b1803b05b2904bae77495fd1e (only
compaction_alloc_lowlat)

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog;h=3d74399aaece29047beba13a81650538af8db67a
http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog;h=f048d0082bd3c6a1cc3f5e67aa5ef83d1561ec27
http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog;h=859e705548f7377b1803b05b2904bae77495fd1e

Arthur could you give one more spin to the
3d74399aaece29047beba13a81650538af8db67a tree? (or do you prefer an
updated patch compaction-kswapd-3?)

I'd like to get 3d74399aaece29047beba13a81650538af8db67a tested again
because I did one more modification included in the git version
compared to the patch version (nr_slab was not always initialized and
it could lead to slightly higher kswapd cpu load than intended). I
doubt it will help though (just in case).

Mel what you think? If f048d0082bd3c6a1cc3f5e67aa5ef83d1561ec27 is
still the only one that shows no regression, I think it's safe to
apply it to 2.6.38 and revert the compaction in kswapd feature. Then
we can add compaction to kswapd later with no hurry.

Thanks a lot for the help and quick feedback!
Andrea
