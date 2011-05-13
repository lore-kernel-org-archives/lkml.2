Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1EMF3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:29:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:57609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab1EMF3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:29:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="435413702"
Date: Fri, 13 May 2011 13:28:59 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110513052859.GA11088@sli10-conroe.sh.intel.com>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
 <20110511092848.GE1661@htj.dyndns.org>
 <1305168493.2373.15.camel@sli10-conroe>
 <20110512082159.GB1030@htj.dyndns.org>
 <1305190520.2373.18.camel@sli10-conroe>
 <20110512085922.GD1030@htj.dyndns.org>
 <1305190936.3795.1.camel@edumazet-laptop>
 <20110512090534.GE1030@htj.dyndns.org>
 <1305261477.2373.45.camel@sli10-conroe>
 <1305264007.2831.14.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1305264007.2831.14.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, May 13, 2011 at 01:20:06PM +0800, Eric Dumazet wrote:
> Le vendredi 13 mai 2011 à 12:37 +0800, Shaohua Li a écrit :
> > On Thu, 2011-05-12 at 17:05 +0800, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Thu, May 12, 2011 at 11:02:15AM +0200, Eric Dumazet wrote:
> > > > > I don't think @maxfuzzy is necessary there.  I wrote this before but
> > > > > why can't we track the actual deviation instead of the number of
> > > > > deviation events?
> > > > 
> > > > Thats roughly same thing (BATCH multiplicator factor apart)
> > > > 
> > > > Most percpu_counter users for a given percpu_counter object use a given
> > > > BATCH, dont they ?
> > > 
> > > Well, @maxfuzzy is much harder than @batch.  It's way less intuitive.
> > > Although I haven't really thought about it that much, I think it might
> > > be possible to eliminate it.  Maybe I'm confused.  I'll take another
> > > look later but if someone can think of something, please jump right
> > > in.
> > Hmm, looks Eric's approach doesn't work. because we want to remove lock
> > in _add, checking seq in _sum still races with _add.
> > 
> 
> Why ?
> 
> I'll code a patch, I believe it should work.
I thought your proposal is:
in _add
{
	if (count >= batch || count <= -batch) {
		fbc->seq_count++;
               atomic64_add(count, &fbc->count);
-------->
                __this_cpu_write(*fbc->counters, 0);
	}
}

in _sum
{
restart:
	oldseq = fbc->seqcount;
	smp_rmb();
	do_sum();
	smp_rmb()
	newseq = fbc->seqcount;
	if (newseq - oldseq >= maxfuzzy)
		goto restart;
	return ret;
} 
if _sum run between above line marked in _add, then the seqcount check
doesn't work, we still have deviation Tejun pointed out.

Thanks,
Shaohua
