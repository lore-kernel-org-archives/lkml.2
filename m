Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1BDVLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:11:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58679 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1BDVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:11:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
References: <m1oc6rio5u.fsf@fess.ebiederm.org>
	<1296851485-6730-1-git-send-email-lucian.grijincu@gmail.com>
Date: Fri, 04 Feb 2011 13:11:02 -0800
In-Reply-To: <1296851485-6730-1-git-send-email-lucian.grijincu@gmail.com>
	(Lucian Adrian Grijincu's message of "Fri, 4 Feb 2011 22:31:25 +0200")
Message-ID: <m1vd0zh5eh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184wYEO1T+9MvH6vPXwZQOyWma8JckYyJY=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/6] sysctl: faster reimplementation of sysctl_check_table
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> Determining the parent of a node at depth d
> - previous implementation: O(d)
> - current  implementation: O(1)
>
> Printing the path to a node at depth d
> - previous implementation: O(d^2)
> - current  implementation: O(d)
>
> This comes to a cost: we use an array ('parents') holding as many
> pointers as there can be sysctl levels (currently CTL_MAXNAME=10).
>
> The 'parents' array of pointers holds the same values as the
> ctl_table->parents field because the function that updates ->parents
> (sysctl_set_parent) is called with either NULL (for root nodes) or
> with sysctl_set_parent(table, table->child).

