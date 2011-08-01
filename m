Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HAUAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:00:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab1HAUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:00:01 -0400
Date: Mon, 1 Aug 2011 12:59:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Have we changed /proc/stat idle statistics by NOHZ kernel?
Message-Id: <20110801125916.1855ff3f.akpm@linux-foundation.org>
In-Reply-To: <20110725143313.GE9445@tiehlicka.suse.cz>
References: <20110725143313.GE9445@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 16:33:13 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> Hi,
> we have a customer reporting that /proc/stat doesn't provide correct
> results about idle time if the machine is idle.
> The issue is caused by the fact that tickles kernel doesn't update
> kstat_cpu(i).cpustat.idle while it is tickles. Tools that parse this
> file interpret the unchanged value as 0% idle since the last time.
> While I personally do not think that measuring the idle machine is
> that important one could say that the semantic of the file has changed
> with NOHZ which is not good as we are trying to keep this interface
> stable.
> One way to fix this is to consider the current status of idle in
> show_stat. The very primitive attempt of that can be seen bellow (on
> top of the current Linus tree). I know it has several issue it just
> illustrates what I am trying to say.  It will not work if jiffies
> overflow while the CPU was tickles and it also misses locking and
> handling !NOHZ configuration.
> 
> I have also noticed we have get_cpu_idle_time_us which should do
> something similar. Should it be used instead or it is more intrusive?
> 
> Btw. is this considered to be a problem at all?
> 

I'd consider it a bug and a regression.  If the machine was idle and
/proc/stat says "zero idle time" then that is simply incorrect.

Can we just cheat?  subtract elapsed R and D time from elapsed wall
time and print that out?

