Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1EISD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:03:59 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55011 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1EISD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:03:58 -0400
Date: Mon, 9 May 2011 14:03:58 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josef Bacik <jbacik@redhat.com>
Message-ID: <1850345881.414857.1304964238493.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] fs: kill default_llseek
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 05 May 2011 16:27:57 Josef Bacik wrote:
> Looking at this llseek stuff I noticed that default_llseek is the exact same as
> generic_file_llseek, so kill default_llseek.  I patched this using spatch with
> just a simple
> 
> @@
> @@
> 
> - default_llseek
> + generic_file_llseek

...

> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index d245cb2..6f37c39 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -558,7 +558,7 @@ static int open_kcore(struct inode *inode, struct file *filp)
>  static const struct file_operations proc_kcore_operations = {
>  	.read		= read_kcore,
>  	.open		= open_kcore,
> -	.llseek		= default_llseek,
> +	.llseek		= generic_file_llseek,
>  };
 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 74802bc5..0cafd9e 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -163,7 +163,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  
>  static const struct file_operations proc_vmcore_operations = {
>  	.read		= read_vmcore,
> -	.llseek		= default_llseek,
> +	.llseek		= generic_file_llseek,
>  };
 
Both /proc/kcore and /proc/vmcore currently require default_llseek().  
They were both changed to use generic_file_llseek(), but then subsequently
reverted back to default_llseek():

commit c227e69028473c7c7994a9b0a2cc0034f3f7e0fe
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Sep 22 13:04:54 2010 -0700

    /proc/vmcore: fix seeking
    
    Commit 73296bc611 ("procfs: Use generic_file_llseek in /proc/vmcore")
    broke seeking on /proc/vmcore.  This changes it back to use default_llseek
    in order to restore the original behaviour.
    ...


commit ceff1a770933e2ca2bf995b453dade4ec47a9878
Author: Dave Anderson <anderson@redhat.com>
Date:   Wed Jan 12 17:00:36 2011 -0800

    /proc/kcore: fix seeking
    
    Commit 34aacb2920 ("procfs: Use generic_file_llseek in /proc/kcore") broke
    seeking on /proc/kcore.  This changes it back to use default_llseek in
    order to restore the original behavior.
    ...

Dave Anderson
