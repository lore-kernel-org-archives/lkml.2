Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1EMDJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:09:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:58943 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1EMDJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="435365988"
Date: Fri, 13 May 2011 11:09:03 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110513030903.GA26981@sli10-conroe.sh.intel.com>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
 <20110511092848.GE1661@htj.dyndns.org>
 <1305168493.2373.15.camel@sli10-conroe>
 <20110512082159.GB1030@htj.dyndns.org>
 <1305190520.2373.18.camel@sli10-conroe>
 <20110512085922.GD1030@htj.dyndns.org>
 <1305190936.3795.1.camel@edumazet-laptop>
 <20110512090534.GE1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512090534.GE1030@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Thu, May 12, 2011 at 05:05:34PM +0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 12, 2011 at 11:02:15AM +0200, Eric Dumazet wrote:
> > > I don't think @maxfuzzy is necessary there.  I wrote this before but
> > > why can't we track the actual deviation instead of the number of
> > > deviation events?
> > 
> > Thats roughly same thing (BATCH multiplicator factor apart)
> > 
> > Most percpu_counter users for a given percpu_counter object use a given
> > BATCH, dont they ?
> 
> Well, @maxfuzzy is much harder than @batch.  It's way less intuitive.
> Although I haven't really thought about it that much, I think it might
> be possible to eliminate it.  Maybe I'm confused.  I'll take another
> look later but if someone can think of something, please jump right
> in.
there is another problem here, _sum could keep spin if cocurrent updater
is running.

We could slightly change Eric's idea, how about something like this:

s64 __percpu_counter_sum(struct percpu_counter *fbc)
{
	retry_times = 0;
retry:
	old_seq = fbc->seq;
	sum = do_sum()
	if (old_seq != fbc->seq && retry_times++ < MAX_RETRY)
		goto retry;
	return sum;
}
MAX_RETRY could be nr_cpu_ids. The rational here is if cocurrent updater
keeps running, we can't get accurate sum, so just don't try hard.

Thanks,
Shaohua
