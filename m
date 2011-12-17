Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1LQWXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:23:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39124 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1LQWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:23:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, xemul@parallels.com,
        neilb@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
References: <20111214103602.3991.20990.stgit@localhost6.localdomain6>
	<20111214104449.3991.61989.stgit@localhost6.localdomain6>
Date: Sat, 17 Dec 2011 14:25:14 -0800
In-Reply-To: <20111214104449.3991.61989.stgit@localhost6.localdomain6>
	(Stanislav Kinsbursky's message of "Wed, 14 Dec 2011 14:44:49 +0300")
Message-ID: <m1bor6rg39.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1tW/M42v1UGQkjeHmffuky1bfhdgc/EA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 01/11] SYSCTL: export root and set handling routines
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> These routines are required for making SUNRPC sysctl's per network namespace
> context.

Why does sunrpc require it's own sysctl root?  You should be able to use
the generic per network namespace root and call it good.

What makes register_net_sysctl_table and register_net_sysctl_ro_table
unsuitable for sunrpc.  I skimmed through your patches and I haven't
seen anything obvious.

Eric


> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>
> ---
>  include/linux/sysctl.h |    1 +
>  kernel/sysctl.c        |   11 +++++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 703cfa3..be586a9 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1084,6 +1084,7 @@ struct ctl_path {
>  };
>  
>  void register_sysctl_root(struct ctl_table_root *root);
> +void unregister_sysctl_root(struct ctl_table_root *root);
>  struct ctl_table_header *__register_sysctl_paths(
>  	struct ctl_table_root *root, struct nsproxy *namespaces,
>  	const struct ctl_path *path, struct ctl_table *table);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ae27196..fb016a9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1700,6 +1700,15 @@ void register_sysctl_root(struct ctl_table_root *root)
>  	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
>  	spin_unlock(&sysctl_lock);
>  }
> +EXPORT_SYMBOL_GPL(register_sysctl_root);
> +
> +void unregister_sysctl_root(struct ctl_table_root *root)
> +{
> +	spin_lock(&sysctl_lock);
> +	list_del(&root->root_list);
> +	spin_unlock(&sysctl_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_sysctl_root);
>  
>  /*
>   * sysctl_perm does NOT grant the superuser all rights automatically, because
> @@ -1925,6 +1934,7 @@ struct ctl_table_header *__register_sysctl_paths(
>  
>  	return header;
>  }
> +EXPORT_SYMBOL_GPL(__register_sysctl_paths);
>  
>  /**
>   * register_sysctl_table_path - register a sysctl table hierarchy
> @@ -2007,6 +2017,7 @@ void setup_sysctl_set(struct ctl_table_set *p,
>  	p->parent = parent ? parent : &sysctl_table_root.default_set;
>  	p->is_seen = is_seen;
>  }
> +EXPORT_SYMBOL_GPL(setup_sysctl_set);
>  
>  #else /* !CONFIG_SYSCTL */
>  struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
