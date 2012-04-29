Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2D2ISJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 04:18:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40356 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2D2ISF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 04:18:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
Date: Sun, 29 Apr 2012 01:22:06 -0700
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com> (Sasha
	Levin's message of "Sun, 29 Apr 2012 08:45:24 +0200")
Message-ID: <m1haw33q35.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19qSWFDHD67b7ktjfrkBqCBucAiIt3k4dI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa04 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 01/14] sysctl: provide callback for write into ctl_table entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Provide a callback that will be called when writing to a ctl_table
> entry after the user input has been validated.
>
> This will simplify user input checks since now it will be possible to
> remove them out of the proc_handler.

Ick No.

You are simplifying things by taking updates out of locks, and
introducing races.

Your naming of the callback "callback" is much too generic.

I think the current function call mechanism of sysctl can be improved
but I don't think you have come up with the right combination of things.

Eric


> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  fs/proc/proc_sysctl.c  |    4 ++++
>  include/linux/sysctl.h |    1 +
>  2 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 21d836f..190db28 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -507,6 +507,10 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
>  	error = table->proc_handler(table, write, buf, &res, ppos);
>  	if (!error)
>  		error = res;
> +
> +	if (!error && write && table->callback)
> +		error = table->callback();
> +
>  out:
>  	sysctl_head_finish(head);
>  
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index c34b4c8..27c14cf 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1022,6 +1022,7 @@ struct ctl_table
>  	struct ctl_table_poll *poll;
>  	void *extra1;
>  	void *extra2;
> +	int (*callback)(void);		/* Called when entry is written to */
>  };
>  
>  struct ctl_node {
