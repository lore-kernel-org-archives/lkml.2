Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1AEAwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:52:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1AEAwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:52:01 -0500
Date: Tue, 4 Jan 2011 16:51:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: make proc entry's len "unsigned int"
Message-Id: <20110104165159.49c257b7.akpm@linux-foundation.org>
In-Reply-To: <20101126211033.GA14339@core2.telecom.by>
References: <20101126211033.GA14339@core2.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 23:10:33 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Space is not really conserved, because of natural alignment for the next field.
> 
> ...
> 
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -28,7 +28,7 @@
>  
>  DEFINE_SPINLOCK(proc_subdir_lock);
>  
> -static int proc_match(int len, const char *name, struct proc_dir_entry *de)
> +static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
>  {
>  	if (de->namelen != len)
>  		return 0;
> @@ -303,7 +303,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>  {
>  	const char     		*cp = name, *next;
>  	struct proc_dir_entry	*de;
> -	int			len;
> +	unsigned int		len;
>  
>  	de = *ret;
>  	if (!de)
> @@ -605,7 +605,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
>  {
>  	struct proc_dir_entry *ent = NULL;
>  	const char *fn = name;
> -	int len;
> +	unsigned int len;
>  
>  	/* make sure name is valid */
>  	if (!name || !strlen(name)) goto out;
> @@ -794,7 +794,7 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
>  	struct proc_dir_entry **p;
>  	struct proc_dir_entry *de = NULL;
>  	const char *fn = name;
> -	int len;
> +	unsigned int len;
>  
>  	spin_lock(&proc_subdir_lock);
>  	if (__xlate_proc_name(name, &parent, &fn) != 0) {
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -50,7 +50,7 @@ typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
>  
>  struct proc_dir_entry {
>  	unsigned int low_ino;
> -	unsigned short namelen;
> +	unsigned int namelen;
>  	const char *name;
>  	mode_t mode;
>  	nlink_t nlink;

Well, if we _can_ save some space here then the returns would be
appreciable.

akpm:/home/akpm# find /proc | wc -l
95543

(wtf?)

akpm:/home/akpm# find /proc/[0-9]* | wc -l
94212

(oh.)

Do all of those things have a proc_dir_entry?  IIRC we changed things
so they're somewhat allocate-on-demand.
