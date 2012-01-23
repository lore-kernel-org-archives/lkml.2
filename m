Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2AWOpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:45:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38369 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2AWOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:45:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Earl Chew <echew@ixiacom.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com>
Date: Mon, 23 Jan 2012 06:47:46 -0800
In-Reply-To: <4F1C5995.3060806@ixiacom.com> (Earl Chew's message of "Sun, 22
	Jan 2012 10:46:45 -0800")
Message-ID: <m1fwf6pjal.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX187GwZrKGZJdxvpVcr//tPCBqvwJgqJyNc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew <echew@ixiacom.com> writes:

> The following illustrates the problem:
>
>     cat /proc/sys/kernel/threads-max | od -bc
>     0000000 065 062 071 071 062 012
>               5   2   9   9   2  \n
>     0000006
>
>     dd bs=1 < /proc/sys/kernel/threads-max | od -bc
>     1+0 records in
>     1+0 records out
>     1 byte (1 B) copied, 0.000102707 s, 9.7 kB/s
>     0000000 065
>               5
>     0000001
>
> The implementation in sysctl.c is inconsistent because support
> for small reads is available for strings (eg /proc/sys/kernel/core_pattern),
> but not integers.

The difference between strings and integers is that with strings
single byte reads/writes actually make sense.

Single decimal digits reads don't make much sense at all for integers.

Is there any compelling reason to support this complete idiocy from user
space programs?

Eric

> This issue was also reported in:
>
>     https://bugzilla.kernel.org/show_bug.cgi?id=19182
>
> Signed-off-by: Earl Chew <echew@ixiacom.com>
> ---
>  kernel/sysctl.c |   83 +++++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 57 insertions(+), 26 deletions(-)
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ae27196..b13d47b 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2215,31 +2215,41 @@ static int proc_get_long(char **buf, size_t *size,
>   * @size: the size of the user buffer
>   * @val: the integer to be converted
>   * @neg: sign of the number, %TRUE for negative
> + * @skip: the number of characters to skip
>   *
>   * In case of success %0 is returned and @buf and @size are updated with
>   * the amount of bytes written.
>   */
>  static int proc_put_long(void __user **buf, size_t *size, unsigned long val,
> -			  bool neg)
> +			  bool neg, loff_t *skip)
>  {
>  	int len;
>  	char tmp[TMPBUFLEN], *p = tmp;
>  
>  	sprintf(p, "%s%lu", neg ? "-" : "", val);
> -	len = strlen(tmp);
> -	if (len > *size)
> -		len = *size;
> -	if (copy_to_user(*buf, tmp, len))
> -		return -EFAULT;
> -	*size -= len;
> -	*buf += len;
> +	len = strlen(p);
> +	if (*skip >= len) {
> +		*skip -= len;
> +	} else {
> +		p += *skip;
> +		len -= *skip;
> +		*skip = 0;
> +		if (len > *size)
> +			len = *size;
> +		if (copy_to_user(*buf, p, len))
> +			return -EFAULT;
> +		*size -= len;
> +		*buf += len;
> +	}
>  	return 0;
>  }
>  #undef TMPBUFLEN
>  
> -static int proc_put_char(void __user **buf, size_t *size, char c)
> +static int proc_put_char(void __user **buf, size_t *size, char c, loff_t *skip)
>  {
> -	if (*size) {
> +	if (*skip) {
> +		(*skip)--;
> +	} else if (*size) {
>  		char __user **buffer = (char __user **)buf;
>  		if (put_user(c, *buffer))
>  			return -EFAULT;
> @@ -2279,10 +2289,11 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>  {
>  	int *i, vleft, first = 1, err = 0;
>  	unsigned long page = 0;
> +	loff_t skip = *ppos;
>  	size_t left;
>  	char *kbuf;
>  	
> -	if (!tbl_data || !table->maxlen || !*lenp || (*ppos && !write)) {
> +	if (!tbl_data || !table->maxlen || !*lenp) {
>  		*lenp = 0;
>  		return 0;
>  	}
> @@ -2331,18 +2342,26 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>  				err = -EINVAL;
>  				break;
>  			}
> -			if (!first)
> -				err = proc_put_char(&buffer, &left, '\t');
> +			if (!first) {
> +				err = proc_put_char(
> +					&buffer, &left, '\t', &skip);
> +			}
>  			if (err)
>  				break;
> -			err = proc_put_long(&buffer, &left, lval, neg);
> +			err = proc_put_long(&buffer, &left, lval, neg, &skip);
>  			if (err)
>  				break;
>  		}
>  	}
>  
> -	if (!write && !first && left && !err)
> -		err = proc_put_char(&buffer, &left, '\n');
> +	if (!write) {
> +		if (!first && !err)
> +			err = proc_put_char(&buffer, &left, '\n', &skip);
> +		if (!err && skip) {
> +			*lenp = 0;
> +			return 0;
> +		}
> +	}
>  	if (write && !err && left)
>  		left -= proc_skip_spaces(&kbuf);
>  free:
> @@ -2497,10 +2516,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  	unsigned long *i, *min, *max;
>  	int vleft, first = 1, err = 0;
>  	unsigned long page = 0;
> +	loff_t skip = *ppos;
>  	size_t left;
>  	char *kbuf;
>  
> -	if (!data || !table->maxlen || !*lenp || (*ppos && !write)) {
> +	if (!data || !table->maxlen || !*lenp) {
>  		*lenp = 0;
>  		return 0;
>  	}
> @@ -2546,15 +2566,22 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  		} else {
>  			val = convdiv * (*i) / convmul;
>  			if (!first)
> -				err = proc_put_char(&buffer, &left, '\t');
> -			err = proc_put_long(&buffer, &left, val, false);
> +				err = proc_put_char(
> +					&buffer, &left, '\t', &skip);
> +			err = proc_put_long(&buffer, &left, val, false, &skip);
>  			if (err)
>  				break;
>  		}
>  	}
>  
> -	if (!write && !first && left && !err)
> -		err = proc_put_char(&buffer, &left, '\n');
> +	if (!write) {
> +		if (!first && !err)
> +			err = proc_put_char(&buffer, &left, '\n', &skip);
> +		if (!err && skip) {
> +			*lenp = 0;
> +			return 0;
> +		}
> +	}
>  	if (write && !err)
>  		left -= proc_skip_spaces(&kbuf);
>  free:
> @@ -2805,6 +2832,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
>  	int err = 0;
>  	bool first = 1;
>  	size_t left = *lenp;
> +	loff_t skip = *ppos;
>  	unsigned long bitmap_len = table->maxlen;
>  	unsigned long *bitmap = (unsigned long *) table->data;
>  	unsigned long *tmp_bitmap = NULL;
> @@ -2893,18 +2921,21 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
>  						   bit_a + 1) - 1;
>  
>  			if (!first) {
> -				err = proc_put_char(&buffer, &left, ',');
> +				err = proc_put_char(&buffer, &left, ',', &skip);
>  				if (err)
>  					break;
>  			}
> -			err = proc_put_long(&buffer, &left, bit_a, false);
> +			err = proc_put_long(
> +				&buffer, &left, bit_a, false, &skip);
>  			if (err)
>  				break;
>  			if (bit_a != bit_b) {
> -				err = proc_put_char(&buffer, &left, '-');
> +				err = proc_put_char(
> +					&buffer, &left, '-', &skip);
>  				if (err)
>  					break;
> -				err = proc_put_long(&buffer, &left, bit_b, false);
> +				err = proc_put_long(
> +					&buffer, &left, bit_b, false, &skip);
>  				if (err)
>  					break;
>  			}
> @@ -2912,7 +2943,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
>  			first = 0; bit_b++;
>  		}
>  		if (!err)
> -			err = proc_put_char(&buffer, &left, '\n');
> +			err = proc_put_char(&buffer, &left, '\n', &skip);
>  	}
>  
>  	if (!err) {
