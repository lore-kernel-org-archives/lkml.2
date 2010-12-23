Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0LWMds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:33:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:47034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0LWMdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:33:47 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Miklos Vajna <vmiklos@frugalware.org>, Mike Galbraith <efault@gmx.de>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>
In-Reply-To: <1293106330.2170.618.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
	 <1293037718.2170.155.camel@laptop> <1293050173.2170.389.camel@laptop>
	 <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 13:33:44 +0100
Message-ID: <1293107624.2170.642.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 13:12 +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-23 at 10:08 +0800, Yong Zhang wrote:
> > > systemd--1251    0d..5. 2015398us : enqueue_task_fair <-enqueue_task
> > > systemd--1251    0d..5. 2015398us : print_runqueue <-enqueue_task_fair
> > > systemd--1251    0d..5. 2015399us : __print_runqueue:  cfs_rq: c2407c34, nr: 3, load: 3072
> > > systemd--1251    0d..5. 2015400us : __print_runqueue:  curr: f6a8de5c, comm: systemd-cgroups/1251, load: 1024
> > > systemd--1251    0d..5. 2015401us : __print_runqueue:  se: f69e6300, load: 1024,
> > > systemd--1251    0d..5. 2015401us : __print_runqueue:    cfs_rq: f69e6540, nr: 2, load: 2048
> > > systemd--1251    0d..5. 2015402us : __print_runqueue:    curr: (null)
> > > systemd--1251    0d..5. 2015402us : __print_runqueue:    se: f69e65a0, load: 4137574976,
> > 
> > the load == f69e65a0 == address of se, odd
> 
> This appears to be consistently true, I've also found that in between
> these two prints, there is a free_sched_group() freeing that exact
> entry. So post-print is a use-after-free artifact.
> 
> What's interesting is that its freeing a cfs_rq struct with
> nr_running=1, that should not be possible...
> 
> /me goes stare at the whole cgroup task attach vs cgroup destruction
> muck.

 systemd-1       0d..1. 2070793us : sched_destroy_group: se: f69e43c0, load: 1024
 systemd-1       0d..1. 2070794us : sched_destroy_group: cfs_rq: f69e4720, nr: 1, load: 1024
 systemd-1       0d..1. 2070794us : __print_runqueue:  cfs_rq: f69e4720, nr: 1, load: 1024
 systemd-1       0d..1. 2070795us : __print_runqueue:  curr: (null)
 systemd-1       0d..1. 2070796us : __print_runqueue:  se: f6a8eb4c, comm: systemd-tmpfile/1243, load: 1024
 systemd-1       0d..1. 2070796us : _raw_spin_unlock_irqrestore <-sched_destroy_group

So somehow it manages to destroy a group with a task attached.
