Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0I3U0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:26:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab0I3U0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:26:18 -0400
Date: Thu, 30 Sep 2010 15:26:12 -0500
From: Robin Holt <holt@sgi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, dipankar@in.ibm.com, holt@sgi.com,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, den@openvz.org, mingo@elte.hu,
        mszeredi@suse.cz, cmm@us.ibm.com, npiggin@kernel.dk, xemul@openvz.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V3] fs: allow for more than 2^31 files
Message-ID: <20100930202612.GM14068@sgi.com>
References: <20100923121704.GR14064@sgi.com>
 <1285246384.362.3.camel@edumazet-laptop>
 <20100923141037.GA3811@in.ibm.com>
 <20100927.153639.212415479.davem@davemloft.net>
 <1285645611.10438.27.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285645611.10438.27.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 05:46:51AM +0200, Eric Dumazet wrote:
> Le lundi 27 septembre 2010 à 15:36 -0700, David Miller a écrit :
...

> Fix is to let /proc/sys/fs/file-nr & /proc/sys/fs/file-max use long
> integers, and change af_unix to use an atomic_long_t instead of
> atomic_t.
> 
> get_max_files() is changed to return an unsigned long.

I _THINK_ we actually want get_max_files to return a long and have
the files_stat_struct definitions be longs.  If we do not have it that
way, we could theoretically open enough files on a single cpu to make
get_nr_files return a negative without overflowing max_files.  That,
of course, would require an insane amount of memory, but I think it is
technically more correct.


> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1352,16 +1352,16 @@ static struct ctl_table fs_table[] = {
>  	{
>  		.procname	= "file-nr",
>  		.data		= &files_stat,
> -		.maxlen		= 3*sizeof(int),
> +		.maxlen		= sizeof(files_stat),
>  		.mode		= 0444,
> -		.proc_handler	= proc_nr_files,
> +		.proc_handler	= proc_doulongvec_minmax,

With this change, don't we lose the current nr_files value?  I think
you need proc_nr_files to stay as it was.  If you disagree, we should
probably eliminate the definitions for proc_nr_files as I don't believe
they are used anywhere else.


Thanks,
Robin
