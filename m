Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1FDKKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:10:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38100 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755571Ab1FDKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:10:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+OuwkWDMSOV8wbpZc2XSAR/gLa+++BnBBlRHiem6
	dehPUs8RyrNKgs
Subject: Re: cgroups: Assigning tasks to a cgroup slow and does not scale
From: Mike Galbraith <efault@gmx.de>
To: Martin Baum <pop3@flachtaucher.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110604102343.113667vdxn02i4ws@webmail.df.eu>
References: <20110604102343.113667vdxn02i4ws@webmail.df.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Jun 2011 12:10:31 +0200
Message-ID: <1307182231.25172.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 10:23 +0200, Martin Baum wrote:
> Hello,
> 
> assigning a task to new cgroup takes an unexpected high amount of time  
> on my system - about 0.05s. Strangely it does it does not scale with  
> more processes: When I run 10 processes that do nothing but change  
> their cgroups each cgroup change takes about 0.5 seconds while CPU  
> usage remains very low. So my system maxes out at 20 cgroup changes  
> per second while cpu and disk usage remain minimal (according to top).  
> Is this expected behaviour?

Attaching a task invokes synchronize_rcu() along the way, so yup, it's
the expected behavior.

> It is a problem for me: I run a daemon that forks and calls suid for  
> each request. I want to assign each of these forks to a different  
> cgroup. However this currently kills performance going down from >100  
> req/sec to about 20 req/sec.

You can work around it via static cgroups with an agent waiting inside
each one.  Tell your agent what to do, he forks off a worker.  You can
inherit a cgroup quickly, but moving between cgroups is very expensive,
as you noticed.

(right way is eventually stop exporting rcu grace periods to userland)

	-Mike

