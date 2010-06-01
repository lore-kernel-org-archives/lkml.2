Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0FAS5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:57:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0FAS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:57:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fb3e9CojT9hUO3cJ6EXl6H4gLuKQI0fnA/p3OelPMrdznymv1H/5aN3nD16+VAnca
	1DERAiAYFWzauqg07ZWbg==
MIME-Version: 1.0
In-Reply-To: <20100531180446.GA16249@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
	<20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
	<20100531175242.GA14691@redhat.com>
	<20100531180446.GA16249@redhat.com>
Date: Tue, 1 Jun 2010 11:57:08 -0700
Message-ID: <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:04 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> And, forgot to mention, I do not understand the PF_EXITING check in
> attach_task_by_pid() (and some others).
>
> At first glance, it buys nothing. PF_EXITING can be set right after
> the check.

It can, but it's a benign race.

Moving a non-current thread into a cgroup takes task->alloc_lock and
checks for PF_EXITING before manipulating that thread's cgroup links.
The exit procedure sets PF_EXITING and then (somewhat later, but
guaranteed) moves current to the root cgroups while holding
alloc_lock. If a task hasn't set PF_EXITING by the time we check for
it, while holding alloc_lock, it can't enter the cgroup cleanup code
until we've finished moving it to its new cgroup. If it has set
PF_EXITING by that point, it's guaranteed to be moving itself to the
root cgroups and disconnecting from various cgroups structures in the
very near future, so it's fine to refuse to move it to a new cgroup.

Paul
