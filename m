Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2CRO3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 10:29:39 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:58756 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab2CRO3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 10:29:37 -0400
Message-ID: <4F65F14D.60001@bfs.de>
Date: Sun, 18 Mar 2012 15:29:33 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: santosh nayak <santoshprasadnayak@gmail.com>
CC: takedakn@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp,
        james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Return error if fails to delete a domain.
References: <1331924100-26033-1-git-send-email-santoshprasadnayak@gmail.com>
In-Reply-To: <1331924100-26033-1-git-send-email-santoshprasadnayak@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 16.03.2012 19:55, schrieb santosh nayak:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Call sequence:
> tomoyo_write_domain() --> tomoyo_delete_domain()
> 
> In 'tomoyo_delete_domain',  return  -EINTR if locking attempt is
> interrupted by signal.
> 
> At present it returns success to its caller 'tomoyo_write_domain()'
> even though domain is not deleted. 'tomoyo_write_domain()' assumes
> domain is deleted and returns success to its caller. This is
> wrong behaviour.
> 
> 'tomoyo_write_domain' should return error '-EAGAIN' to its caller if
> tomoyo_delete_domain() returns -EINTR.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  security/tomoyo/common.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
> index c47d3ce..3ee1c3a 100644
> --- a/security/tomoyo/common.c
> +++ b/security/tomoyo/common.c
> @@ -1081,7 +1081,7 @@ static int tomoyo_delete_domain(char *domainname)
>  	name.name = domainname;
>  	tomoyo_fill_path_info(&name);
>  	if (mutex_lock_interruptible(&tomoyo_policy_lock))
> -		return 0;
> +		return -EINTR;
>  	/* Is there an active domain? */
>  	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
>  		/* Never delete tomoyo_kernel_domain */
> @@ -1163,16 +1163,20 @@ static int tomoyo_write_domain(struct tomoyo_io_buffer *head)
>  	const bool is_delete = head->w.is_delete;
>  	bool is_select = !is_delete && tomoyo_str_starts(&data, "select ");
>  	unsigned int profile;
> +	int ret = 0;
>  	if (*data == '<') {
>  		domain = NULL;
> -		if (is_delete)
> -			tomoyo_delete_domain(data);
> +		if (is_delete) {
> +			ret = tomoyo_delete_domain(data);
> +			if (ret)
> +				return -EAGAIN;
> +		}
>  		else if (is_select)
>  			domain = tomoyo_find_domain(data);
>  		else
>  			domain = tomoyo_assign_domain(data, false);
>  		head->w.domain = domain;
> -		return 0;
> +		return ret;


hi all,
does domain anything useful here ?

re,
 wh


>  	}
>  	if (!domain)
>  		return -EINVAL;
