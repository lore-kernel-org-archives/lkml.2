Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab1CaKQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:16:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:34335 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017Ab1CaKQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:16:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,274,1299484800"; 
   d="scan'208";a="621553910"
Date: Thu, 31 Mar 2011 10:58:11 +0100
From: Alan Cox <alan@linux.intel.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] vt: avoid BUG_ON in con_shutdown when con_open returns
 with error
Message-ID: <20110331105811.5d989e86@bob.linux.org.uk>
In-Reply-To: <1301524178-7925-1-git-send-email-herton.krzesinski@canonical.com>
References: <1301524178-7925-1-git-send-email-herton.krzesinski@canonical.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O
> +static inline void con_ops_set_shutdown(void);
>  static int con_open(struct tty_struct *, struct file *);
>  static void vc_init(struct vc_data *vc, unsigned int rows,
>  		    unsigned int cols, int do_clear);
> @@ -2806,6 +2807,14 @@ static int con_open(struct tty_struct *tty,
> struct file *filp) tty->driver_data = vc;
>  			vc->port.tty = tty;
>  
> +			/* We must set shutdown only here, otherwise
> +			 * we returned from con_open with error,
> which
> +			 * will make tty core call tty_release, that
> +			 * in its call path makes con_shutdown being
> +			 * called without tty->driver_data being set,
> +			 * triggering the BUG_ON there */
> +			con_ops_set_shutdown();

No we cannot go around patching the tty_operations - they are not
locked for one.

Probably this is one case where making con_shutdown() check is the
right answer.
