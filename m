Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1ELSCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:02:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59414 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab1ELSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:02:00 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: John Stultz <john.stultz@linaro.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <BANLkTikxcfGYAmKf5QEAwJjDLdo6_k6zaw@mail.gmail.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <BANLkTikXyqddLbQKyDYFrAwq9DamDj--AQ@mail.gmail.com>
	 <1305147776.2883.1.camel@work-vm>
	 <BANLkTikxcfGYAmKf5QEAwJjDLdo6_k6zaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:01:05 -0700
Message-ID: <1305223265.2680.20.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 18:43 +0800, Américo Wang wrote:
> On Thu, May 12, 2011 at 5:02 AM, John Stultz <john.stultz@linaro.org> wrote:
> > On Wed, 2011-05-11 at 17:33 +0800, Américo Wang wrote:
> >> On Wed, May 11, 2011 at 8:23 AM, John Stultz <john.stultz@linaro.org> wrote:
> >> > Acessing task->comm requires proper locking. However in the past
> >> > access to current->comm could be done without locking. This
> >> > is no longer the case, so all comm access needs to be done
> >> > while holding the comm_lock.
> >> >
> >> > In my attempt to clean up unprotected comm access, I've noticed
> >> > most comm access is done for printk output. To simpify correct
> >> > locking in these cases, I've introduced a new %ptc format,
> >> > which will safely print the corresponding task's comm.
> >> >
> >> > Example use:
> >> > printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> >> >
> >>
> >> Why do you hide current->comm behide printk?
> >> How is this better than printk("%s: ....", task_comm(current)) ?
> >
> > So to properly access current->comm, you need to hold the task-lock (or
> > with my new patch set, the comm_lock). Rather then adding locking to all
> > the call sites that printk("%s ...", current->comm), I'm suggesting we
> > add a new %ptc method which will handle the locking for you.
> >
> 
> Sorry, I meant why not adding the locking into a wrapper function,
> probably get_task_comm() and let the users to call it directly?
> 
> Why is %ptc better than
> 
> char comm[...];
> get_task_comm(comm, current);
> printk("%s: ....", comm);

There were concerns about the extra stack usage caused adding a comm
buffer to each location, which can be avoided by adding the
functionality to printk.

Further it reduces the amount of change necessary to correct invalid
usage.

thanks
-john


