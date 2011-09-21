Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1IUSe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:34:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1IUSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:34:56 -0400
Date: Wed, 21 Sep 2011 20:31:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: usb: make usb urbs user namespace
	aware (v2)
Message-ID: <20110921183101.GB25590@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110919214700.GA22300@sergelap> <20110920131738.GA29852@redhat.com> <20110921050127.GB6691@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921050127.GB6691@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21, Serge E. Hallyn wrote:
>
> Add to the dev_state and alloc_async structures the user namespace
> corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> which can then implement a proper, user-namespace-aware uid check.

Looks correct.



But I have off-topic question. And in fact I am a bit confused,
please help.

First of all, I assume that CLONE_NEWUSER is the only way to change
->user_ns, right?

And, looking at copy_creds() I think that cred->user_ns is always
equal to cred->user->user_ns. However, grep shows a lot of
cred->user->user_ns examples. Why?

> +static int kill_as_cred_perm(const struct cred *cred,
> +			     struct task_struct *target)
> +{
> +	const struct cred *pcred = __task_cred(target);
> +	if (cred->user_ns != pcred->user_ns)
> +		return 0;

Should we really fail if cred->user_ns == pcred->user_ns->creator ?
(or creator of creator, etc).

IOW, shouldn't this match kill_ok_by_cred() path which (at least
cap_capable) checks the ->creator chain when ->user_ns differ?

Oleg.

