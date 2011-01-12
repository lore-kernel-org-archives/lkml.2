Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1ALPzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:55:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56171 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1ALPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:55:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>, WANG Cong <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Dave Young <hidave.darkstar@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Vlad Dogaru <ddvlad@rosedu.org>
References: <AANLkTimRM6=g+4adii9die0F+AG6D2rrb0ntczqCUKPD@mail.gmail.com>
Date: Wed, 12 Jan 2011 07:55:04 -0800
In-Reply-To: <AANLkTimRM6=g+4adii9die0F+AG6D2rrb0ntczqCUKPD@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Wed, 12 Jan 2011 12:17:07
	+0200")
Message-ID: <m1d3o2ce1z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18PIRR6VV67rmoy5PdjohdIkr12wM/mD74=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: ctl_table->parent is only used for sysctl checks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

See selinux_sysctl_get_sid.

> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> ---
>  include/linux/sysctl.h |    2 ++
>  kernel/sysctl.c        |    7 +++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 7bb5cb6..026681f 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1018,7 +1018,9 @@ struct ctl_table
>  	int maxlen;
>  	mode_t mode;
>  	struct ctl_table *child;
> +#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
>  	struct ctl_table *parent;	/* Automatically set */
> +#endif
>  	proc_handler *proc_handler;	/* Callback for text formatting */
>  	void *extra1;
>  	void *extra2;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ae5cbb1..c5bade1 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1706,6 +1706,7 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
>  	return test_perm(mode, op);
>  }
>  
> +#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
>  static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
>  {
>  	for (; table->procname; table++) {
> @@ -1714,11 +1715,13 @@ static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
>  			sysctl_set_parent(table, table->child);
>  	}
>  }
> +#endif
> +
>  
>  static __init int sysctl_init(void)
>  {
> -	sysctl_set_parent(NULL, root_table);
>  #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
> +	sysctl_set_parent(NULL, root_table);
>  	sysctl_check_table(current->nsproxy, root_table);
>  #endif
>  	return 0;
> @@ -1875,9 +1878,9 @@ struct ctl_table_header *__register_sysctl_paths(
>  	header->used = 0;
>  	header->unregistering = NULL;
>  	header->root = root;
> -	sysctl_set_parent(NULL, header->ctl_table);
>  	header->count = 1;
>  #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
> +	sysctl_set_parent(NULL, header->ctl_table);
>  	if (sysctl_check_table(namespaces, header->ctl_table)) {
>  		kfree(header);
>  		return NULL;
