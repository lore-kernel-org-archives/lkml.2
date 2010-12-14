Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab0LNWS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:18:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab0LNWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:18:26 -0500
Date: Tue, 14 Dec 2010 17:18:16 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH][rfc] md: Close mem leak in userspace_ctr()
Message-ID: <20101214221816.GA14227@redhat.com>
References: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13 2010 at  6:40pm -0500,
Jesper Juhl <jj@chaosbits.net> wrote:

> Hi,
> 
> There's a small memory leak in 
> drivers/md/dm-log-userspace-base.c::userspace_ctr().
> 
> The call to build_constructor_string() dynamically allocates memory for 
> its last argument, but we do not always clean up that allocated memory.

I'm not seeing a leak.

The kfree() that you've added to the build_constructor_string() failure
path isn't needed because build_constructor_string() only returns error
if the kzalloc() failed.

Mike

> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 1ed0094..71a3049 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
> @@ -99,26 +99,22 @@ static int build_constructor_string(struct dm_target *ti,
>  				    char **ctr_str)
>  {
>  	int i, str_size;
> -	char *str = NULL;
> -
> -	*ctr_str = NULL;
>  
>  	for (i = 0, str_size = 0; i < argc; i++)
>  		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
>  
>  	str_size += 20; /* Max number of chars in a printed u64 number */
>  
> -	str = kzalloc(str_size, GFP_KERNEL);
> -	if (!str) {
> +	*ctr_str = kzalloc(str_size, GFP_KERNEL);
> +	if (!*ctr_str) {
>  		DMWARN("Unable to allocate memory for constructor string");
>  		return -ENOMEM;
>  	}
>  
> -	str_size = sprintf(str, "%llu", (unsigned long long)ti->len);
> +	str_size = sprintf(*ctr_str, "%llu", (unsigned long long)ti->len);
>  	for (i = 0; i < argc; i++)
> -		str_size += sprintf(str + str_size, " %s", argv[i]);
> +		str_size += sprintf(*ctr_str + str_size, " %s", argv[i]);
>  
> -	*ctr_str = str;
>  	return str_size;
>  }
>  
> @@ -140,7 +136,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  {
>  	int r = 0;
>  	int str_size;
> -	char *ctr_str = NULL;
> +	char *ctr_str;
>  	struct log_c *lc = NULL;
>  	uint64_t rdata;
>  	size_t rdata_size = sizeof(rdata);
> @@ -173,6 +169,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  
>  	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
>  	if (str_size < 0) {
> +		kfree(ctr_str);
>  		kfree(lc);
>  		return str_size;
>  	}
