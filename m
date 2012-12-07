Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424046Ab2LGCkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:40:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44737 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422709Ab2LGCkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:40:16 -0500
Message-ID: <1354848015.22463.17.camel@joe-AO722>
Subject: Re: [PATCH] printk: Fix print_time length computation when no
 buffer is given
From: Joe Perches <joe@perches.com>
To: Sylvain Munaut <s.munaut@whatever-company.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, stable@kernel.org
Date: Thu, 06 Dec 2012 18:40:15 -0800
In-Reply-To: <1354813775-32451-1-git-send-email-s.munaut@whatever-company.com>
References: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
	 <1354813775-32451-1-git-send-email-s.munaut@whatever-company.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 18:09 +0100, Sylvain Munaut wrote:
> The "%5lu" part of the sprintf only guarantees a minimum length,
> not a maximum one. This patch should make it correct for any
> possible timestamp.
> 
> This problem dates back from the printk conversion to records AFAICT.
> 
> I've tested this locally both by verifying 'dmesg' no longer
> segfaulted and also by checking that before this patch the
> buffer was overrun by exactly the number of char corresponding to
> extra digits in the timestamps.
> 
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: stable@kernel.org
> Signed-off-by: Sylvain Munaut <s.munaut@whatever-company.com>
> ---
>  kernel/printk.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 66a2ea3..2ceceea 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -847,8 +847,17 @@ static size_t print_time(u64 ts, char *buf)
>  	if (!printk_time)
>  		return 0;
>  
> -	if (!buf)
> -		return 15;
> +	if (!buf) {
> +		size_t len = 15;
> +		u64 ts_limit = (u64)100000 * (u64)1000000000;
> +
> +		while ((ts > ts_limit) && (len < 21)) {
> +			len++;
> +			ts_limit = 10 * ts_limit;
> +		}

Perhaps use snprintf for sizing something like below?
(untested/uncompiled)

static size_t print_time(u64 ts, char *buf)
{
	unsigned long rem_nsec;
	char *tmpbuf = buf;
	int size = 15;			/* expected size of non-null buf */
	char local_buf[1];

	if (!printk_time)
		return 0;

	if (!buf) {			/* emit to a dummy buf instead */
		tmpbuf = local_buf;
		size = sizeof(local_buf);
	}
	
	rem_nsec = do_div(ts, 1000000000);

	return snprintf(tmpbuf, size, "[%5lu.%06lu] ",
			(unsigned long)ts, rem_nsec / 1000);
}

It's perhaps unfortunate that print_time doesn't take a
a buffer and a size_t of buffer.


