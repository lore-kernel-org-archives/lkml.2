Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1ADSaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:30:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33101 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ADS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:29:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=psqJx8qmkIdcJi3JcF+jLd5k3d1sYCPTZKVgcX+CEwl/7SgU6gL6tMdOdlUVquZy3L
         EL98cRMu4Wed/1Ehut9LvIZzjFXR213tUogiO/E4MQWJtqfixYBbBVBOOJtTiCwr30lV
         T7Zv083lG1N6IFQ96yEMW7F6hByHJZnCHndAU=
MIME-Version: 1.0
In-Reply-To: <1294163897.6169.172.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir> <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
 <1294163897.6169.172.camel@Palantir>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 4 Jan 2011 16:29:38 -0200
Message-ID: <AANLkTi=G1b3OHH1ZUGCcL+nnb3LaeUDMWsXk8z+FzWT2@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 15:58, Dario Faggioli <raistlin@linux.it> wrote:
> On Tue, 2011-01-04 at 14:37 -0200, Lucas De Marchi wrote:
>> > Suggestions on how to deal with that will be appreciated.
>>
>> Don't forget the PI case too. You will need to change
>> rt_mutex_setprio() to keep a copy of sched_cfs_entity in struct
>> rt_mutex_waiter.
>>
> Mmm... do I? While I'm cloning your git, could you elaborate a bit on
> why, because I don't seem to see that... :-P

Suppose a RT task blocks on a PI-mutex, the lock owner will be boosted
to RT and go through a class change in rt_mutex_setprio().
Since now a class change reinitializes the class-specific, if fair and
rt fields are on the same memory space, we need to save the
sched_fair_entity before changing the class to RT and put it again
when going back to the fair class.

Quoting Peter about this:

 [ Initially I was thinking not, because the task slept we'll have to
reinsert it in the rb-tree anyway, but upon further consideration
that'll loose the old vruntime setting, which can lead to an unseemly
gain of time in place_entity()'s never backward check failing.

So yes, we'd have to place a copy of the old sched_entity in struct
rt_mutex_waiter, not very hard to do. ]


As a side-note: irc this is one thing i didn't do when i prepared that patches.



Lucas De Marchi
