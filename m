Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0JPJb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:31:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41168 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0JPJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lbe/9/8f2qk+QsM17i0sWRDD3BeuLGoX0GlvN6qJSRO72pXrpCGG56pxVusVP0Ulgn
         ZEXCd5aORTkCdWcNwIGdjcPVZL/MBnzRDkG0o6MZYW6+tiT+3YHkMkcL69KdvQH66Fhm
         Es8zSnFLh4Guuoa4OXY2ko9Xm4Jpf1e5f3vf8=
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101016020744.366bd9c6.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 11:31:15 +0200
Message-ID: <1287221475.2799.123.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 16 octobre 2010 à 02:07 -0700, Andrew Morton a écrit :
> On Sat, 16 Oct 2010 10:29:08 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Some people believe percpu_counter object is the right answer to such
> > distributed counters, because the loop is done on 'online' cpus instead
> > of 'possible' cpus. "It must be better if number of possible cpus is
> > 4096 and only one or two cpus are online"...
> > 
> > But if we do this loop only on rare events, like
> > "cat /proc/sys/fs/inode-nr", then the percpu_counter() is more
> > expensive, because percpu_add() _is_ more expensive :
> > 
> > - Its a function call and lot of instructions/cycles per call, while
> > this_cpu_inc(nr_inodes) is a single instruction, using no register on
> > x86.
> 
> You want an inlined percpu_counter_inc() then write one!  Bonus points
> for writing this_cpu_add_return() and doing it without a
> preempt_disable().  It collapses to just a few instructions.
> 

A few instructions, but no guarantee of false sharing eviction.

Each time one cpu dirties the percpu_counter object, it slow down other
cpus because they need to fetch the cache line again.

Btw, I believe my previous patch against include/linux/percpu_counter.h
was lost. Are you sure I am the right guy to work on percpu_counter
infra ? If yes I can implement your inlined idea.

Thanks


