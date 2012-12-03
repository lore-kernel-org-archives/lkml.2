Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2LCRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:41:30 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51259 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753672Ab2LCRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:41:28 -0500
Message-ID: <1354556465.2531.169.camel@thor>
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
From: Peter Hurley <peter@hurleysoftware.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Date: Mon, 03 Dec 2012 12:41:05 -0500
In-Reply-To: <20121127180108.GA7376@linutronix.de>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
	 <20121121140426.1860d093@pyramind.ukuu.org.uk>
	 <20121127095357.GA3536@breakpoint.cc> <20121127172249.GB24592@kroah.com>
	 <20121127180108.GA7376@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 19:01 +0100, Sebastian Andrzej Siewior wrote:
> Since commit 89c8d91e31f2 ("tty: localise the lock") I see a dead lock
> in one of my dummy_hcd + g_nokia test cases. The first run one was usually
> okay, the second often resulted in a splat by lockdep and the third was
> usually a dead lock.
....
> 
> Before the path mentioned tty_ldisc_release() look like this:
> 
> |	tty_ldisc_halt(tty);
> |	tty_ldisc_flush_works(tty);
> |	tty_lock();
> 
> As it can be seen, it first flushes the workqueue and then grabs the
> tty_lock. Now we grab the lock first:
> 
> |	tty_lock_pair(tty, o_tty);
> |	tty_ldisc_halt(tty);
> |	tty_ldisc_flush_works(tty);
> 
> so lockdep's complaint seems valid.
> 
> The other user of tty_ldisc_flush_works() is tty_set_ldisc() and I tried
> to mimnic its logic:

The lock logic for tty_set_ldisc() is wrong. Despite existing code in
tty_set_ldisc() and tty_ldisc_hangup(), the ldisc_mutex does **not**
(and should not) play a role in acquiring or releasing ldisc references.
The only thing that needs to happen here is below (don't actually use
below because I just hand-edited it):

> See http://lkml.org/lkml/2012/11/21/347
> 
>  drivers/tty/tty_ldisc.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 0f2a2c5..fb76818 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -930,16 +930,21 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
>  	 */
>  
> - 	tty_lock_pair(tty, o_tty);
>  	tty_ldisc_halt(tty);
> 	tty_ldisc_flush_works(tty);

 
> +	tty_lock_pair(tty, o_tty);
>  	/* This will need doing differently if we need to lock */
>  	tty_ldisc_kill(tty);
> -
>  	if (o_tty)
>  		tty_ldisc_kill(o_tty);
>  


