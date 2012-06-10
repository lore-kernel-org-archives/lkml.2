Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2FJCCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:02:09 -0400
Received: from nm25.access.bullet.mail.sp2.yahoo.com ([98.139.44.152]:24436
	"HELO nm25.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754616Ab2FJCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:02:08 -0400
X-Yahoo-Newman-Id: 65997.70315.bm@omp1010.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DqDgysAVM1nAbFaIGKK04hmnoUk9EDzY7oc1nOVnbdc0Sq2
 e4WsluZcABKErhc62veiIQHa6sGqNCj_N7WJ7EUJtNbWFsAZXNX7ga9H1SGW
 2iP99rpBHuDFGmt45PmhCbp1KNCb3ANembPsyPH5ecEyA_QbKlPtdaeGenHh
 bbiflZMj_ucMTnA_vnKv4jtgNB7G2pMUKQmxo6OVb.U1dvweYMieIF0FTwn4
 UG0WVbeeCrGJj.a4LPG8.keHB9bWqSNnZzSgU4llad8tfX_8t45X9bm61pZZ
 MhTSWBH_6I9Ym3PQQAaDSfLbgw0ZoagH7v552fm1sZ7IL5WQoJkodjxlKgTE
 ZSa6iI_Mh9k_Jrrs.r2NKyf2ZB2NjnuV0PjmH6HK_sCMTt1IZvfNQjByULBX
 l1Xa1zQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD40024.9070407@att.net>
Date: Sat, 09 Jun 2012 21:02:12 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/mtd/ubi/wl.c: optimization for in_wl_tree()
References: <1339293473-29444-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1339293473-29444-1-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and I forgot to mention that I haven't tested it (don't have this
device), but it does compile.

On 06/09/2012 08:57 PM, Daniel Santos wrote:
> Essentially, instead of performing a search through the tree from the
> top down, like we would when doing a lookup, we can just search from the
> node up and then check to see if the root of the tree that the node is
> in is the same as the one supplied.  Note that if you call this passing
> a ubi_wl_entry who's u.rb member has not been inited with rb_init_node()
> or added to a tree, the results are undefined.
>
> This should be a little faster, but mostly, it'll be smaller.
> ---
>  drivers/mtd/ubi/wl.c |   32 ++++++++------------------------
>  1 files changed, 8 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 9df100a..d415011 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -287,33 +287,17 @@ static int produce_free_peb(struct ubi_device *ubi)
>   */
>  static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
>  {
> -	struct rb_node *p;
> -
> -	p = root->rb_node;
> -	while (p) {
> -		struct ubi_wl_entry *e1;
> +	struct rb_node *p = &e->u.rb, *parent = rb_parent(&e->u.rb);
>  
> -		e1 = rb_entry(p, struct ubi_wl_entry, u.rb);
> -
> -		if (e->pnum == e1->pnum) {
> -			ubi_assert(e == e1);
> -			return 1;
> -		}
> +	if (parent == p)
> +		return 0;
>  
> -		if (e->ec < e1->ec)
> -			p = p->rb_left;
> -		else if (e->ec > e1->ec)
> -			p = p->rb_right;
> -		else {
> -			ubi_assert(e->pnum != e1->pnum);
> -			if (e->pnum < e1->pnum)
> -				p = p->rb_left;
> -			else
> -				p = p->rb_right;
> -		}
> -	}
> +	do {
> +		p = parent;
> +		parent = rb_parent(parent);
> +	} while (parent);
>  
> -	return 0;
> +	return p == root->rb_node;
>  }
>  
>  /**

-- 
Daniel

"Just because you go to church on Sunday, it doesn't absolve you from
where you put your dick during the week" -- Michele Q.

