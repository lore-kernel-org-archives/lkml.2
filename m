Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0C3Gbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:31:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64292 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0C3Gbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BJP2+BYXEo8Jos/hrc5H6keV62FpWE1xePu2ysYzp4LZZ5jAYzTdC4yp6qxq6kYlaz
         xXK00G0OlAzAk/cVLoAJiSHHM5J8qZ9mCOpks7jtO9+/rhwt8WUUSPMrzfCormKM4URs
         JGPruUvvS9hJXLaXzG/bnfrX9JbK5iiDusr08=
MIME-Version: 1.0
In-Reply-To: <1269930015-863-6-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
	 <1269930015-863-6-git-send-regression-fweisbec@gmail.com>
Date: Tue, 30 Mar 2010 09:31:33 +0300
Message-ID: <b6fcc0a1003292331n4fd0ce03v6d75a1a20ce14f0f@mail.gmail.com>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:

> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@ -1331,12 +1331,22 @@ static unsigned int cache_poll_procfs(struct file *filp, poll_table *wait)
>        return cache_poll(filp, wait, cd);
>  }
>
> -static int cache_ioctl_procfs(struct inode *inode, struct file *filp,
> -                             unsigned int cmd, unsigned long arg)
> +static long cache_ioctl_procfs(struct file *filp,
> +                              unsigned int cmd, unsigned long arg)
>  {
> -       struct cache_detail *cd = PDE(inode)->data;
> +       long ret;
> +       struct cache_detail *cd;
> +       struct inode *inode = filp->f_path.dentry->d_inode;
>
> -       return cache_ioctl(inode, filp, cmd, arg, cd);
> +       /* Pushed down from procfs ioctl handler */
> +       lock_kernel();
> +
> +       cd = PDE(inode)->data;

->data is not under BKL at all.

> +       ret = cache_ioctl(inode, filp, cmd, arg, cd);
