Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1CVRjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:39:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57863 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1CVRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XZoKEFDCj4jIpqoflASTtWe1aaDQHE4zYLrfVBt/S8vHWHZf86N36kxOO57vAEypaj
         QHrloRQGPMZocaFKP5vA==
MIME-Version: 1.0
In-Reply-To: <20110322150905.GD3757@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<20110322150905.GD3757@redhat.com>
Date: Tue, 22 Mar 2011 10:39:36 -0700
Message-ID: <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Why not just implement simply RT class groups and always allow an RT
> group to preempt an BE class. Same thing we do for cfq queues. I will
> not worry too much about a run away application consuming all the
> bandwidth. If that's a concern we could use blkio controller to limit
> the IO rate of a latency sensitive applicaiton to make sure it does
> not starve BE applications.

That is not quite the same semantics.  This limited preemption patch
is still work-conserving.  If the RT task in the only task on the
system with IO, it will be able to use all available disk time.

> If RT starving BE is an issue, then it is an issue with plain cfq queue
> also. First we shall have to fix it there.
>
> This definition that a latency sensitive task get prioritized only
> till it is consuming its fair share and if task starts using more than
> fair share then CFQ automatically stops prioritizing it sounds little
> odd to me. If you are looking for predictability, then we lost it. We
> shall have to very well know that task is not eating more than its
> fair share before we can gurantee any kind of latencies to that task. And
> if we know that task is not hogging the disk, there is anyway no risk
> of it starving other groups/tasks completely.

In a shared environment, we have to be a little bit defensive.  We
hope that a latency sensitive task is well characterized and won't
exceed its share of the disk, and that we haven't over-committed the
disk.  If the app does do more IO than expected, then we'd like them
to bear the burden.  We have a choice of two outcomes.  A single job
sometimes failing to achieve low disk latency when it's very busy.  Or
all jobs on a disk sometimes being very slow when another (unrelated)
job is very busy.  The first is easier to understand and debug.

Chad
