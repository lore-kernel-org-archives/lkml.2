Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0IRBeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 21:34:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab0IRBeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 21:34:18 -0400
Date: Sat, 18 Sep 2010 03:29:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] exec: move core_pattern pipe helper into the
	crashing namespace
Message-ID: <20100918012939.GA25046@redhat.com>
References: <20100917152639.0e88341a@basil.nowhere.org> <1284736618-27153-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284736618-27153-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Will Drewry wrote:
>
> Instead, this change implements the more complex option two.  It
> migrates the ____call_usermodehelper() thread into the same namespaces
> as the dumping process.  It does not assign a pid in that namespace so
> the collector will appear to be pid 0.

Hmm... You mean, it won't visible in that namespace? Afacis, it should
have the correct pid in the init ns, no?

I am a bit worried task_active_pid_ns() != nsproxy->pid_ns, but perhaps
this is OK... Say, sys_getpid() returns 0, strange.

> +		/* Run the core_collector in the crashing namespaces */
> +		if (copy_namespaces_unattached(0, current,
> +			&pipe_params.nsproxy, &pipe_params.fs)) {
> +			printk(KERN_WARNING "%s failed to copy namespaces\n",
> +			       __func__);
> +			argv_free(helper_argv);
> +			goto fail_dropcount;
> +		}

This looks overcomplicated to me, or I missed something.

I do not understand why should we do this beforehand, and why we need
copy_namespaces_unattached().

Can't you just pass current to umh_pipe_setup() (or another helper) as
the argument? Then this helper can copy ->fs and ->nsproxy itself.

In fact, I do not understand why create_new_namespaces() is used. It
is called with flags == 0 anyway, can't we just do

	ns = coredumping_task->nsproxy;
	get_nsproxy(ns);	
	switch_task_namespaces(current, ns);

?

Oleg.

