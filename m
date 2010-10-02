Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0JBI67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:58:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42151 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0JBI65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:58:57 -0400
X-AuditID: b753bd60-a88d0ba000005dcc-dc-4ca6f44d73b1
Message-ID: <4CA6F44A.1000907@hitachi.com>
Date: Sat, 02 Oct 2010 17:58:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/5] jump label: fix module __init section race
References: <cover.1285965957.git.jbaron@redhat.com> <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
In-Reply-To: <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/02 6:23), Jason Baron wrote:
> Jump label uses is_module_text_address() to ensure that the module
> __init sections are valid before updating them. However, between the
> check for a valid module __init section and the subsequent jump
> label update, the module's __init section could be freed out from under
> us.
> 
> We fix this potential race by adding a notifier callback to the
> MODULE_STATE_LIVE state. This notifier is called *after* the __init
> section has been run but before it is going to be freed. In the
> callback, the jump label code zeros the key value for any __init jump
> code within the module, and we add a check for a non-zero key value when
> we update jump labels. In this way we require no additional data
> structures.
> 
> Thanks to Mathieu Desnoyers for pointing out this race condition.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/jump_label.c |   41 ++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 40 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 7be868b..e2fad92 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  			count = e_module->nr_entries;
>  			iter = e_module->table;
>  			while (count--) {
> -				if (kernel_text_address(iter->code))
> +				if (iter->key &&
> +						kernel_text_address(iter->code))
>  					arch_jump_label_transform(iter, type);
>  				iter++;
>  			}
> @@ -366,6 +367,39 @@ static void remove_jump_label_module(struct module *mod)
>  	}
>  }
>  
> +static void remove_module_init(struct module *mod)

Hi Jason,

Just a comment, I prefer remove_jump_label_module_init() than this name,
because remove_module_init is too general.

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
