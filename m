Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2FGQrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:47:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40263 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab2FGQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:47:38 -0400
Date: Thu, 7 Jun 2012 12:40:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with
 kdb/kgdb
Message-ID: <20120607164034.GQ9472@phenom.dumpdata.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 09:30:06AM -0400, Ben Guthro wrote:
> Fix the polling section of the hvc driver to use the global "last_hvc"
> variable, rather than the ttys.

Could you just do:

       struct tty_struct *tty = driver->ttys[last_hvc];

as well? So how come the '0' one did not work? Is that b/c
of console=tty becoming '0' instead of hvc0? Is there a crash
involved with this? Or is that it just is listening on the
wrong console (and which one is that?)
> 
> With this change debugging a xen dom0 kernel is possible via the
> following kernel parameter:
> kgdboc=hvc0

Hm, if that is the problem then this should also be a problem on
IBM Power boxes I would think?

> 
> Signed-off-by: Ben Guthro <Benjamin.Guthro@citrix.com>
> 
> 
> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
> index 2d691eb..3750e74 100644
> --- a/drivers/tty/hvc/hvc_console.c
> +++ b/drivers/tty/hvc/hvc_console.c
> @@ -766,12 +766,10 @@ int hvc_poll_init(struct tty_driver *driver, int
> line, char *options)
> 
>  static int hvc_poll_get_char(struct tty_driver *driver, int line)
>  {
> -       struct tty_struct *tty = driver->ttys[0];
> -       struct hvc_struct *hp = tty->driver_data;
>         int n;
>         char ch;
> 
> -       n = hp->ops->get_chars(hp->vtermno, &ch, 1);
> +       n = cons_ops[last_hvc]->get_chars(vtermnos[last_hvc], &ch, 1);
> 
>         if (n == 0)
>                 return NO_POLL_CHAR;
> @@ -781,12 +779,10 @@ static int hvc_poll_get_char(struct tty_driver
> *driver, int line)
> 
>  static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
>  {
> -       struct tty_struct *tty = driver->ttys[0];
> -       struct hvc_struct *hp = tty->driver_data;
>         int n;
> 
>         do {
> -               n = hp->ops->put_chars(hp->vtermno, &ch, 1);
> +               n = cons_ops[last_hvc]->put_chars(vtermnos[last_hvc], &ch, 1);
>         } while (n <= 0);
>  }
>  #endif
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
