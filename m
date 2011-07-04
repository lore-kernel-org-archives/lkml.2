Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1GDPL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1GDPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:11:57 -0400
Date: Mon, 4 Jul 2011 17:08:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110704150859.GB6893@redhat.com>
References: <20110622152514.GA9521@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622152514.GA9521@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Vasiliy Kulikov wrote:
>
> +void exit_shm(struct task_struct *task)
> +{
> +	struct nsproxy *nsp = task->nsproxy;
> +	struct ipc_namespace *ns;
> +
> +	if (!nsp)
> +		return;
> +	ns = nsp->ipc_ns;
> +	if (!ns || !ns->shm_rmid_forced)

This looks confusing, imho. How it is possible that ->nsproxy or
->ipc_ns is NULL?

> +		return;
> +
> +	/* Destroy all already created segments, but not mapped yet */
> +	down_write(&shm_ids(ns).rw_mutex);
> +	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
>  	up_write(&shm_ids(ns).rw_mutex);

Again, I do not pretend I understand ipc/, but it seems we can check
ns->ipc_ids[].in_use != 0 before the slow path, no?

Oleg.

