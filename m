Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2IVNie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:38:34 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54641 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2IVNib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:38:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, JP Abgrall <jpa@google.com>,
        netdev@vger.kernel.org, Ashish Sharma <ashishsharma@google.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
References: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
	<1348279853-44499-3-git-send-email-john.stultz@linaro.org>
Date: Sat, 22 Sep 2012 06:38:23 -0700
In-Reply-To: <1348279853-44499-3-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Fri, 21 Sep 2012 22:10:48 -0400")
Message-ID: <87bogygots.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+OLnPKoAW6w/dPcC8oHew7wesLthFIopw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3393]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;John Stultz <john.stultz@linaro.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/7][RFC] netfilter: add xt_qtaguid matching module
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just took a quick skim through the patch, and spotted a few things.

This patch is going to need to handle current_fsuid returning a kuid_t.

The permission checks are weird, and ancient looking.

There is no network namespace handling, to the point I don't think
the code will function properly if network namespace support is enabled
in the kernel.

The code probably wants to use struct pid *pid, instead of pid_t values.
Both to cope with the pid namespace and to avoid issues with pid wrap
around.

A few more comments below.

Eric



John Stultz <john.stultz@linaro.org> writes:

> From: JP Abgrall <jpa@google.com>
>
> This module allows tracking stats at the socket level for given UIDs.
> It replaces xt_owner.
> If the --uid-owner is not specified, it will just count stats based on
> who the skb belongs to. This will even happen on incoming skbs as it
> looks into the skb via xt_socket magic to see who owns it.
> If an skb is lost, it will be assigned to uid=0.
>
> To control what sockets of what UIDs are tagged by what, one uses:
>   echo t $sock_fd $accounting_tag $the_billed_uid \
>      > /proc/net/xt_qtaguid/ctrl
>  So whenever an skb belongs to a sock_fd, it will be accounted against
>    $the_billed_uid
>   and matching stats will show up under the uid with the given
>    $accounting_tag.
>
> Because the number of allocations for the stats structs is not that big:
>   ~500 apps * 32 per app
> we'll just do it atomic. This avoids walking lists many times, and
> the fancy worker thread handling. Slabs will grow when needed later.
>
> It use netdevice and inetaddr notifications instead of hooks in the core dev
> code to track when a device comes and goes. This removes the need for
> exposed iface_stat.h.
>
> Put procfs dirs in /proc/net/xt_qtaguid/
>   ctrl
>   stats
>   iface_stat/<iface>/...
> The uid stats are obtainable in ./stats.
>
> Cc: netdev@vger.kernel.org
> Cc: JP Abgrall <jpa@google.com>
> Cc: Ashish Sharma <ashishsharma@google.com>
> Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> [Dropped paranoid network ifdefs and minor compile fixups -jstultz]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---


> +static struct qtaguid_event_counts qtu_events;
> +/*----------------------------------------------*/
> +static bool can_manipulate_uids(void)
> +{

You probably want something like a test for capable(CAP_SETUID).
Certainly raw check for the uid == 0 fell out of common practice
for this sort of thing a decade or so ago.
> +	/* root pwnd */
> +	return unlikely(!current_fsuid()) || unlikely(!proc_ctrl_write_gid)
> +		|| in_egroup_p(proc_ctrl_write_gid);
> +}
> +
> +static bool can_impersonate_uid(uid_t uid)
> +{
> +	return uid == current_fsuid() || can_manipulate_uids();
> +}
> +
> +static bool can_read_other_uid_stats(uid_t uid)
> +{
Perhaps may_ptrace?
> +	/* root pwnd */
> +	return unlikely(!current_fsuid()) || uid == current_fsuid()
> +		|| unlikely(!proc_stats_readall_gid)
> +		|| in_egroup_p(proc_stats_readall_gid);
> +}
> +


> +/*
> + * Track tag that this socket is transferring data for, and not necessarily
> + * the uid that owns the socket.
> + * This is the tag against which tag_stat.counters will be billed.
> + * These structs need to be looked up by sock and pid.
> + */
> +struct sock_tag {
> +	struct rb_node sock_node;
> +	struct sock *sk;  /* Only used as a number, never dereferenced */
> +	/* The socket is needed for sockfd_put() */
> +	struct socket *socket;
> +	/* Used to associate with a given pid */
> +	struct list_head list;   /* in proc_qtu_data.sock_tag_list */
> +	pid_t pid;
You probably want this to be "struct pid *pid;"
> +
> +	tag_t tag;
> +};


> + * The qtu uid data is used to track resources that are created directly or
> + * indirectly by processes (uid tracked).
> + * It is shared by the processes with the same uid.
> + * Some of the resource will be counted to prevent further rogue allocations,
> + * some will need freeing once the owner process (uid) exits.
> + */
> +struct uid_tag_data {
> +	struct rb_node node;
> +	uid_t uid;

You probably want to say kuid_t uid here.

> +	/*
> +	 * For the uid, how many accounting tags have been set.
> +	 */
> +	int num_active_tags;
> +	/* Track the number of proc_qtu_data that reference it */
> +	int num_pqd;
> +	struct rb_root tag_ref_tree;
> +	/* No tag_node_tree_lock; use uid_tag_data_tree_lock */
> +};


> +struct proc_qtu_data {
> +	struct rb_node node;
> +	pid_t pid;

I suspect you want to use "struct pid *pid" here.
> +
> +	struct uid_tag_data *parent_tag_data;
> +
> +	/* Tracks the sock_tags that need freeing upon this proc's death */
> +	struct list_head sock_tag_list;
> +	/* No spinlock_t sock_tag_list_lock; use the global one. */
> +};
> +

> diff --git a/net/netfilter/xt_qtaguid.c b/net/netfilter/xt_qtaguid.c
> new file mode 100644
> index 0000000..7c4ac46
> +/*------------------------------------------*/
> +static int __init qtaguid_proc_register(struct proc_dir_entry **res_procdir)
> +{
> +	int ret;
> +	*res_procdir = proc_mkdir(module_procdirname, init_net.proc_net);

You probably want to handle all of the network namespaces.
> +	if (!*res_procdir) {
> +		pr_err("qtaguid: failed to create proc/.../xt_qtaguid\n");
> +		ret = -ENOMEM;
> +		goto no_dir;
> +	}
> +
