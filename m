Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2JHUwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab2JHUwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:52:21 -0400
Date: Mon, 8 Oct 2012 16:52:13 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bhutchings@solarflare.com,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
Message-ID: <20121008205213.GA23211@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	bhutchings@solarflare.com, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20121008150949.GA15130@redhat.com>
 <alpine.DEB.2.00.1210081330160.18768@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210081330160.18768@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 01:35:42PM -0700, David Rientjes wrote:

 > > unanswered question: why are the buffer sizes here different ? which is correct?
 > > 
 > Given the current set of mempolicy modes and flags, it's 34, but this can 
 > change if new modes or flags are added with longer names.  I see no reason 
 > why shmem shouldn't round up to the nearest power-of-2 of 64 like it 
 > already does, but 50 is certainly safe as well in task_mmu.c.

Ok. I'll leave that for now.
 
 > > diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/fs/proc/task_mmu.c linux-dj/fs/proc/task_mmu.c
 > > --- src/git-trees/kernel/linux/fs/proc/task_mmu.c	2012-05-31 22:32:46.778150675 -0400
 > > +++ linux-dj/fs/proc/task_mmu.c	2012-10-04 19:31:41.269988984 -0400
 > > @@ -1162,6 +1162,7 @@ static int show_numa_map(struct seq_file
 > >  	struct mm_walk walk = {};
 > >  	struct mempolicy *pol;
 > >  	int n;
 > > +	int ret;
 > >  	char buffer[50];
 > >  
 > >  	if (!mm)
 > > @@ -1178,7 +1179,11 @@ static int show_numa_map(struct seq_file
 > >  	walk.mm = mm;
 > >  
 > >  	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
 > > -	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 > > +	memset(buffer, 0, sizeof(buffer));
 > > +	ret = mpol_to_str(buffer, sizeof(buffer), pol, 0);
 > > +	if (ret < 0)
 > > +		return 0;
 > 
 > We should need the mpol_cond_put(pol) here before returning.

good catch. I'll respin the patch later with this changed.

thanks,
 
	Dave


