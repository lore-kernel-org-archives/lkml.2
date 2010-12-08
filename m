Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0LHP65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:58:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab0LHP64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:58:56 -0500
Date: Wed, 8 Dec 2010 07:50:43 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>
Subject: Re: [043/127] TTY: ldisc, fix open flag handling
Message-ID: <20101208155043.GA10121@suse.de>
References: <20101208004428.612566004@clark.site>
 <4CFF24AE.1030104@suse.cz>
 <20101208150209.GA5144@suse.de>
 <4CFF9FA6.70708@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF9FA6.70708@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 04:09:26PM +0100, Jiri Slaby wrote:
> On 12/08/2010 04:02 PM, Greg KH wrote:
> > On Wed, Dec 08, 2010 at 07:24:46AM +0100, Jiri Slaby wrote:
> >> On 12/08/2010 01:43 AM, Greg KH wrote:
> >>> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> >>>
> >>> ------------------
> >>>
> >>> From: Jiri Slaby <jslaby@suse.cz>
> >>>
> >>> commit 7f90cfc505d613f4faf096e0d84ffe99208057d9 upstream.
> >>>
> >>> When a concrete ldisc open fails in tty_ldisc_open, we forget to clear
> >>> TTY_LDISC_OPEN. This causes a false warning on the next ldisc open:
> >>> WARNING: at drivers/char/tty_ldisc.c:445 tty_ldisc_open+0x26/0x38()
> >>> Hardware name: System Product Name
> >>> Modules linked in: ...
> >>> Pid: 5251, comm: a.out Tainted: G        W  2.6.32-5-686 #1
> >>> Call Trace:
> >>>  [<c1030321>] ? warn_slowpath_common+0x5e/0x8a
> >>>  [<c1030357>] ? warn_slowpath_null+0xa/0xc
> >>>  [<c119311c>] ? tty_ldisc_open+0x26/0x38
> >>>  [<c11936c5>] ? tty_set_ldisc+0x218/0x304
> >>> ...
> >>>
> >>> So clear the bit when failing...
> >>>
> >>> Introduced in c65c9bc3efa (tty: rewrite the ldisc locking) back in
> >>> 2.6.31-rc1.
> >>>
> >>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >>> Cc: Alan Cox <alan@linux.intel.com>
> >>> Reported-by: Sergey Lapin <slapin@ossfans.org>
> >>> Tested-by: Sergey Lapin <slapin@ossfans.org>
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >>>
> >>> ---
> >>>  drivers/char/tty_ldisc.c |    9 +++++++--
> >>>  1 file changed, 7 insertions(+), 2 deletions(-)
> >>>
> >>> --- a/drivers/char/tty_ldisc.c
> >>> +++ b/drivers/char/tty_ldisc.c
> >>> @@ -444,9 +444,14 @@ static void tty_set_termios_ldisc(struct
> >>>  
> >>>  static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
> >>>  {
> >>> +	int ret;
> >>> +
> >>>  	WARN_ON(test_and_set_bit(TTY_LDISC_OPEN, &tty->flags));
> >>> -	if (ld->ops->open)
> >>> -		return ld->ops->open(tty);
> >>> +	if (ld->ops->open) {
> >>> +		ret = ld->ops->open(tty);
> >>> +		if (ret)
> >>> +			clear_bit(TTY_LDISC_OPEN, &tty->flags);
> >>> +	}
> >>>  	return 0;
> >>
> >> Whoops, this should write return ret; (with int ret = 0;)
> >>
> >> Do you want me to send the patch against rebased on .32?
> > 
> > No, send it based on Linus's tree as it's wrong there, right?  Then it
> > will move through to the stable kernels.
> 
> Nope, in 2.6.36 and newer it looks differently, only the .32 backport is
> broken.

Ick, ok, sorry about that.  Yes, can you just send me a tiny patch that
I can merge with the .32 patch to resolve this?

thanks,

greg k-h
