Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1BVToE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:44:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1BVToB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:44:01 -0500
Date: Tue, 22 Feb 2011 20:43:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110222194325.GE31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63F6C0.7060204@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
> OK, these patches applied together against upstream didn't cause a crash 
> but I did observe:
> 
> significant slowdowns of MIDI playback (moreso than in previous cases, 
> and with less than 20 Meg of swap file in use);
> 
> kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
> 
> If I should try only one of the patches or something else entirely, 
> please let me know.

For Mel: with z1, kswapd used only 0.1-3.9 percent of CPU while he
loaded other applications.

We may need a way to put kswapd in all uncompactable mode to solve
this, logic 3 just trying not to disable the all unreclaimable logic
seems not enough. I.e. if compact_zone_order doesn't return
COMPACT_COMPLETE, stop the compaction loop in kswapd. Then we can put
back in the COMPACT_MODE_KSWAPD return COMPACT_CONTINUE in
compact_finished as the caller will throttle it (and it won't run more
than one scan before putting kswapd to sleep in all uncompactable mode).
