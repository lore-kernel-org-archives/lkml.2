Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2FSQuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:50:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37281 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2FSQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:50:15 -0400
Message-ID: <4FE0AD89.6000001@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 11:49:13 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] cleanup the code between tmem_obj_init and tmem_obj_find
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03A55.7070503@linux.vnet.ibm.com>
In-Reply-To: <4FE03A55.7070503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061916-3534-0000-0000-0000098B7026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes a crash, details below.

On 06/19/2012 03:37 AM, Xiao Guangrong wrote:

> tmem_obj_find and insertion tmem-obj have the some logic, we can integrate
> the code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/tmem.c |   58 +++++++++++++++++++++-------------------
>  1 files changed, 30 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
> index 1ca66ea..cdf2d3c 100644
> --- a/drivers/staging/zcache/tmem.c
> +++ b/drivers/staging/zcache/tmem.c
> @@ -72,33 +72,48 @@ void tmem_register_pamops(struct tmem_pamops *m)
>   * the hashbucket lock must be held.
>   */
> 
> -/* searches for object==oid in pool, returns locked object if found */
> -static struct tmem_obj *tmem_obj_find(struct tmem_hashbucket *hb,
> -					struct tmem_oid *oidp)
> +static struct tmem_obj
> +*__tmem_obj_find(struct tmem_hashbucket*hb, struct tmem_oid *oidp,
> +		 struct rb_node *parent, struct rb_node **link)
>  {
> -	struct rb_node *rbnode;
> +	struct rb_node **rbnode;
>  	struct tmem_obj *obj;
> 
> -	rbnode = hb->obj_rb_root.rb_node;
> -	while (rbnode) {
> -		BUG_ON(RB_EMPTY_NODE(rbnode));
> -		obj = rb_entry(rbnode, struct tmem_obj, rb_tree_node);
> +	rbnode = &hb->obj_rb_root.rb_node;
> +	while (*rbnode) {
> +		BUG_ON(RB_EMPTY_NODE(*rbnode));
> +		obj = rb_entry(*rbnode, struct tmem_obj,
> +			       rb_tree_node);
>  		switch (tmem_oid_compare(oidp, &obj->oid)) {
>  		case 0: /* equal */
>  			goto out;
>  		case -1:
> -			rbnode = rbnode->rb_left;
> +			rbnode = &(*rbnode)->rb_left;
>  			break;
>  		case 1:
> -			rbnode = rbnode->rb_right;
> +			rbnode = &(*rbnode)->rb_right;
>  			break;
>  		}
>  	}
> +
> +	if (parent)
> +		parent = &obj->rb_tree_node;
> +	if (link)
> +		link = rbnode;
> +
>  	obj = NULL;
>  out:
>  	return obj;
>  }
> 
> +
> +/* searches for object==oid in pool, returns locked object if found */
> +static struct tmem_obj *tmem_obj_find(struct tmem_hashbucket *hb,
> +					struct tmem_oid *oidp)
> +{
> +	return __tmem_obj_find(hb, oidp, NULL, NULL);
> +}
> +
>  static void tmem_pampd_destroy_all_in_obj(struct tmem_obj *);
> 
>  /* free an object that has no more pampds in it */
> @@ -131,8 +146,7 @@ static void tmem_obj_init(struct tmem_obj *obj, struct tmem_hashbucket *hb,
>  					struct tmem_oid *oidp)
>  {
>  	struct rb_root *root = &hb->obj_rb_root;
> -	struct rb_node **new = &(root->rb_node), *parent = NULL;
> -	struct tmem_obj *this;
> +	struct rb_node **new = NULL, *parent = NULL;
> 
>  	BUG_ON(pool == NULL);
>  	atomic_inc(&pool->obj_count);
> @@ -144,22 +158,10 @@ static void tmem_obj_init(struct tmem_obj *obj, struct tmem_hashbucket *hb,
>  	obj->pampd_count = 0;
>  	(*tmem_pamops.new_obj)(obj);
>  	SET_SENTINEL(obj, OBJ);
> -	while (*new) {
> -		BUG_ON(RB_EMPTY_NODE(*new));
> -		this = rb_entry(*new, struct tmem_obj, rb_tree_node);
> -		parent = *new;
> -		switch (tmem_oid_compare(oidp, &this->oid)) {
> -		case 0:
> -			BUG(); /* already present; should never happen! */
> -			break;
> -		case -1:
> -			new = &(*new)->rb_left;
> -			break;
> -		case 1:
> -			new = &(*new)->rb_right;
> -			break;
> -		}
> -	}
> +
> +	if (__tmem_obj_find(hb, oidp, parent, new))
> +		BUG();
> +
>  	rb_link_node(&obj->rb_tree_node, parent, new);


Getting a NULL deref crash here because new is NULL

[   56.422031] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   56.423008] IP: [<ffffffff812b8ba4>] tmem_put+0x3a4/0x3d0

static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
				struct rb_node ** rb_link)
{
...
	*rb_link = node;
ffffffff812b8ba4:	48 89 38             	mov    %rdi,(%rax) <--- here
ffffffff812b8ba7:	e8 00 00 00 00       	callq  ffffffff812b8bac <tmem_put+0x3ac>

--
Seth

