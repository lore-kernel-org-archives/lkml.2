Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0FXKGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:06:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36041 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab0FXKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:06:52 -0400
From: Andi Kleen <andi@firstfloor.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 50/52] mm: implement per-zone shrinker
References: <20100624030212.676457061@suse.de>
	<20100624030733.676440935@suse.de>
Date: Thu, 24 Jun 2010 12:06:50 +0200
In-Reply-To: <20100624030733.676440935@suse.de> (npiggin@suse.de's message of
	"Thu, 24 Jun 2010 13:03:02 +1000")
Message-ID: <87aaqkagn9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> Allow the shrinker to do per-zone shrinking. This means it is called for
> each zone scanned. The shrinker is now completely responsible for calculating
> and batching (given helpers), which provides better flexibility.

Beyond the scope of this patch, but at some point this probably needs
to be even more fine grained. With large number of cores/threads in 
each socket a "zone" is actually shared by quite a large number 
of CPUs now and this can cause problems.

> +void shrinker_add_scan(unsigned long *dst,
> +			unsigned long scanned, unsigned long total,
> +			unsigned long objects, unsigned int ratio)
> +{
> +	unsigned long long delta;
> +
> +	delta = (unsigned long long)scanned * objects * ratio;
> +	do_div(delta, total + 1);
> +	delta /= (128ULL / 4ULL);

Again I object to the magic numbers ...

> +		nr += shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
> +	if (nr >= 10)
> +		goto again;

And here.

Overall it seems good, but I have not read all the shrinker callback
changes in all subsystems.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
