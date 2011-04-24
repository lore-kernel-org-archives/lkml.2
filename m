Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1DXBKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:10:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21844 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab1DXBKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:10:47 -0400
Date: Sun, 24 Apr 2011 03:04:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
In-Reply-To: <1303515150-1718-5-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1104240256160.28014@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-5-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> The n_tracerouter and n_tracesink line discpline drivers use the
> Linux tty line discpline framework to route trace data coming
> from a tty port (say UART for example) to the trace sink line
> discipline driver and to another tty port(say USB).  Those
> these two line discipline drivers can be used together,
> independently from pti.c, they are part of the original
> implementation solution of the MIPI P1149.7, compact JTAG, PTI
> solution for Intel mobile platforms starting with the
> Medfield platform.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

A few minor comments can be found below.


...
> +static int n_tracesink_open(struct tty_struct *tty)
> +{
> +	int retval = -EEXIST;
> +
> +	mutex_lock(&writelock);
> +	if (this_tty == NULL) {
> +
> +		this_tty = tty_kref_get(tty);
> +

pointless blank line. I'd suggest removing it.


...
> +		if (this_tty == NULL)
> +			retval = -EFAULT;
> +		else {

If one branch requires braces, both should have them

        } else {


...
> +static void n_tracesink_close(struct tty_struct *tty)
> +{
> +
> +	mutex_lock(&writelock);
> +	tty_driver_flush_buffer(tty);
> +	tty_kref_put(this_tty);
> +	this_tty = NULL;
> +	tty->disc_data = NULL;
> +	mutex_unlock(&writelock);
> +
> +}

pointless blank line at end of function. Remove it.


> +static int __init n_tracesink_init(void)
> +{
> +	int retval;
> +
> +	/* Note N_TRACESINK is defined in linux/tty.h */
> +	retval = tty_register_ldisc(N_TRACESINK, &tty_n_tracesink);
> +
> +	if (retval < 0)
> +		pr_err("%s: Registration failed: %d\n", __func__, retval);
> +
> +	return retval;
> +}

How about shortening is a bit - like this?

static int __init n_tracesink_init(void)
{
     /* Note N_TRACESINK is defined in linux/tty.h */
     int retval = tty_register_ldisc(N_TRACESINK, &tty_n_tracesink);
     
     if (retval < 0)
             pr_err("%s: Registration failed: %d\n", __func__, retval);
             
     return retval;
}


...
> +static void __exit n_tracesink_exit(void)
> +{
> +	int retval;
> +
> +	retval = tty_unregister_ldisc(N_TRACESINK);
> +
> +	if (retval < 0)
> +		pr_err("%s: Unregistration failed: %d\n", __func__,  retval);
> +}

How about:

static void __exit n_tracesink_exit(void)
{
     int retval = tty_unregister_ldisc(N_TRACESINK);
     
     if (retval < 0)
             pr_err("%s: Unregistration failed: %d\n", __func__,  retval);
}


...
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -50,6 +50,8 @@
>  #define N_CAIF		20      /* CAIF protocol for talking to modems */
>  #define N_GSM0710	21	/* GSM 0710 Mux */
>  #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
> +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
>  

Lining up those defines would be nice :)


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

