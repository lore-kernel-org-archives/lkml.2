Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HEAgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2HEAgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:36:38 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=PrZ6d8cNei4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pGLkceISAAAA:8 a=ZbNDx9BeURdUlYJOclgA:9 a=PUjeQqilurYA:10 a=E6k37eg1NvgA:10 a=MSl-tDqOz04A:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344126994.27983.116.camel@gandalf.stny.rr.com>
Subject: Re: [RFC v2 6/7] tracepoint: use new hashtable implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, mingo@elte.hu,
        ebiederm@xmission.com, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Sat, 04 Aug 2012 20:36:34 -0400
In-Reply-To: <1344003788-1417-7-git-send-email-levinsasha928@gmail.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
	 <1344003788-1417-7-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, Mathieu is the author of this file.

-- Steve


On Fri, 2012-08-03 at 16:23 +0200, Sasha Levin wrote:
> Switch tracepoints to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in the tracepoints.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  kernel/tracepoint.c |   26 +++++++++-----------------
>  1 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index d96ba22..b5a2650 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -26,6 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/static_key.h>
> +#include <linux/hashtable.h>
>  
>  extern struct tracepoint * const __start___tracepoints_ptrs[];
>  extern struct tracepoint * const __stop___tracepoints_ptrs[];
> @@ -49,8 +50,7 @@ static LIST_HEAD(tracepoint_module_list);
>   * Protected by tracepoints_mutex.
>   */
>  #define TRACEPOINT_HASH_BITS 6
> -#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
> -static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
> +DEFINE_STATIC_HASHTABLE(tracepoint_table, TRACEPOINT_HASH_BITS);
>  
>  /*
>   * Note about RCU :
> @@ -191,16 +191,14 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>   */
>  static struct tracepoint_entry *get_tracepoint(const char *name)
>  {
> -	struct hlist_head *head;
>  	struct hlist_node *node;
>  	struct tracepoint_entry *e;
>  	u32 hash = jhash(name, strlen(name), 0);
>  
> -	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
> -	hlist_for_each_entry(e, node, head, hlist) {
> +	hash_for_each_possible(&tracepoint_table, node, e, hlist, hash)
>  		if (!strcmp(name, e->name))
>  			return e;
> -	}
> +
>  	return NULL;
>  }
>  
> @@ -210,19 +208,13 @@ static struct tracepoint_entry *get_tracepoint(const char *name)
>   */
>  static struct tracepoint_entry *add_tracepoint(const char *name)
>  {
> -	struct hlist_head *head;
> -	struct hlist_node *node;
>  	struct tracepoint_entry *e;
>  	size_t name_len = strlen(name) + 1;
>  	u32 hash = jhash(name, name_len-1, 0);
>  
> -	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
> -	hlist_for_each_entry(e, node, head, hlist) {
> -		if (!strcmp(name, e->name)) {
> -			printk(KERN_NOTICE
> -				"tracepoint %s busy\n", name);
> -			return ERR_PTR(-EEXIST);	/* Already there */
> -		}
> +	if (get_tracepoint(name)) {
> +		printk(KERN_NOTICE "tracepoint %s busy\n", name);
> +		return ERR_PTR(-EEXIST);	/* Already there */
>  	}
>  	/*
>  	 * Using kmalloc here to allocate a variable length element. Could
> @@ -234,7 +226,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
>  	memcpy(&e->name[0], name, name_len);
>  	e->funcs = NULL;
>  	e->refcount = 0;
> -	hlist_add_head(&e->hlist, head);
> +	hash_add(&tracepoint_table, &e->hlist, hash);
>  	return e;
>  }
>  
> @@ -244,7 +236,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
>   */
>  static inline void remove_tracepoint(struct tracepoint_entry *e)
>  {
> -	hlist_del(&e->hlist);
> +	hash_del(&e->hlist);
>  	kfree(e);
>  }
>  


