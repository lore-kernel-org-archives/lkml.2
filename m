Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1FUPsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab1FUPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:48:03 -0400
Date: Tue, 21 Jun 2011 11:44:58 -0400
From: Jason Baron <jbaron@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] jump_label: fix jump_label update
Message-ID: <20110621154458.GB2495@redhat.com>
References: <4E00038B.2060404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E00038B.2060404@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:35:55AM +0800, Xiao Guangrong wrote:
> The key of module is out of __stop___jump_table, it causes the events
> of modules does not work
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/jump_label.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index fa27e75..a8ce450 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -375,15 +375,19 @@ int jump_label_text_reserved(void *start, void *end)
>  
>  static void jump_label_update(struct jump_label_key *key, int enable)
>  {
> -	struct jump_entry *entry = key->entries;
> -
> -	/* if there are no users, entry can be NULL */
> -	if (entry)
> -		__jump_label_update(key, entry, __stop___jump_table, enable);
> +	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
>  
>  #ifdef CONFIG_MODULES
> +	struct module *mod = __module_address((jump_label_t)key);
> +
>  	__jump_label_mod_update(key, enable);
> +
> +	if (mod)
> +		stop = mod->jump_entries + mod->num_jump_entries;
>  #endif
> +	/* if there are no users, entry can be NULL */
> +	if (entry)
> +		__jump_label_update(key, entry, stop, enable);
>  }
>  
>  #endif
> -- 
> 1.7.5.4

Looks good. Thanks for the fix!

Acked-by: Jason Baron <jbaron@redhat.com>

-Jason
