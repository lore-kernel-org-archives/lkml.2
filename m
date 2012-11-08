Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2KHIgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:36:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2KHIf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 03:35:59 -0500
Date: Thu, 8 Nov 2012 09:35:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: oom: fix totalpages calculation for
 memory.swappiness==0
Message-ID: <20121108083454.GA30792@dhcp22.suse.cz>
References: <20121011085038.GA29295@dhcp22.suse.cz>
 <1349945859-1350-1-git-send-email-mhocko@suse.cz>
 <20121015220354.GA11682@dhcp22.suse.cz>
 <20121107141025.2ac62206.akpm@linux-foundation.org>
 <20121107224640.GE26382@dhcp22.suse.cz>
 <20121107145340.b45a387c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107145340.b45a387c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-11-12 14:53:40, Andrew Morton wrote:
> On Wed, 7 Nov 2012 23:46:40 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > > Realistically, is anyone likely to hurt from this?
> > 
> > The primary motivation for the fix was a real report by a customer.
> 
> Describe it please and I'll copy it to the changelog.

The original issue (a wrong tasks get killed in a small group and memcg
swappiness=0) has been reported on top of our 3.0 based kernel (with
fe35004f backported). I have tried to replicate it by the test case
mentioned https://lkml.org/lkml/2012/10/10/223.

As David correctly pointed out (https://lkml.org/lkml/2012/10/10/418)
the significant role played the fact that all the processes in the group
have CAP_SYS_ADMIN but oom_score_adj has the similar effect. 
Say there is 2G of swap space which is 524288 pages. If you add
CAP_SYS_ADMIN bonus then you have -15728 score for the bias. This means
that all tasks with less than 60M get the minimum score and it is tasks
ordering which determines who gets killed as a result.

To summarize it. Users of small groups (relatively to the swap size)
with CAP_SYS_ADMIN tasks resp. oom_score_adj are affected the most
others might see an unexpected oom_badness calculation.
Whether this is a workload which is representative, I don't know but
I think that it is worth fixing and pushing to stable as well.
-- 
Michal Hocko
SUSE Labs
