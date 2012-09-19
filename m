Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2ISEqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:46:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51727 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2ISEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:46:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: hongfeng <hongfeng@marvell.com>
Cc: akpm@linux-foundation.org, gorcunov@openvz.org, keescook@chromium.org,
        serge.hallyn@canonical.com, linux-kernel@vger.kernel.org
References: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
Date: Tue, 18 Sep 2012 21:46:35 -0700
In-Reply-To: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
	(hongfeng@marvell.com's message of "Wed, 19 Sep 2012 11:27:13 +0800")
Message-ID: <87fw6eaac4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+gb7HUqZnfgnnQlpc7Xgd7+8oQigWyTUQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Evil_Numbers_Gen maybe a phone number spam
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;hongfeng <hongfeng@marvell.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] poweroff: fix bug in orderly_poweroff
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hongfeng <hongfeng@marvell.com> writes:

> orderly_poweroff is trying to poweroff platform by two steps:
> step 1: Call userspace application to poweroff
> step 2: If userspace poweroff fail, then do a force power off if force param is set.
>
> The bug here is, step 1 is always successful with param UMH_NO_WAIT,

This code has existed for 5 years.  Is this a recent regression?  Why
has no one complained before?

It looks to me that step 2 is:
step 2: If we can not launch the userspace poweroff fail.

> should change to UMH_WAIT_PROC which will monitor the return value
> ofuserspace application.

Is it safe to block indefinitely in the callers waiting for userspace?

If the caller is not running in a kernel thread then we can easily get
into a case where the userspace caller will block waiting for us when we
are waiting for the userspace caller.

I don't want to impeded progress but I don't see the evidence that this
change is good enough.


> Change-Id: I2f9ebbb90c0c2443780080ec9507c8d004e5da74
> Signed-off-by: Feng Hong <hongfeng@marvell.com>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 241507f..1b30b30 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2204,7 +2204,7 @@ static int __orderly_poweroff(void)
>  		return -ENOMEM;
>  	}
>  
> -	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
> +	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_PROC,
>  				      NULL, argv_cleanup, NULL);
>  	if (ret == -ENOMEM)
>  		argv_free(argv);
