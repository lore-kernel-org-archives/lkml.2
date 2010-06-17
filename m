Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab0FQWJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:09:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55784 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0FQWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X6eT70RRa5HueBQNQzEMVnaFCw/F0MqJxDBLZpJXI9By6uSQjxVBxHACWW8Aj9U37u
         zo2GFXDewZQyFGdCIq5dgivUETS+YBxGZdlpxbJaKgxvfBbEsj4KVhVan6crSbjLcfFj
         MtU1ZfGJt/ctcMKPzHXaO0401rbOE868zXEsY=
Date: Fri, 18 Jun 2010 00:09:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Message-ID: <20100617220926.GC5345@nowhere>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201006172140.46203.arnd@arndb.de> <AANLkTinGJJJ4vWvDGCqSPpMnYyE5WKALVmBUAJ_72y-G@mail.gmail.com> <201006172348.08180.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006172348.08180.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 11:48:07PM +0200, Arnd Bergmann wrote:
> On Thursday 17 June 2010 22:15:32 Tony Luck wrote:
> > Call Trace:
> >  [<a000000100015990>] show_stack+0x50/0xa0
> >  [<a00000010090f1f0>] dump_stack+0x30/0x50
> >  [<a00000010008e280>] warn_slowpath_common+0xc0/0x120
> >  [<a00000010008e320>] warn_slowpath_null+0x40/0x60
> >  [<a00000010053d910>] tty_release+0x90/0xbc0
> >  [<a0000001001ab200>] __fput+0x260/0x420
> >  [<a0000001001ab400>] fput+0x40/0x60
> >  [<a00000010053b3b0>] tty_vhangup_locked+0x870/0x8a0
> >  [<a00000010054f3f0>] pty_close+0x350/0x3a0
> >  [<a00000010053ddd0>] tty_release+0x550/0xbc0
> >  [<a0000001001ab200>] __fput+0x260/0x420
> >  [<a0000001001ab400>] fput+0x40/0x60
> >  [<a0000001001a4dc0>] filp_close+0x120/0x140
> >  [<a0000001001a4f90>] sys_close+0x1b0/0x2c0
> >  [<a00000010000b940>] ia64_ret_from_syscall+0x0/0x20
> > 
> 
> Ah, this sucks. I think Alan actually tried to warn me of this problem and I
> thought I had it right, but obviously I got it wrong in the end. I really
> should have run into this during testing though, not sure why I didn't.
> 
> The good news is that the warning message is harmless for the normal
> case where CONFIG_TTY_MUTEX remains disabled, it's only debugging code
> to warn that there is a bug once the option gets turned on.
> 
> Unfortunately however the only fix I see is to push the BTM further down
> into the hangup function, which makes the pty code slightly more complex
> and which I'm sure is an equivalent transformation.
> 
> I'll try doing some more tests with this patch and CONFIG_TTY_LOCK disabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/char/pty.c b/drivers/char/pty.c
> index c9af9ff..0902127 100644
> --- a/drivers/char/pty.c
> +++ b/drivers/char/pty.c
> @@ -62,7 +62,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>  		if (tty->driver == ptm_driver)
>  			devpts_pty_kill(tty->link);
>  #endif
> -		tty_vhangup_locked(tty->link);
> +		unlock_kernel();
> +		tty_vhangup(tty->link);
> +		lock_kernel();



Don't you mean tty_unlock / tty_lock there?

