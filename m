Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1FURh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:37:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab1FURh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fUQ/Hb3cc/x/Z6QIkLvnRb/t6eWRpsUE/N5NAYKy7U2zZkMDJap/77fc+9Zj8M0//s
         GVx1W2KWdWqwvYQPG2Mg==
MIME-Version: 1.0
In-Reply-To: <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com> <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 21 Jun 2011 10:37:03 -0700
Message-ID: <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> +static void rlim_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +                     struct cgroup *old_cgrp, struct task_struct *task)
> +{
> +       rlim_remove_proc(old_cgrp);
> +}

Since this is used for both the exit callback and the attach callback,
it should have a more generic name.

> +static int rlim_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> +{
> +       struct rlim *rlim = cgroup_rlim(cgrp);
> +       struct res_counter *limit_fail_at;
> +
> +       return res_counter_charge(&rlim->proc_counter, 1, &limit_fail_at);
> +}

Can't this fail spuriously in the presence of hierarchies?

E.g. if cgroup A has children, and A is at its limit, then moving
tasks around between A and its children, or between different children
of A, seems like it would fail due to the temporary double counting.

Paul
