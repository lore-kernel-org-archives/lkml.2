Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0GYFp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 01:45:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43490 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0GYFp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 01:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r1BQsEbGUuynrwVr7acrqJtvbucwVaQKxktUL1RZXp+4p6kpA5skPy3S2tufQ5HdPJ
         iP/kkh0ZcFgED3LDtZugEYP5AkkbOQbBXGzvzCCfiQpuutI2se4UBLEEDu1l3s3wOePT
         3A1RJ5bx0UwdTSoCfqW/lRWBK4+EIlDbSmV0k=
Date: Sun, 25 Jul 2010 09:45:11 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: check capabilities in open()
Message-ID: <20100725054511.GB9018@albatros>
References: <20100724160701.GA4907@albatros>
 <20100724182355.GA9134@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724182355.GA9134@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 19:23 +0100, Al Viro wrote:
> On Sat, Jul 24, 2010 at 08:07:01PM +0400, Vasiliy Kulikov wrote:
> > Hi,
> > 
> > I've found that some drivers check process capabilities via capable() in
> > open(), not in ioctl()/write()/etc.
> > 
> > I cannot find answer in POSIX, but IMO process expects that file
> > descriptors of priviledged user and file descriptors of the same
> > file/device are the same in priviledge aspect. Driver should deny/allow
> > open() and deny/allow ioctl() based on user priviledges. The path how
> > the process gained this fd doesn't matter.
> > 
> > So I think these 2 examples should be equal:
> > 
> > 1) root process opened the file and then dropped its priviledges
> > 
> > 2) nonroot process opened the file
> 
> They most certainly should _not_.  Consider the following mechanism:
> 	process A authenticates itself to process B
> 	B is convinced to open a file that wouldn't be readable for A.
> 	B passes descriptor to A.
> 	A reads from it.
> You are breaking that.

No, I mean that if driver allowed process to open the file, gained fd
should be the same. I say that if process A has _opened_ file, its fd should be the same
that convinced from B.

In your example and current implementation process A allowed to open
file, but it is not the same if B opens file and passes fd to A.


Example from drivers/char/apm-emulation.c:

static int apm_open(struct inode * inode, struct file * filp)
{
    ...
    as->suser = capable(CAP_SYS_ADMIN);
    ...
}

apm_ioctl(struct file *filp, u_int cmd, u_long arg)
{
    ...
	if (!as->suser || !as->writer)
		return -EPERM;
    ...
}

Root can open apm file (as->suser would be true), pass it to
unpriviledged process and it would be able to suspend the system
(as->suser would be still true).

Unpriviledged process can also open apm file (as->suser would be 0), but
would not be able to suspend the system.

Also patalogical case :) unpriviledged process passes fd to root process
and root process cannot suspend the system.




Btw, the list of such drivers is much smaller, some of them just return
-EPERM and open() fails, it is OK. I'll resend more precise list soon.
