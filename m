Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1EMEiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:38:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:1507 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1EMEh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="1656618"
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110512090534.GE1030@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 12:37:57 +0800
Message-ID: <1305261477.2373.45.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 17:05 +0800, Tejun Heo wrote:
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
Hmm, looks Eric's approach doesn't work. because we want to remove lock
in _add, checking seq in _sum still races with _add.

can we do something like this:
void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
{
        s64 count;

        preempt_disable();
        count = __this_cpu_read(*fbc->counters) + amount;
        if (count >= batch || count <= -batch) {
                while (1) {
                        atomic_inc(&fbc->add_start);
                        if (atomic_read(&fbc->sum_start) != 0)
                                atomic_dec(&fbc->add_start);
                        else
                                break;
                        while (atomic_read(&fbc->sum_start) != 0)
                                cpu_relax();
                }

                atomic64_add(count, &fbc->count);
                __this_cpu_write(*fbc->counters, 0);
                atomic_dec(&fbc->add_start);
        } else {
                __this_cpu_write(*fbc->counters, count);
        }
        preempt_enable();
}

s64 __percpu_counter_sum(struct percpu_counter *fbc)
{
        s64 ret = 0;
        int cpu;
        int old_seq;
        s64 old_count;

        atomic_inc(&fbc->sum_start);
        while (atomic_read(&fbc->add_start) != 0)
                cpu_relax();

        old_count = atomic64_read(&fbc->count);

        for_each_online_cpu(cpu) {
                s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
                ret += *pcount;
        }
        ret += atomic64_read(&fbc->count);
        atomic_dec(&fbc->sum_start);
        return ret;
}
if _add finds _sum is in progress, it gives up and and wait _sum. if
_sum finds _add is in progress, it waits _add to give up or end. We let
_add waits _sum here, because _sum is seldom called. If _sum waits _add,
_sum might run a dead loop. Maybe we need a spinlock to protect
concurrent _sum too. Anything wrong here?

