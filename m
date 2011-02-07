Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1BGT30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:29:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1BGT3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=I14SwtJAfow99WnIDSuLF5bfisffBV8O81DjWJNWREq4m2CJ1t+AeiBTnOTUHIG0Om
         EAW4iGVy0dgTWDxxAd/g==
MIME-Version: 1.0
In-Reply-To: <1297095033.13327.46.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com> <1296650792.26581.319.camel@laptop>
 <20110202190251.GB16409@balbir.in.ibm.com> <1297095033.13327.46.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Mon, 7 Feb 2011 11:28:59 -0800
Message-ID: <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com>
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 8:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Make the ::exit method act like ::attach, it is after all very nearly
> the same thing.

The major difference between attach and exit is that the former is
only triggered in response to user cgroup-management action, whereas
the latter is triggered whenever a task exits, even if cgroups aren't
set up.


>  void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  {
> -       int i;
>        struct css_set *cg;
> +       int i;
>
> -       if (run_callbacks && need_forkexit_callback) {
> -               /*
> -                * modular subsystems can't use callbacks, so no need to lock
> -                * the subsys array
> -                */
> -               for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> -                       struct cgroup_subsys *ss = subsys[i];
> -                       if (ss->exit)
> -                               ss->exit(ss, tsk);
> -               }
> -       }
> +       mutex_lock(&cgroup_mutex);

NACK - cgroup_mutex is way too heavy to take in the task exit path.
We'll need to find some other way to fix this if it's really needed.
task->alloc_lock is also normally a valid thing to synchronize against
cgroup moves, but I'd have to look at the exit path to see if it's
still valid there.

Paul
