Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2KQBcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 20:32:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49752 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753651Ab2KQBcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 20:32:22 -0500
Message-ID: <1353115941.6139.10.camel@joe-AO722>
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check()
 in serqt_usb2.c
From: Joe Perches <joe@perches.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 17:32:21 -0800
In-Reply-To: <1353097162-4479-1-git-send-email-yamanetoshi@gmail.com>
References: <1353097162-4479-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-17 at 05:19 +0900, YAMANE Toshiaki wrote:
> Modify qt_status_change_check() and delete qt_status_change().
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/serqt_usb2/serqt_usb2.c |   53 +++++++++++++------------------
>  1 file changed, 22 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
[]
> @@ -334,11 +307,29 @@ static void qt_status_change_check(struct tty_struct *tty,
>  			flag = 0;
>  			switch (data[i + 2]) {
>  			case 0x00:
> +				if (i > (RxCount - 4)) {
> +					dev_dbg(&port->dev,
> +						"Illegal escape seuences in received data\n");

trivia: seuences/sequence

> +					break;
> +				}
> +
> +				ProcessLineStatus(qt_port, data[i + 3]);
> +
> +				i += 3;

you could move the i += 3 before the ProcessLineStatus
and use data[i]

> +				flag = 1;
> +				break;
> +
>  			case 0x01:
> -				flag = qt_status_change((RxCount - 4), data, i,
> -							qt_port, port);
> -				if (flag == 1)
> -					i += 3;
> +				if (i > (RxCount - 4)) {
> +					dev_dbg(&port->dev,
> +						"Illegal escape seuences in received data\n");

typo here too

> +					break;
> +				}
> +
> +				ProcessModemStatus(qt_port, data[i + 3]);
> +
> +				i += 3;

same i += 3

> +				flag = 1;
>  				break;
>  
>  			case 0xff:

What about something like:

			case 0x0:
			case 0x1:
				if (i > (RxCount - 4)) {
					dev_dbg(&port->dev,
						"Illegal escape sequence in received data\n");
					break;
				}

				if (data[i + 2] == 0x0)
					ProcessLineStatus(qt_port, data[i + 3]);
				else
					ProcessModemStatus(qt_port, data[i + 3]);

				i += 3;
				flag = 1;
  				break;



