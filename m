Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1FUAjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:39:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1FUAjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:39:36 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=XYJHFtupD_QA:10 a=Mm2usJTNaYsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=0jCsFKKTGwoQmvHOPXAA:9 a=J-WSUEOF68lV2ECgQxsA:7 a=CjuIK1q_8ugA:10 a=T300VAY8Y_5_W7Dm:21 a=2I2dwy_6b_msad-5:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 20 Jun 2011 20:39:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: fix  jump_label update
Message-ID: <20110621003934.GG27245@home.goodmis.org>
References: <4DFBB2D5.2060003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFBB2D5.2060003@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 04:02:29AM +0800, Xiao Guangrong wrote:
> The key of module is out of __stop___jump_table, it causes the events
> of modules does not work
> 
> This bug is introduced by commit: 7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d

What exactly breaks? I just tried events in modules, and they still work
for me.

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
>  
>  	/* if there are no users, entry can be NULL */
>  	if (entry)
> -		__jump_label_update(key, entry, __stop___jump_table, enable);
> +		__jump_label_update(key, entry, stop, enable);
>  
>  #ifdef CONFIG_MODULES
>  	__jump_label_mod_update(key, enable);

Doesn't the __jump_label_mod_update() do the job?

-- Steve
