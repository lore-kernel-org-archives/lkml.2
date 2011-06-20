Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1FTMx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1FTMx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:53:56 -0400
Date: Mon, 20 Jun 2011 14:53:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: fix  jump_label update
Message-ID: <20110620125345.GC2056@jolsa.brq.redhat.com>
References: <4DFBB2D5.2060003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFBB2D5.2060003@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 04:02:29AM +0800, Xiao Guangrong wrote:
> The key of module is out of __stop___jump_table, it causes the events
> of modules does not work

right, I missed the case when the key is defined in the module itself


> 
> This bug is introduced by commit: 7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/jump_label.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index fa27e75..dcad2fb 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -375,11 +375,15 @@ int jump_label_text_reserved(void *start, void *end)
>  
>  static void jump_label_update(struct jump_label_key *key, int enable)
>  {
> -	struct jump_entry *entry = key->entries;
> +	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
> +	struct module *mod = __module_address((jump_label_t)key);
> +
> +	if (mod)
> +		stop = mod->jump_entries + mod->num_jump_entries;
this breaks !CONFIG_MODULES compilation

thanks,
jirka

>  
>  	/* if there are no users, entry can be NULL */
>  	if (entry)
> -		__jump_label_update(key, entry, __stop___jump_table, enable);
> +		__jump_label_update(key, entry, stop, enable);
>  
>  #ifdef CONFIG_MODULES
>  	__jump_label_mod_update(key, enable);
> -- 
> 1.7.5.4
