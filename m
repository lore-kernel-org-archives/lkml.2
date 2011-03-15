Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1COJLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:11:04 -0400
Received: from shutemov.name ([188.40.19.243]:55030 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1COJLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:11:02 -0400
Date: Tue, 15 Mar 2011 11:11:00 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v9 3/3] cgroups: introduce timer slack controller
Message-ID: <20110315091100.GA10165@shutemov.name>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
 <1300111524-5666-4-git-send-email-kirill@shutemov.name>
 <20110314164652.5b44fb9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314164652.5b44fb9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 04:46:52PM -0700, Andrew Morton wrote:
> On Mon, 14 Mar 2011 16:05:24 +0200
> Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > +Overview
> > +--------
> > +
> > +Every task_struct has timer_slack_ns value. This value uses to round up
> > +poll() and select() timeout values. This feature can be useful in
> > +mobile environment where combined wakeups are desired.
> > +
> > +Originally, prctl() was the only way to change timer slack value of
> > +a process. So you was not able change timer slack value of another
> > +process.
> > +
> > +cgroup subsys "timer_slack" implements timer slack controller. It
> > +provides a way to set minimal timer slack value for a group of tasks.
> > +If a task belongs to a cgroup with minimal timer slack value higher than
> > +task's value, cgroup's value will be applied.
> > +
> > +Timer slack controller allows to implement setting timer slack value of
> > +a process based on a policy. For example, you can create foreground and
> > +background cgroups and move tasks between them based on system state.
> 
> (quoting myself from last time)
> 
> Why do we need a cgroup for this as opposed to (say) inheritance over
> fork(), or a system-wide knob, or a per-process/threadgroup knob, or
> just leaving the existing code as-is?  Presumably you felt that a
> cgroup approach is better for manageability, but you didn't tell us
> about this and you didn't explore alternative ways of solving the
> problem-which-you-didn't-describe.

The main goal is reducing wakeups without affecting user experience.
Only userspace knows which tasks are important for UX. So we needed a
mechanism to define a policy in userspace.

Currently timer slack value inheritance over fork().

System-wide/threadgroup knob doesn't allow to change timer slack value of
a particular process. It's needed for foreground/background use-case.

With per-process know we have to reinvent grouping of tasks in userspace.

cgroups is a good solution for it, from my point of view.

> 
> I'm still having trouble seeing why we should merge this.  Who will use
> it, and for what reason and what benefits will they see?  Quantified
> benefits, if possible!
> 

-- 
 Kirill A. Shutemov
