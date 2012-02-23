Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2BWTkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:40:18 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:48661 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753241Ab2BWTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:40:17 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gLsMeIwVM1l3HP88e2lDLXePozL9WLErr7XIazj_v1bPtgq
 y1rOT3S8ew931X8jrgb3EbodH1mExQHbaDxDs55oJDs6vZubegaOE4vN7TOa
 0xifQJXrKBJRmsLudypj0txfFaZW1kkd6W3YJEk0NlIg97R8SnBssv6ChVI4
 4mlKBnqh6eh27PZe7fG5m0jpVOY2KBv_4T720LVXqekMlQ87QEGYTZMREzjQ
 C5E6X9p3EbFgFvz_4HQ8VLDIyVbqIqr01O20BblILUXEFRnx140gakgJJHz.
 lDdKyPyEZ3UNSG.oNBoq9d6PTyqyOOskD99bFAl7VZt6tfT.L7dULkOY4M0v
 qLz5w6eo0bLwOZaU_VuOgmXf4z9cJVwSN1_z8tAfX159LBi9snihK12unU2Z
 LZodhCKdKe7_BA7h34SmDANMSOtNTJGokWVbz
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 23 Feb 2012 13:40:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <4F468F09.5050200@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202231334290.10914@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012, Dave Hansen wrote:

> > Hmmm isnt the race still there between the determination of the task and
> > the get_task_struct()? You would have to verify after the get_task_struct
> > that this is really the task we wanted to avoid the race.
>
> It's true that selecting a task by pid is inherently racy.  What that
> code does is ensure that the task you've got current has 'pid', but not
> ensure that 'pid' has never represented another task.  But, that's what
> we do everywhere else in the kernel; there's not much better that we can do.

We may at this point be getting a reference to a task struct from another
process not only from the current process (where the above procedure is
valid). You rightly pointed out that the slab rcu free mechanism allows a
free and a reallocation within the RCU period. The effect is that the task
struct could be pointing to a task with another pid that what we were
looking for and therefore migrate_pages could subsequently be operating on
a totally different process.

The patch does not fix that race so far.

I think you have to verify that the pid of the task matches after you took
the refcount in order to be safe. If it does not match then abort.

> Maybe "race" is the wrong word for what we've got here.  It's a lack of
> a refcount being taken.

Is that a real difference or are you just playing with words?
