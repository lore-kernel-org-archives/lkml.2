Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2A2RUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 12:20:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2A2RUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 12:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <1327639925-12920-21-git-send-email-ebiederm@xmission.com>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org> <1327639925-12920-21-git-send-email-ebiederm@xmission.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sun, 29 Jan 2012 19:19:29 +0200
Message-ID: <CAPLs8y-+kg9TvjwjQgOU0_2Fqr+2dAhE0fO3cB7e_wpH1jHeBA@mail.gmail.com>
Subject: Re: [PATCH 21/29] sysctl: Add a root pointer to ctl_table_set
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Damien Millescamps <damien.millescamps@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 6:51 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Add a ctl_table_root pointer to ctl_table set so it is easy to

"ctl_table set" -> "ctl_table_set"

> go from a ctl_table_set to a ctl_table_root.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/proc_sysctl.c  |    3 +++
>  include/linux/sysctl.h |    3 +++
>  net/sysctl_net.c       |    5 ++---
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index d9c3ae6..65c13dd 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -45,6 +45,7 @@ static struct ctl_table_header root_table_header = {
>  static struct ctl_table_root sysctl_table_root = {
>        .root_list = LIST_HEAD_INIT(sysctl_table_root.root_list),
>        .default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
> +       .default_set.root = &sysctl_table_root,
>  };
>
>  static DEFINE_SPINLOCK(sysctl_lock);
> @@ -1348,9 +1349,11 @@ void unregister_sysctl_table(struct ctl_table_header * header)
>  EXPORT_SYMBOL(unregister_sysctl_table);
>
>  void setup_sysctl_set(struct ctl_table_set *p,
> +       struct ctl_table_root *root,
>        int (*is_seen)(struct ctl_table_set *))
>  {
>        INIT_LIST_HEAD(&p->list);
> +       p->root = root;
>        p->is_seen = is_seen;
>  }
>
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index e40b8f6..e73ba33 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1047,6 +1047,7 @@ struct ctl_table_header
>
>  struct ctl_table_set {
>        struct list_head list;
> +       struct ctl_table_root *root;
>        int (*is_seen)(struct ctl_table_set *);
>  };
>
> @@ -1069,6 +1070,7 @@ struct ctl_path {
>  void proc_sys_poll_notify(struct ctl_table_poll *poll);
>
>  extern void setup_sysctl_set(struct ctl_table_set *p,
> +       struct ctl_table_root *root,
>        int (*is_seen)(struct ctl_table_set *));
>  extern void retire_sysctl_set(struct ctl_table_set *set);
>
> @@ -1103,6 +1105,7 @@ static inline void unregister_sysctl_table(struct ctl_table_header * table)
>  }
>
>  static inline void setup_sysctl_set(struct ctl_table_set *p,
> +       struct ctl_table_root *root,
>        int (*is_seen)(struct ctl_table_set *))
>  {
>  }
> diff --git a/net/sysctl_net.c b/net/sysctl_net.c
> index 07c6b87..e998c64 100644
> --- a/net/sysctl_net.c
> +++ b/net/sysctl_net.c
> @@ -74,8 +74,7 @@ static struct ctl_table_root net_sysctl_ro_root = {
>
>  static int __net_init sysctl_net_init(struct net *net)
>  {
> -       setup_sysctl_set(&net->sysctls,
> -                        is_seen);
> +       setup_sysctl_set(&net->sysctls, &net_sysctl_root, is_seen);
>        return 0;
>  }
>
> @@ -95,7 +94,7 @@ static __init int net_sysctl_init(void)
>        ret = register_pernet_subsys(&sysctl_pernet_ops);
>        if (ret)
>                goto out;
> -       setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL);
> +       setup_sysctl_set(&net_sysctl_ro_root.default_set, &net_sysctl_ro_root, NULL);
>        register_sysctl_root(&net_sysctl_ro_root);
>        register_sysctl_root(&net_sysctl_root);
>  out:
> --
> 1.7.2.5
>



-- 
 .
..: Lucian
