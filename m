Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1JTCBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:01:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1JTCBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:01:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 Oct 2011 10:59:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFD] Isolated memory cgroups again
Message-Id: <20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111020013305.GD21703@tiehlicka.suse.cz>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011 18:33:09 -0700
Michal Hocko <mhocko@suse.cz> wrote:

> Hi all,
> this is a request for discussion (I hope we can touch this during memcg
> meeting during the upcoming KS). I have brought this up earlier this
> year before LSF (http://thread.gmane.org/gmane.linux.kernel.mm/60464).
> The patch got much smaller since then due to excellent Johannes' memcg
> naturalization work (http://thread.gmane.org/gmane.linux.kernel.mm/68724)
> which this is based on.

Yes, Johannes' work will make isolation smarter.


> I realize that this will be controversial but I would like to hear
> whether this is strictly no-go or whether we can go that direction (the
> implementation might differ of course).
> 
> The patch is still half baked but I guess it should be sufficient to
> show what I am trying to achieve.
> The basic idea is that memcgs would get a new attribute (isolated) which
> would control whether that group should be considered during global
> reclaim.
> This means that we could achieve a certain memory isolation for
> processes in the group from the rest of the system activity which has
> been traditionally done by mlocking the important parts of memory.
> This approach, however, has some advantages. First of all, it is a kind
> of all or nothing type of approach. Either the memory is important and
> mlocked or you have no guarantee that it keeps resident. 
> Secondly it is much more prone to OOM situation.
> Let's consider a case where a memory is evictable in theory but you
> would pay quite much if you have to get it back resident (pre calculated
> data from database - e.g. reports). The memory wouldn't be used very
> often so it would be a number one candidate to evict after some time.
> We would want to have something like a clever mlock in such a case which
> would evict that memory only if the cgroup itself gets under memory
> pressure (e.g. peak workload). This is not hard to do if we are not
> over committing the memory but things get tricky otherwise.
> With the isolated memcgs we get exactly such a guarantee because we would
> reclaim such a memory only from the hard limit reclaim paths or if the
> soft limit reclaim if it is set up.
> 
> Any thoughts comments?
> 

I can only say
 - it can be implemented in a clean way.
 - maybe customers wants it.
 - This kinds of "mlock" can be harmful and make system admin difficult.
 - I'm not sure there will be a chance for security issue, DOS attack.

Hmm...if the number of isolated pages can be shown in /proc/meminfo,
I'll not have strong NACK.

But I personally think we should make softlimit better rather than
adding new interface. If this feature can be archieved when setting
softlimit=UNLIMITED, it's simple. And Johannes' work will make this
easy to be implemented.
(total rewrite of softlimit should be required...I think.)

Thanks,
-Kame

