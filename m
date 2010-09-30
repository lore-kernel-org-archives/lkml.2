Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0I3Upx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:45:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43764 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0I3Upw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o0KNjK6Uzp3BVF9GSJVdXkoOktb4zPMlqeSILWWtKowWK6YKf4Vmf0hEdja9KqQV9m
         ooc3xNgmiI8pDg9Jxw6jb/SiusS8QvL5Yg4U/aTZiCYdDfGoGDMXjjpEokUxVYeBw2Eb
         S7JZqYYcIyd1hbiIPmul5j9VsQjtwfB0IgPPc=
Subject: Re: [PATCH V3] fs: allow for more than 2^31 files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: David Miller <davem@davemloft.net>, dipankar@in.ibm.com,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, den@openvz.org, mingo@elte.hu,
        mszeredi@suse.cz, cmm@us.ibm.com, npiggin@kernel.dk, xemul@openvz.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20100930202612.GM14068@sgi.com>
References: <20100923121704.GR14064@sgi.com>
	 <1285246384.362.3.camel@edumazet-laptop> <20100923141037.GA3811@in.ibm.com>
	 <20100927.153639.212415479.davem@davemloft.net>
	 <1285645611.10438.27.camel@edumazet-laptop>
	 <20100930202612.GM14068@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 22:45:45 +0200
Message-ID: <1285879545.2705.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 15:26 -0500, Robin Holt a écrit :
> On Tue, Sep 28, 2010 at 05:46:51AM +0200, Eric Dumazet wrote:
> > Le lundi 27 septembre 2010 à 15:36 -0700, David Miller a écrit :
> ...
> 
> > Fix is to let /proc/sys/fs/file-nr & /proc/sys/fs/file-max use long
> > integers, and change af_unix to use an atomic_long_t instead of
> > atomic_t.
> > 
> > get_max_files() is changed to return an unsigned long.
> 
> I _THINK_ we actually want get_max_files to return a long and have
> the files_stat_struct definitions be longs.  If we do not have it that
> way, we could theoretically open enough files on a single cpu to make
> get_nr_files return a negative without overflowing max_files.  That,
> of course, would require an insane amount of memory, but I think it is
> technically more correct.
> 

Number of opened file is technically a positive (or null) value, I have
no idea why you want it being signed.

> 
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -1352,16 +1352,16 @@ static struct ctl_table fs_table[] = {
> >  	{
> >  		.procname	= "file-nr",
> >  		.data		= &files_stat,
> > -		.maxlen		= 3*sizeof(int),
> > +		.maxlen		= sizeof(files_stat),
> >  		.mode		= 0444,
> > -		.proc_handler	= proc_nr_files,
> > +		.proc_handler	= proc_doulongvec_minmax,
> 
> With this change, don't we lose the current nr_files value?  I think
> you need proc_nr_files to stay as it was.  If you disagree, we should
> probably eliminate the definitions for proc_nr_files as I don't believe
> they are used anywhere else.
> 

I have no idea why you think I changed something. I only made the value
use 64bit on 64bit arches, so that we are not anymore limited to 2^31
files.



