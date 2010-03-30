Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0C3QZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:25:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56080 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C3QZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:25:10 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] s390: potential buffer overflow
References: <20100330094342.GJ5069@bicker>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Mar 2010 09:25:01 -0700
In-Reply-To: <20100330094342.GJ5069@bicker> (Dan Carpenter's message of "Tue\, 30 Mar 2010 12\:43\:42 +0300")
Message-ID: <m1k4strd42.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: error27@gmail.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, sebott@linux.vnet.ibm.com, hans@linux.vnet.ibm.com, linux390@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> "len" hasn't been properly range checked so we shouldn't use it as an
> array offset.  This can only be written to by root but it would still be
> annoying to accidentally write more than 3 characters and corrupt your
> memory.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> I don't have a cross compile environment to compile this.  Sorry.  :/
>
> diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
> index f449c69..72c2e90 100644
> --- a/drivers/s390/char/sclp_async.c
> +++ b/drivers/s390/char/sclp_async.c
> @@ -84,7 +84,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
>  		rc = copy_from_user(buf, buffer, sizeof(buf));
>  		if (rc != 0)
>  			return -EFAULT;
> -		buf[len - 1] = '\0';
> +		buf[sizeof(buf) - 1] = '\0';
>  		if (strict_strtoul(buf, 0, &val) != 0)
>  			return -EINVAL;
>  		if (val != 0 && val != 1)
> @@ -99,6 +99,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
>  static struct ctl_table callhome_table[] = {
>  	{
>  		.procname	= "callhome",
> +		.maxlen		= 3,
>  		.mode		= 0644,
>  		.proc_handler	= proc_handler_callhome,
>  	},

Setting maxlen won't do any good as proc_handler_callhome doesn't look at it.

Eric

