Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1I0WMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:12:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:36268 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1I0WMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:12:30 -0400
Subject: Re: [RFD 0/9] per-cgroup /proc/stat statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 28 Sep 2011 00:11:53 +0200
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317161513.21836.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> Hi,
> 
> Since I've sent already a RFC about it, I am sending now a RFD.
> If you eager for meaning, this can then be a "Request for Doctors",
> since Peter is likely to have a heart attack now.

:-)

All we need is to ensure the case of cgroups enabled but not used isn't
actually more expensive that what we have now, after that, if people
create a 100 deep cgroup hierarchy they get what they asked.

>From a conceptual pov this patch-set is a lot saner than the previous
one, doesn't duplicate nearly as much and actually tries to improve the
code (although I suspect simply killing off cputime64_t as a whole will
get us even more).

> So here's the deal:
> 
> * My main goal here was to demonstrate that we can avoid double accounting
>   in a lot of places. So what I did was getting rid of the original and first
>   kstat mechanism, and use only cgroups accounting for that. Since the parent
>   is always updated, the original stats are the one for the root cgroup.

Right, current patch-set won't compile for those who have CGROUP=n
kernels though, need to find something for that. Shouldn't be too hard
though. It looks like you only need to provide static per-cpu storage
and a custom version of task_cgroup_account_field().

> * I believe that all those cpu cgroups are confusing and should be unified. Not
>   that we can simply get rid of it, but my goal here is to provide all the
>   information they do, in cpu cgroup. If the set of tasks needed for accounting
>   is not independent of the ones in cpu cgroup, we can avoid double accounting
>   for that. I default cpuacct to n, but leave it to people that wants to use it
>   alone. 

Amen! Ideally we place cpuacct on the deprecated list or somesuch..

> * Well, I'm also doing what I was doing originally: Providing a per-cgroup version
>   of the /proc/stat file.

Right, so how much sense does it make to keep calling it proc.stat?
