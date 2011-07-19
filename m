Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GSQc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:32:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:10737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1GSQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,229,1309762800"; 
   d="scan'208";a="29447294"
Date: Tue, 19 Jul 2011 17:34:01 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] TTY: serial, remove tasklet for tty_wakeup
Message-ID: <20110719173401.131e220f@bob.linux.org.uk>
In-Reply-To: <1310646915-3032-3-git-send-email-jslaby@suse.cz>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
	<1310646915-3032-3-git-send-email-jslaby@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 14:35:12 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> tty_wakeup can be called from any context. So there is no need to have
> an extra tasklet for calling that. Hence save some space and remove
> the tasklet completely.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/tty/serial/serial_core.c |   20 +-------------------
>  include/linux/serial_core.h      |    1 -
>  2 files changed, 1 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c
> b/drivers/tty/serial/serial_core.c index 2cbf1bd..4786232 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -72,7 +72,7 @@ void uart_write_wakeup(struct uart_port *port)
>  	 * closed.  No cookie for you.
>  	 */
>  	BUG_ON(!state);
> -	tasklet_schedule(&state->tlet);
> +	tty_wakeup(state->port.tty);

Probably worth noting that this is only safe if the uart locks are held
and because of the current lock/ref drop combinations in the
serial_core code otherwise it can race with hangup...
