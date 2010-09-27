Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab0I0PZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:25:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10122 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0I0PZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:25:11 -0400
Message-ID: <4CA0B743.2050801@parallels.com>
Date: Mon, 27 Sep 2010 19:24:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix numbering in /proc/locks
References: <4CA0B4A5.1090701@redhat.com>
In-Reply-To: <4CA0B4A5.1090701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 07:13 PM, Jerome Marchand wrote:
> 
> The lock number in /proc/locks (first field) is implemented by a counter
> (private field of struct seq_file) which is incremented at each call of
> locks_show(). Currently it is reset each time locks_start() is called,
> that is each time we call the read() syscall on /proc/locks. Because of
> that, the numbering erratically restarts at 1 several times when reading
> a long /proc/locks file.
> We want the counter to be initialized at opening time and then never
> reset until we close the file. Fortunately, seq_open() memzeros the
> seq_file structure, so we can just drop the reset in locks_start() and
> move the increment the counter before actually printing the line so the
> numbering still starts at 1.

IMHO the implementation is wrong. If you want the proper sequence number
while file is open you should increase on in the ->next callback of the
seq_ops, not in show.

> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
> diff --git a/fs/locks.c b/fs/locks.c
> index ab24d49..a5eab5e 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2161,19 +2161,18 @@ static int locks_show(struct seq_file *f, void *v)
>  
>  	fl = list_entry(v, struct file_lock, fl_link);
>  
> +	f->private++;
>  	lock_get_status(f, fl, (long)f->private, "");
>  
>  	list_for_each_entry(bfl, &fl->fl_block, fl_block)
>  		lock_get_status(f, bfl, (long)f->private, " ->");
>  
> -	f->private++;
>  	return 0;
>  }
>  
>  static void *locks_start(struct seq_file *f, loff_t *pos)
>  {
>  	lock_kernel();
> -	f->private = (void *)1;
>  	return seq_list_start(&file_lock_list, *pos);
>  }
>  
> 

