Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab0D3SCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:02:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab0D3Rtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:49:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 05/14] stallion: prune lock_kernel calls
Date: Thu, 29 Apr 2010 23:29:27 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100401155513.8882.54006.stgit@localhost.localdomain> <20100401160504.8882.37742.stgit@localhost.localdomain>
In-Reply-To: <20100401160504.8882.37742.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292329.27799.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18IDMMXnVJCvaknT7QcB/19h9dA1LpPP1K4GJD
 /rvvu0Mlzuyc4d2vSn/rx1GEAyFBiLGLw32+OC5YhazF1DDv4u
 yN7V9okaXucFnJJ81mXrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 18:05:19 Alan Cox wrote:
> @@ -4009,6 +4010,8 @@ static int stli_getbrdstats(combrd_t __user *bp)
>                 return -ENODEV;
>  
>         memset(&stli_brdstats, 0, sizeof(combrd_t));
> +
> +       mutex_lock(&portp->port.mutex);
>         stli_brdstats.brd = brdp->brdnr;
>         stli_brdstats.type = brdp->brdtype;
>         stli_brdstats.hwid = 0;
> @@ -4022,6 +4025,7 @@ static int stli_getbrdstats(combrd_t __user *bp)
>                 stli_brdstats.panels[i].hwid = brdp->panelids[i];
>                 stli_brdstats.panels[i].nrports = brdp->panels[i];
>         }
> +       mutex_unlock(&portp->port.mutex);
>  
>         if (copy_to_user(bp, &stli_brdstats, sizeof(combrd_t)))
>                 return -EFAULT;

I just tried porting my patches on top of yours (yes, it's been
some time). This one doesn't work, because there is no portp variable
in stli_getbrdstats.

On a related topic, in patch 06/14 "istallion: use bit ops for the board flags",
you have

> @@ -817,7 +817,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
>         brdp = stli_brds[brdnr];
>         if (brdp == NULL)
>                 return -ENODEV;
> -       if ((brdp->state & BST_STARTED) == 0)
> +       if (!(test_bit(BST_STARTED, &brdp->state))
>                 return -ENODEV;
>         portnr = MINOR2PORT(minordev);
>        if (portnr > brdp->nrports)

This won't work because brdp->state is an 'unsigned int' variable, while
bitops only work on 'unsigned long'.

Maybe you sent out a wrong version of this file?

	Arnd
