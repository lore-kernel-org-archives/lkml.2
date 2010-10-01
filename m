Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0JAHOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:14:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25946 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab0JAHOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:14:10 -0400
Message-ID: <4CA58A2E.2040806@parallels.com>
Date: Fri, 01 Oct 2010 11:13:50 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] procfs: fix numbering in /proc/locks
References: <4CA484BA.7090809@redhat.com>
In-Reply-To: <4CA484BA.7090809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 04:38 PM, Jerome Marchand wrote:
> 
> The lock number in /proc/locks (first field) is implemented by a counter
> (private field of struct seq_file) which is incremented at each call of
> locks_show() and reset to 1 in locks_start() whatever the offset is. It
> should be reset according to the actual position in the list.
> 
> Moreover, locks_show() can be called twice to print a single line thus
> skipping a number. The counter should be incremented in locks_next().
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> ---
>  locks.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index ab24d49..49d7343 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2166,19 +2166,19 @@ static int locks_show(struct seq_file *f, void *v)
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
> +	f->private = (void *) (*pos + 1);
>  	return seq_list_start(&file_lock_list, *pos);
>  }
>  
>  static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
>  {
> +	f->private++;
>  	return seq_list_next(v, &file_lock_list, pos);
>  }
>  
> .
> 

