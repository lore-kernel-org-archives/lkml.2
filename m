Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1BDTlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:41:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58850 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1BDTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:41:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
	<cover.1296793770.git.lucian.grijincu@gmail.com>
	<9a1977a6526ca9e0b03ba1df767f842aea62b5f4.1296793770.git.lucian.grijincu@gmail.com>
Date: Fri, 04 Feb 2011 11:41:24 -0800
In-Reply-To: <9a1977a6526ca9e0b03ba1df767f842aea62b5f4.1296793770.git.lucian.grijincu@gmail.com>
	(Lucian Adrian Grijincu's message of "Fri, 4 Feb 2011 06:37:05 +0200")
Message-ID: <m1fws3io4b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/XZQWAS38WPOYo0KfwfcmVqcws5ukdlC4=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/5] sysctl: remove useless ctl_table->parent field
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> The 'parent' field was added for selinux in:
>     commit d912b0cc1a617d7c590d57b7ea971d50c7f02503
>     [PATCH] sysctl: add a parent entry to ctl_table and set the parent entry
>
> and then was used for sysctl_check_table.
>
> Both of the users have found other implementations.

This seems reasonable but we need to be careful in how we merge this so
the individual trees are correct.

> CC: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> ---
>  include/linux/sysctl.h |    1 -
>  kernel/sysctl.c        |   11 -----------
>  kernel/sysctl_check.c  |    4 ++--
>  3 files changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 7bb5cb6..1f1da4b 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1018,7 +1018,6 @@ struct ctl_table
>  	int maxlen;
>  	mode_t mode;
>  	struct ctl_table *child;
> -	struct ctl_table *parent;	/* Automatically set */
>  	proc_handler *proc_handler;	/* Callback for text formatting */
>  	void *extra1;
>  	void *extra2;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 56f6fc1..42025ec 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1695,18 +1695,8 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
>  	return test_perm(mode, op);
>  }
>  
> -static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
> -{
> -	for (; table->procname; table++) {
> -		table->parent = parent;
> -		if (table->child)
> -			sysctl_set_parent(table, table->child);
> -	}
> -}
> -
>  static __init int sysctl_init(void)
>  {
> -	sysctl_set_parent(NULL, root_table);
>  #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
>  	sysctl_check_table(current->nsproxy, root_table);
>  #endif
> @@ -1864,7 +1854,6 @@ struct ctl_table_header *__register_sysctl_paths(
>  	header->used = 0;
>  	header->unregistering = NULL;
>  	header->root = root;
> -	sysctl_set_parent(NULL, header->ctl_table);
>  	header->count = 1;
>  #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
>  	if (sysctl_check_table(namespaces, header->ctl_table)) {
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index 9b4fecd..b7d9c66 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -95,8 +95,8 @@ static int __sysctl_check_table(struct nsproxy *namespaces,
>  	for (; table->procname; table++) {
>  		const char *fail = NULL;
>  
> -		if (table->parent) {
> -			if (table->procname && !table->parent->procname)
> +		if (depth != 0) { /* has parent */
> +			if (table->procname && !parents[depth - 1]->procname)
>  				SET_FAIL("Parent without procname");
>  		}
>  		if (!table->procname)
