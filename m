Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1IMQdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:33:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55972 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab1IMQdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:33:42 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 13 Sep 2011 18:33:09 +0200
In-Reply-To: <20110913162119.GA3045@linux.vnet.ibm.com>
References: <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <20110913050306.GB7254@linux.vnet.ibm.com> <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com> <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315931591.5977.26.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 21:51 +0530, Srivatsa Vaddagiri wrote:
> > which increases the time you force a task to sleep that's holding locks etc..
> 
> Ideally all tasks should get capped at the same time, given that there is
> a global pool from which everyone pulls bandwidth? So while one vcpu/task
> (holding a lock) gets capped, other vcpus/tasks (that may want the same lock)
> should ideally not be running for long after that, avoiding lock inversion
> related problems you point out.

No this simply cannot be true.. You force groups to sleep so that other
groups can run, right? Therefore shared kernel locks will cause
inversion.

You cannot put both groups to sleep and still expect a utilization of
100%.

Simple example, some task in group A owns the i_mutex of a file, group A
runs out of time and gets dequeued. Some other task in group B needs
that same i_mutex.

> I guess that we may still run into that with current implementation ..
> Basically global pool may have zero runtime left for current period,
> forcing a vcpu/task to be throttled, while there is surplus runtime in
> per-cpu pools, allowing some sibling vcpus/tasks to run for wee bit
> more, leading to lock-inversion related problems (more idling). That
> makes me think we can improve directed yield->capping interaction.
> Essentially when the target task of directed yield is capped, can the
> "yielding" task donate some of its bandwidth? 

What moron ever calls yield anyway? If you use yield you're doing it
wrong!
