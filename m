Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1AKAxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:53:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48821 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1AKAxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mz+Ke8psLDP9XhOpbuJqanacXf/0Q63E00K1C9hwBoOLPf4vF+HkXs9SYpCynUfW6M
         TXPvmH/tOjeO9y2zRipU1ijlhFlrFtp8YSvB9QkGJ3dzKdQJNjhDBMyvh/w8am7FEVp0
         Xq3jpmNwZKaCRxobFDgBvw6y/Eji+YqhozB3Q=
Date: Tue, 11 Jan 2011 01:52:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] /proc/kcore: fix seeking
Message-ID: <20110111005256.GC2570@nowhere>
References: <4D2B1AD5.9000707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B1AD5.9000707@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding stable and Andrew in Cc)

On Mon, Jan 10, 2011 at 09:42:29AM -0500, Dave Anderson wrote:
> From: Dave Anderson <anderson@redhat.com>
> 
> Commit 34aacb2920667d405a8df15968b7f71ba46c8f18
> ("procfs: Use generic_file_llseek in /proc/kcore")
> broke seeking on /proc/kcore.  This changes it back
> to use default_llseek in order to restore the original
> behavior.
> 
> The problem with generic_file_llseek is that it only
> allows seeks up to inode->i_sb->s_maxbytes, which is
> 2GB-1 on procfs, where the memory file offset values in
> the /proc/kcore PT_LOAD segments may exceed or start
> beyond that offset value.
> 
> A similar revert was made for /proc/vmcore.
> 
> Signed-off-by: Dave Anderson <anderson@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

In the longer term, I guess default_llseek should disappear
and replaced with generic_file_llseek(), tweaking the sb->s_maxbytes
with the appropriate values in each filesystems.

Thanks for this fix!


> --- linux-2.6.37/fs/proc/kcore.c.orig
> +++ linux-2.6.37/fs/proc/kcore.c
> @@ -558,7 +558,7 @@ static int open_kcore(struct inode *inod
>  static const struct file_operations proc_kcore_operations = {
>  	.read		= read_kcore,
>  	.open		= open_kcore,
> -	.llseek		= generic_file_llseek,
> +	.llseek		= default_llseek,
>  };
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG

