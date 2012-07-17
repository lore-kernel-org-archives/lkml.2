Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2GQR2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:28:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34527 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2GQR15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:27:57 -0400
Date: Tue, 17 Jul 2012 22:57:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Jovi Zhang <bookjovi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: uprobe: checking probe event include directory
Message-ID: <20120717172736.GA6854@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
 <20120717105936.GC28744@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120717105936.GC28744@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071717-7182-0000-0000-000002017980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker <fweisbec@gmail.com> [2012-07-17 12:59:39]:

> On Tue, Jul 17, 2012 at 06:12:28PM +0800, Jovi Zhang wrote:
> > From 16ed13ee9098ae01705e8456005d1ad6d9909128 Mon Sep 17 00:00:00 2001
> > From: Jovi Zhang <bookjovi@gmail.com>
> > Date: Wed, 18 Jul 2012 01:16:23 +0800
> > Subject: [PATCH] uprobe: checking probe event include directory
> > 
> > Currently below command run successful:
> > $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

good catch.

> > 
> > this don't make sense, because /bin is a directory,
> > so make this checking earily, not report error untill probe enable.
> > 
> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> 
> Adding Srikar in Cc.
> 
> > ---
> >  kernel/trace/trace_uprobe.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> > index 85158fa..cf382de 100644
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -259,6 +259,11 @@ static int create_trace_uprobe(int argc, char **argv)
> >  		goto fail_address_parse;
> > 
> >  	inode = igrab(path.dentry->d_inode);
> > +	 if (S_ISDIR(inode->i_mode)) {

How about checking for regular files but not directory.
i.e it should avoid tracing special files 

Something like: 

	if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {

> > +		ret = -EINVAL;
> > +		pr_info("probe file cannot be directory.\n");

we could drop the pr_info line here, since we would any print we
failed to parse the address.

Probably you could change the last pr_info from 

pr_info("Failed to parse address.\n");

to 

pr_info("Failed to parse address or file.\n");


-- 
Thanks and Regards
Srikar
> > +		goto fail_address_parse;
> > +	}
> > 
> >  	argc -= 2;
> >  	argv += 2;
> > -- 
> > 1.7.9.7
> 

