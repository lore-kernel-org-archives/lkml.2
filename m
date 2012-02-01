Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2BAUfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:35:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19841 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2BAUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:35:53 -0500
Date: Wed, 1 Feb 2012 21:36:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "devendra.aaru" <devendra.aaru@gmail.com>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized to
 0
In-Reply-To: <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1202012134410.8577@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net> <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com> <alpine.LNX.2.00.1202012050390.8577@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1028546279-1328128573=:8577"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1028546279-1328128573=:8577
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 1 Feb 2012, Jesper Juhl wrote:

> On Wed, 1 Feb 2012, devendra.aaru wrote:
> 
> > On Sun, Jan 29, 2012 at 5:39 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > We declare 'exact' without initializing it and then do:
> > >
> > > [...]
> > >        if (strlen(p->cru_driver_name))
> > >                exact = 1;
> > >
> > >        if (priority && !exact)
> > >                return -EINVAL;
> > >
> > > [...]
> > >
> > > If the first 'if' is not true, then the second will test an
> > > uninitialized 'exact'.
> > 
> > not needed . as the cru_driver_name will always be present :).
> 
> If that is indeed the case, and we are guaranteed that, then it would seem 
> that a patch like the following would be what we want instead??
> 
> Please note that this patch is intended just for discussion, nothing else 
> (which is why I left out a Signed-off-by on purpose), since I've not 
> tested it beyond checking that it compiles, nor have I verified your claim 
> that cru_driver_name will always be present.
> 
> Herbert, David, any input?
> 
> 
> Subject: [PATCH] Simplify crypto_add_alg() and crypto_alg_match()
> 
> Since cru_driver_name will always be present, the test
> 
> 	if (strlen(p->cru_driver_name))
> 		exact = 1;
> 
> will always be true. So there's no need to have the test at all, we
> can just unconditionally assign 1 to 'exact'.
> 
> And if 'exact' is always 1, then we'll never take the true branch of
> 
> 	if (priority && !exact)
> 		return -EINVAL;
> 
> so we may as well just remove those two lines completely.
> 
> At this point we may as well just remove 'exact' entirely and just use
> a hardcoded 1 in the call to crypto_alg_match().
> 
> The 'name' variable is also entirely redundant since with
> cru_driver_name always being present we'll always take the first
> branch in
> 
> 	if (strlen(p->cru_driver_name))
> 		name = p->cru_driver_name;
> 	else
> 		name = p->cru_name;
> 
> and then we may as well just use 'p->cru_driver_name' itself the one
> place where it is needed in the call to crypto_alg_mod_lookup().
> 
> At this point all calls to the static crypto_alg crypto_alg_match()
> function pass 1 as the second argument, so there's not really any
> point any more in that function having that argument, so let's remove
> it and the code that tests it.
> 
> And since strlen(p->cru_driver_name) will also always be true in that
> function, we can simplify the assignment to 'match'.
> 
> ---
>  crypto/crypto_user.c |   33 ++++++++-------------------------
>  1 files changed, 8 insertions(+), 25 deletions(-)
> 
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index 16f8693..7760c22 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -38,23 +38,19 @@ struct crypto_dump_info {
>  	u16 nlmsg_flags;
>  };
>  
> -static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
> +static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p)
>  {
>  	struct crypto_alg *q, *alg = NULL;
>  
>  	down_read(&crypto_alg_sem);
>  
>  	list_for_each_entry(q, &crypto_alg_list, cra_list) {
> -		int match = 0;
> +		int match;
>  
>  		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
>  			continue;
>  
> -		if (strlen(p->cru_driver_name))
> -			match = !strcmp(q->cra_driver_name,
> -					p->cru_driver_name);
> -		else if (!exact)
> -			match = !strcmp(q->cra_name, p->cru_name);
> +		match = !strcmp(q->cra_driver_name, p->cru_driver_name);
>  
>  		if (match) {

Actually, we could just get rid of 'match' entirely as well and just do

                if (!strcmp(q->cra_driver_name, p->cru_driver_name)) {

>  			alg = q;
> @@ -195,7 +191,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
>  	if (!p->cru_driver_name)
>  		return -EINVAL;
>  
> -	alg = crypto_alg_match(p, 1);
> +	alg = crypto_alg_match(p);
>  	if (!alg)
>  		return -ENOENT;
>  
> @@ -259,7 +255,7 @@ static int crypto_update_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (priority && !strlen(p->cru_driver_name))
>  		return -EINVAL;
>  
> -	alg = crypto_alg_match(p, 1);
> +	alg = crypto_alg_match(p);
>  	if (!alg)
>  		return -ENOENT;
>  
> @@ -283,7 +279,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct crypto_alg *alg;
>  	struct crypto_user_alg *p = nlmsg_data(nlh);
>  
> -	alg = crypto_alg_match(p, 1);
> +	alg = crypto_alg_match(p);
>  	if (!alg)
>  		return -ENOENT;
>  
> @@ -304,28 +300,15 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			  struct nlattr **attrs)
>  {
> -	int exact;
> -	const char *name;
>  	struct crypto_alg *alg;
>  	struct crypto_user_alg *p = nlmsg_data(nlh);
>  	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
>  
> -	if (strlen(p->cru_driver_name))
> -		exact = 1;
> -
> -	if (priority && !exact)
> -		return -EINVAL;
> -
> -	alg = crypto_alg_match(p, exact);
> +	alg = crypto_alg_match(p);
>  	if (alg)
>  		return -EEXIST;
>  
> -	if (strlen(p->cru_driver_name))
> -		name = p->cru_driver_name;
> -	else
> -		name = p->cru_name;
> -
> -	alg = crypto_alg_mod_lookup(name, p->cru_type, p->cru_mask);
> +	alg = crypto_alg_mod_lookup(p->cru_driver_name, p->cru_type, p->cru_mask);
>  	if (IS_ERR(alg))
>  		return PTR_ERR(alg);
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1028546279-1328128573=:8577--
