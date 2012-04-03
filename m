Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2DCLri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:47:38 -0400
Received: from ra.se.axis.com ([195.60.68.13]:34648 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab2DCLra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:47:30 -0400
Date: Tue, 3 Apr 2012 13:47:28 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jirislaby@gmail.com" <jirislaby@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 01/69] TTY: crisv10, remove unused tmp_buf
Message-ID: <20120403114728.GS21889@axis.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz> <1333367693-3244-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333367693-3244-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 01:53:45PM +0200, Jiri Slaby wrote:
> This used to be a helper buffer for generic_serial. generic_serial is
> gone, tmp_buf shall be removed.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mikael Starvik <starvik@axis.com>

Looks good!

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> ---
>  drivers/tty/serial/crisv10.c |   27 +--------------------------
>  1 file changed, 1 insertion(+), 26 deletions(-)
> 
> diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
> index 5b07c0c..004ee2e 100644
> --- a/drivers/tty/serial/crisv10.c
> +++ b/drivers/tty/serial/crisv10.c
> @@ -952,19 +952,6 @@ static const struct control_pins e100_modem_pins[NR_PORTS] =
>  /* Input */
>  #define E100_DSR_GET(info) ((*e100_modem_pins[(info)->line].dsr_port) & e100_modem_pins[(info)->line].dsr_mask)
>  
> -
> -/*
> - * tmp_buf is used as a temporary buffer by serial_write.  We need to
> - * lock it in case the memcpy_fromfs blocks while swapping in a page,
> - * and some other program tries to do a serial write at the same time.
> - * Since the lock will only come under contention when the system is
> - * swapping and available memory is low, it makes sense to share one
> - * buffer across all the serial ports, since it significantly saves
> - * memory if large numbers of serial ports are open.
> - */
> -static unsigned char *tmp_buf;
> -static DEFINE_MUTEX(tmp_buf_mutex);
> -
>  /* Calculate the chartime depending on baudrate, numbor of bits etc. */
>  static void update_char_time(struct e100_serial * info)
>  {
> @@ -3150,7 +3137,7 @@ static int rs_raw_write(struct tty_struct *tty,
>  
>  	/* first some sanity checks */
>  
> -	if (!tty || !info->xmit.buf || !tmp_buf)
> +	if (!tty || !info->xmit.buf)
>  		return 0;
>  
>  #ifdef SERIAL_DEBUG_DATA
> @@ -4106,7 +4093,6 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  {
>  	struct e100_serial	*info;
>  	int 			retval;
> -	unsigned long           page;
>  	int                     allocated_resources = 0;
>  
>  	info = rs_table + tty->index;
> @@ -4124,17 +4110,6 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  
>  	tty->low_latency = !!(info->flags & ASYNC_LOW_LATENCY);
>  
> -	if (!tmp_buf) {
> -		page = get_zeroed_page(GFP_KERNEL);
> -		if (!page) {
> -			return -ENOMEM;
> -		}
> -		if (tmp_buf)
> -			free_page(page);
> -		else
> -			tmp_buf = (unsigned char *) page;
> -	}
> -
>  	/*
>  	 * If the port is in the middle of closing, bail out now
>  	 */
> -- 
> 1.7.9.2
> 
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
