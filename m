Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab0LNUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:16:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759573Ab0LNUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:16:57 -0500
Date: Tue, 14 Dec 2010 12:16:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Dan Carpenter <error27@gmail.com>, Brian Rogers <brian@xyzw.org>,
        Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org,
        Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: [patch] delayacct: fix iotop on x86_64
Message-Id: <20101214121641.7c337509.akpm@linux-foundation.org>
In-Reply-To: <20101214080239.GC14178@balbir.in.ibm.com>
References: <20101213113745.GE1620@bicker>
	<20101213125709.GB14178@balbir.in.ibm.com>
	<4D0639B2.4060903@suse.com>
	<4D068869.7040305@xyzw.org>
	<20101213212253.GI1620@bicker>
	<20101214070243.GJ1620@bicker>
	<20101214080239.GC14178@balbir.in.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 13:32:39 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Dan Carpenter <error27@gmail.com> [2010-12-14 10:02:43]:
> 
> > We changed how the taskstats was exported to user space in:
> > 85893120699 "delayacct: align to 8 byte boundary on 64-bit systems"
> > This was important because it fixes a run time warning on IA64.  In
> > theory it shouldn't have broken anything, if you just assume that user
> > space programmers don't smoke crack all day long.
> > 
> > But actually it breaks iotop on x86_64.
> > 
> > Reported-by: Brian Rogers <brian@xyzw.org>
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index c8231fb..a0758de 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -358,7 +358,19 @@ static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
> >  	 * This causes lots of runtime warnings on systems requiring 8 byte
> >  	 * alignment */
> >  	u32 pids[2] = { pid, 0 };
> > -	int pid_size = ALIGN(sizeof(pid), sizeof(long));
> > +	int pid_size;
> > +
> > +	/*
> > +	 * IA64 can't be aligned on a 4 byte boundary.  But iotop on x86_64
> > +	 * depends on the current struct layout.  The next version of iotop
> > +	 * will fix this so maybe we can move everything to the new code in
> > +	 * a couple years.
> > +	 */
> > +#if defined(CONFIG_IA64)
> > +	pid_size = ALIGN(sizeof(pid), sizeof(long));
> > +#else
> > +	pid_size = sizeof(u32);
> > +#endif
> 
> I would rather abstract this better

Well.  Abstracting something tends to make it permanent.  When you have
an ugly, special-case temporary hack, there is merit to having it
sitting there in the middle of the code staring you in the face.  It's
very explicit and we won't forget about it.

> and I'd be apprehensive about the
> fix if iotop was at fault to begin with, I would rather fix iotop.
> IOW, are we fixing what iotop got wrong? Isn't it easier to backport
> the correct behaviour in iotop. I understand we broke the ABI, but
> user space can still live.

Nah, let's not knowingly break a userspace app.


This is a versioned interface, is it not?  How is that supposed
to work?  Should we have upped the version number when making this
change?