>
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> ---
>  kernel/sysctl_check.c |  130 +++++++++++++++++++++++++-----------------------
>  1 files changed, 68 insertions(+), 62 deletions(-)
>
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index 10b90d8..d23b085 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -6,58 +6,34 @@
>  #include <net/ip_vs.h>
>  
>  
> -static int sysctl_depth(struct ctl_table *table)
> -{
> -	struct ctl_table *tmp;
> -	int depth;
> -
> -	depth = 0;
> -	for (tmp = table; tmp->parent; tmp = tmp->parent)
> -		depth++;
> -
> -	return depth;
> -}
> -
> -static struct ctl_table *sysctl_parent(struct ctl_table *table, int n)
> +static void sysctl_print_path(struct ctl_table *table,
> +			      struct ctl_table **parents, int depth)
>  {
> +	struct ctl_table *p;
>  	int i;
> -
> -	for (i = 0; table && i < n; i++)
> -		table = table->parent;
> -
> -	return table;
> -}
> -
> -
> -static void sysctl_print_path(struct ctl_table *table)
> -{
> -	struct ctl_table *tmp;
> -	int depth, i;
> -	depth = sysctl_depth(table);
>  	if (table->procname) {
> -		for (i = depth; i >= 0; i--) {
> -			tmp = sysctl_parent(table, i);
> -			printk("/%s", tmp->procname?tmp->procname:"");
> +		for (i = 0; i < depth; i++) {
> +			p = parents[i];
> +			printk("/%s", p->procname ? p->procname : "");
>  		}
> +		printk("/%s", table->procname);
>  	}
>  	printk(" ");
>  }
>  
>  static struct ctl_table *sysctl_check_lookup(struct nsproxy *namespaces,
> -						struct ctl_table *table)
> +	     struct ctl_table *table, struct ctl_table **parents, int depth)
>  {
>  	struct ctl_table_header *head;
>  	struct ctl_table *ref, *test;
> -	int depth, cur_depth;
> -
> -	depth = sysctl_depth(table);
> +	int cur_depth;
>  
>  	for (head = __sysctl_head_next(namespaces, NULL); head;
>  	     head = __sysctl_head_next(namespaces, head)) {
>  		cur_depth = depth;
>  		ref = head->ctl_table;
>  repeat:
> -		test = sysctl_parent(table, cur_depth);
> +		test = parents[depth - cur_depth];
>  		for (; ref->procname; ref++) {
>  			int match = 0;
>  			if (cur_depth && !ref->child)
> @@ -83,11 +59,12 @@ out:
>  	return ref;
>  }
>  
> -static void set_fail(const char **fail, struct ctl_table *table, const char *str)
> +static void set_fail(const char **fail, struct ctl_table *table,
> +	     const char *str, struct ctl_table **parents, int depth)
>  {
>  	if (*fail) {
>  		printk(KERN_ERR "sysctl table check failed: ");
> -		sysctl_print_path(table);
> +		sysctl_print_path(table, parents, depth);
>  		printk(" %s\n", *fail);
>  		dump_stack();
>  	}
> @@ -95,40 +72,55 @@ static void set_fail(const char **fail, struct ctl_table *table, const char *str
>  }
>  
>  static void sysctl_check_leaf(struct nsproxy *namespaces,
> -				struct ctl_table *table, const char **fail)
> +			      struct ctl_table *table, const char **fail,
> +			      struct ctl_table **parents, int depth)
>  {
>  	struct ctl_table *ref;
>  
> -	ref = sysctl_check_lookup(namespaces, table);
> -	if (ref && (ref != table))
> -		set_fail(fail, table, "Sysctl already exists");
> +	ref = sysctl_check_lookup(namespaces, table, parents, depth);
> +	if (ref && (ref != table)) {
> +		printk(KERN_ALERT "sysctl_check_leaf ref[%s], table[%s]\n", ref->procname, table->procname);
> +		set_fail(fail, table, "Sysctl already exists", parents, depth);
> +	}
>  }
>  
> -int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
> +
> +
> +#define SET_FAIL(str) set_fail(&fail, table, str, parents, depth)
> +
> +static int __sysctl_check_table(struct nsproxy *namespaces,
> +	struct ctl_table *table, struct ctl_table **parents, int depth)
>  {
> +	const char *fail = NULL;
>  	int error = 0;
> +
> +	if (depth >= CTL_MAXNAME) {

This should be depth > CTL_MAXNAME.  Because there are only CTL_MAXNAME
entries in the array.

Eric


> +		SET_FAIL("Sysctl tree too deep");
> +		return -EINVAL;
> +	}
> +
>  	for (; table->procname; table++) {
> -		const char *fail = NULL;
> +		fail = NULL;
>  
>  		if (table->parent) {
>  			if (table->procname && !table->parent->procname)
> -				set_fail(&fail, table, "Parent without procname");
> +				SET_FAIL("Parent without procname");
>  		}
>  		if (!table->procname)
> -			set_fail(&fail, table, "No procname");
> +			SET_FAIL("No procname");
>  		if (table->child) {
>  			if (table->data)
> -				set_fail(&fail, table, "Directory with data?");
> +				SET_FAIL("Directory with data?");
>  			if (table->maxlen)
> -				set_fail(&fail, table, "Directory with maxlen?");
> +				SET_FAIL("Directory with maxlen?");
>  			if ((table->mode & (S_IRUGO|S_IXUGO)) != table->mode)
> -				set_fail(&fail, table, "Writable sysctl directory");
> +				SET_FAIL("Writable sysctl directory");
>  			if (table->proc_handler)
> -				set_fail(&fail, table, "Directory with proc_handler");
> +				SET_FAIL("Directory with proc_handler");
>  			if (table->extra1)
> -				set_fail(&fail, table, "Directory with extra1");
> +				SET_FAIL("Directory with extra1");
>  			if (table->extra2)
> -				set_fail(&fail, table, "Directory with extra2");
> +				SET_FAIL("Directory with extra2");
>  		} else {
>  			if ((table->proc_handler == proc_dostring) ||
>  			    (table->proc_handler == proc_dointvec) ||
> @@ -139,28 +131,42 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
>  			    (table->proc_handler == proc_doulongvec_minmax) ||
>  			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
>  				if (!table->data)
> -					set_fail(&fail, table, "No data");
> +					SET_FAIL("No data");
>  				if (!table->maxlen)
> -					set_fail(&fail, table, "No maxlen");
> +					SET_FAIL("No maxlen");
>  			}
>  #ifdef CONFIG_PROC_SYSCTL
>  			if (table->procname && !table->proc_handler)
> -				set_fail(&fail, table, "No proc_handler");
> -#endif
> -#if 0
> -			if (!table->procname && table->proc_handler)
> -				set_fail(&fail, table, "proc_handler without procname");
> +				SET_FAIL("No proc_handler");
>  #endif
> -			sysctl_check_leaf(namespaces, table, &fail);
> +			parents[depth] = table;
> +			sysctl_check_leaf(namespaces, table, &fail,
> +					  parents, depth);
>  		}
>  		if (table->mode > 0777)
> -			set_fail(&fail, table, "bogus .mode");
> +			SET_FAIL("bogus .mode");
>  		if (fail) {
> -			set_fail(&fail, table, NULL);
> +			SET_FAIL(NULL);
>  			error = -EINVAL;
>  		}
> -		if (table->child)
> -			error |= sysctl_check_table(namespaces, table->child);
> +		if (table->child) {
> +			parents[depth] = table;
> +			error |= __sysctl_check_table(namespaces, table->child,
> +						      parents, depth + 1);
> +		}
>  	}
>  	return error;
>  }
> +
> +
> +int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
> +{
> +	struct ctl_table *parents[CTL_MAXNAME];
> +	/* Keep track of parents as we go down into the tree.
> +	 *
> +	 * parents[i-1] will be the parent for parents[i].
> +	 * The node at depth 'd' will have the parent at parents[d-1].
> +	 * The root node (depth=0) has no parent in this array.
> +	 */
> +	return __sysctl_check_table(namespaces, table, parents, 0);
> +}
