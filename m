Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1FPPD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:03:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54852 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1FPPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=glOSmRxDE/sX7Al3kzoWA/o71UuNUOwKrpNWylsQ+abR6dUEkQ8pj8kzSYU2yHkdKb
         nqZ0tgSolLntsVcHcHenIHx+lYaEZNVgrgLSz6CQscXC0XS/EVIWk5VxkwpqC3zD3Eg1
         d9NawrwchEUbftOlPdewc1E9PlhpgYrvaJ1Q0=
Date: Thu, 16 Jun 2011 17:03:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scheduler / perf stat question about CPU-migrations
Message-ID: <20110616150347.GB23624@somewhere.redhat.com>
References: <E1QXDpy-0007Wr-5V@tytso-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QXDpy-0007Wr-5V@tytso-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 10:46:26AM -0400, Theodore Ts'o wrote:
> Can someone tell me how I'm being confused?
> 
> I ran the following command as root:
> 
> 	perf stat schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild

A theory is that schedtool does:

if (!fork()) {
	set affinity there
	launch e2fsck
}

So schedtool as a parent doesn't change it's own affinity, which makes sense
as you only want to set it for the child.

By the time it is launched, do mmap, faults, etc... and after the wait()
finishes and it exits(). It has got many opportunities to migrate.

> 
> This runs e2fsck under perf, with the cpu affinity nailed to a single
> CPU.  I therefore expected the CPU-migrations field reported by perf to
> be 0.  That was not what I found, though:
> 
> Performance counter stats for 'schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild':
> 
>         1169.715766  task-clock-msecs         #      0.180 CPUs 
>                9212  context-switches         #      0.008 M/sec
>                 307  CPU-migrations           #      0.000 M/sec
>                1875  page-faults              #      0.002 M/sec
>          2737168498  cycles                   #   2340.029 M/sec
>          3125632038  instructions             #      1.142 IPC  
>           688556730  branches                 #    588.653 M/sec
>             7263580  branch-misses            #      1.055 %    
>            15222417  cache-references         #     13.014 M/sec
>             1488633  cache-misses             #      1.273 M/sec
> 
>         6.481483548  seconds time elapsed
> 
> How could this be?  The CPU-migrations event counter only gets
> incremented if a task changes CPU's, as seen in kernel/sched.c:
> 
> 	if (task_cpu(p) != new_cpu) {
> 		p->se.nr_migrations++;
> 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
> 	}
> 
> So it should be 0, not 307, right?    What am I missing?
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
