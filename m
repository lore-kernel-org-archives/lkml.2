Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0C3HC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:02:57 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49819 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0C3HC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TbaH4OnPDG2VieKSFE3XIv9NP+4obGn/0Aw7OpKTkNn5x4HZmyp9tFwL/bd9mm/nsg
         4HbeDUxQgx7dgGsAjangC3KUIeqgqVppXNLyswTaCR/QmmhlIewFA0Su64IurKBM9zT4
         eyqbUxhMxwpv9JZUnK3+ZOsP76EMMTvjAb4To=
Date: Tue, 30 Mar 2010 09:02:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
Message-ID: <20100330070258.GB22419@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-6-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292331n4fd0ce03v6d75a1a20ce14f0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6fcc0a1003292331n4fd0ce03v6d75a1a20ce14f0f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:31:33AM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > --- a/net/sunrpc/cache.c
> > +++ b/net/sunrpc/cache.c
> > @@ -1331,12 +1331,22 @@ static unsigned int cache_poll_procfs(struct file *filp, poll_table *wait)
> >        return cache_poll(filp, wait, cd);
> >  }
> >
> > -static int cache_ioctl_procfs(struct inode *inode, struct file *filp,
> > -                             unsigned int cmd, unsigned long arg)
> > +static long cache_ioctl_procfs(struct file *filp,
> > +                              unsigned int cmd, unsigned long arg)
> >  {
> > -       struct cache_detail *cd = PDE(inode)->data;
> > +       long ret;
> > +       struct cache_detail *cd;
> > +       struct inode *inode = filp->f_path.dentry->d_inode;
> >
> > -       return cache_ioctl(inode, filp, cmd, arg, cd);
> > +       /* Pushed down from procfs ioctl handler */
> > +       lock_kernel();
> > +
> > +       cd = PDE(inode)->data;
> 
> ->data is not under BKL at all.



Yeah. It's a very rough pushdown, I haven't looked at any bit to figure
out what could need to be protected or not. I even did not know what does
PDE. So I kept a plain bkl path. I just thought any further thinking should
be done in a further patch.

But I can move the bkl after in this same patch if you prefer.

Thanks.

