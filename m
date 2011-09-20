Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750811Ab1ITNVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1ITNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:21:32 -0400
Date: Tue, 20 Sep 2011 15:17:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: usb: make usb urbs user namespace aware
Message-ID: <20110920131738.GA29852@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110919214700.GA22300@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919214700.GA22300@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Serge E. Hallyn wrote:
>
> Add to the dev_state and alloc_async structures the user namespace
> corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> which can then implement a proper, user-namespace-aware uid check.

IOW, we add the additional "user_namespace *" member/argument, and use
it along with uid/euid.

I am not really sure, but can't we simplify this?

> @@ -68,6 +69,7 @@ struct dev_state {
>  	wait_queue_head_t wait;     /* wake up if a request completed */
>  	unsigned int discsignr;
>  	struct pid *disc_pid;
> +	struct user_namespace *user_ns;
>  	uid_t disc_uid, disc_euid;

Can't we add "const struct cred *disc_cred" and kill disc_uid/disc_euid
instead?

Then we redefine kill_pid_info_as_uid() as kill_pid_info_as_cred(...cred...),
it can use cred->cred->uid/euid directly.

devio.c does get_cred/put_cred instead of get_user_ns/put_user_ns.

What do you think?

Oleg.

