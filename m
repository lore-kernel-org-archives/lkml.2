Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1CJUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:09:29 -0500
Received: from smtp-out.google.com ([74.125.121.67]:26269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1CJUJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:09:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r6CrMwIBQWXOWiS4R/HP+PxWsSwb1RNF9gQO+ra9cLMvOZEBNx+jztA7Yb3R+p5/tR
         GxqU4NK2Y3m5Cp1ZAq0w==
MIME-Version: 1.0
In-Reply-To: <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu> <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
 <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Thu, 10 Mar 2011 12:01:29 -0800
Message-ID: <AANLkTikkmfwk0nV0p=omz2ddrw+ZqWF1Lx3EfO6dTjEQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 10:18 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>> This BUG_ON() seems unnecessary, given the i++ directly above it.
>
> It's meant to communicate that the loop must go through at least once,
> so that 'struct cgroup *oldcgrp' will be initialised within a loop later
> (setting it to NULL in the beginning is just to shut up the compiler.)

Right, but it's a do {} while() loop with no break in it - it's
impossible to not go through at least once...

>> Should we be setting failed_ss here? Doesn't that mean that if all
>> subsystems pass the can_attach() check but the first one fails a
>> can_attach_task() check, we don't call any cancel_attach() methods?
>>
>> What are the rollback semantics for failing a can_attach_task() check?
>
> They are not called in that order - it's for_each_subsys { can_attach();
> can_attach_task(); }.

Oh, fair point - I misread that.

> Although if the deal is that cancel_attach reverts
> the things that can_attach does (and can_attach_task is separate) (is
> this the case? it should probably go in the documentation), then passing
> a can_attach and failing a can_attach_task should cause cancel_attach to
> get called for that subsystem, which in this code it doesn't. Something
> like:
>
>    retval = ss->can_attach();
>    if (retval) {
>        failed_ss = ss;
>        goto out_cancel_attach;
>    }
>    retval = ss->can_attach_task();
>    if (retval) {
>        failed_ss = ss;
>        cancel_extra_ss = true;
>        goto out_cancel_attach;
>    }

Yes, but maybe call the flag cancel_failed_ss? Slightly more obvious,
to me at least.

>> > + ? ? ? ? ? ? ? ? ? ? ? BUG_ON(!thread_group_leader(tsk));
>>
>> Can this race with an exiting/execing group leader?
>
> No, rcu_read_lock() is held.
>

But rcu_read_lock() doesn't stop any actions - it just stops the data
structures from going away. Can't leadership change during an
execve()?

> (However, I did try to test it, and it looks like if a leader calls
> sys_exit() then the whole group goes away; is this actually guaranteed?)

I think so, but maybe not instantaneously.

Paul
