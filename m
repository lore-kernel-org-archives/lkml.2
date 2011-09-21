Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1IUW32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:29:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57006 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750748Ab1IUW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:29:27 -0400
Subject: Re: [PATCH 10/26] dynamic_debug: enlarge command/query write buffer
From: Joe Perches <joe@perches.com>
To: jim.cromie@gmail.com
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Sep 2011 15:29:26 -0700
In-Reply-To: <1316642115-20029-11-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-11-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316644167.3401.2.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 15:54 -0600, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Current write buffer is 256 bytes, on stack.  Allocate it off heap,
> and enlarge it to 4096 bytes, big enough for ~100 queries (at 40 bytes
> each), and error out if not.  This should be enough for most uses, and
> others can be split into 2 writes.
> 
> This makes it play nicely with:
>  $> cat debug-queries-file > /dbg/dynamic_debug/control
[]
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -590,24 +590,32 @@ __setup("ddebug_query=", ddebug_setup_query);
>   * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
>   * command text from userspace, parses and executes it.
>   */
> +#define USER_BUF_PAGE 4095

Why not just read into a fifo and parse
it until empty?

>  static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
>  				  size_t len, loff_t *offp)
>  {
> -	char tmpbuf[256];
> +	char *tmpbuf;
>  	int ret;
>  
>  	if (len == 0)
>  		return 0;
> -	/* we don't check *offp -- multiple writes() are allowed */
> -	if (len > sizeof(tmpbuf)-1)
> +	if (len > USER_BUF_PAGE - 1) {
> +		pr_warn("expected <%d bytes into control \n", USER_BUF_PAGE);
>  		return -E2BIG;
> -	if (copy_from_user(tmpbuf, ubuf, len))
> +	}

kfifo_from_user?


