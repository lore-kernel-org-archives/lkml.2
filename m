Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0FAIt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:49:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:49167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0FAIt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:49:58 -0400
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <1275380202.27810.26214.camel@twins>
References: <20100601073343.GQ9453@laptop>
	 <1275380202.27810.26214.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 10:49:54 +0200
Message-ID: <1275382194.27810.26330.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 10:16 +0200, Peter Zijlstra wrote:
> I'd have to again look at wth happens to ->cpus_allowed, but I guess
> it should be fixable

Ah, I remember, cgroup_clone was a massive pain, Serge said he'd wanted
to kill that, but I don't think that ever happened.

    copy_process():
      if (current->nsproxy != p->nsproxy)
         ns_cgroup_clone()
           cgroup_clone()
             mutex_lock(inode->i_mutex)
             mutex_lock(cgroup_mutex)
             cgroup_attach_task()
           ss->can_attach()
               ss->attach() [ -> cpuset_attach() ]
                 cpuset_attach_task()
                   set_cpus_allowed_ptr();

was the code path that made set_cpus_allowed_ptr() exclusion against
fork interesting.


