Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0HVTEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:04:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47743 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0HVTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=aa6DPPYuWswJO8XEB8lTopEKiIYV79U5SgQ4Oa0Ge5uPBKsPSmET2o8kqWbVh5KiMN
         d5X+a5Zca/buXlCnAbR86we35ArWuelLOo8fblCk3fO6NCGuvFj3ggdaKNiwyQ5QwLyp
         e8Ebo+jJt9YqZX/OTSfREZrPl0ULJVWr7hepg=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Michal Simek <monstr@monstr.eu>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] serial: Add CONSOLE_POLL support for uartlite
References: <1282034525-19207-1-git-send-email-monstr@monstr.eu>
	<1282034525-19207-2-git-send-email-monstr@monstr.eu>
Date: Sun, 22 Aug 2010 21:04:03 +0200
In-Reply-To: <1282034525-19207-2-git-send-email-monstr@monstr.eu> (Michal
	Simek's message of "Tue, 17 Aug 2010 10:42:05 +0200")
Message-ID: <87mxsejwpo.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:

 Michal> CONSOLE_POLL support for uartlite enables
 Michal> KGDB debugging over serial line.

Please CC me on uartlite patches in the future, thanks.

 Michal> Signed-off-by: Michal Simek <monstr@monstr.eu>
 Michal> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
 Michal> ---
 Michal>  drivers/serial/uartlite.c |   26 +++++++++++++++++++++++++-
 Michal>  1 files changed, 25 insertions(+), 1 deletions(-)

 Michal> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
 Michal> index 9b03d7b..c0fae0d 100644
 Michal> --- a/drivers/serial/uartlite.c
 Michal> +++ b/drivers/serial/uartlite.c
 Michal> @@ -322,6 +322,26 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
 Michal>  	return -EINVAL;
 Michal>  }
 
 Michal> +#ifdef CONFIG_CONSOLE_POLL
 Michal> +static int ulite_get_poll_char(struct uart_port *port)
 Michal> +{
 Michal> +	while (!(ioread32be(port->membase + ULITE_STATUS)
 Michal> +						& ULITE_STATUS_RXVALID))
 Michal> +		return NO_POLL_CHAR;
 Michal> +

Using while instead of 'if' is imho pretty obscure here.

 Michal> +	return ioread32be(port->membase + ULITE_RX);
 Michal> +}
 Michal> +
 Michal> +static void ulite_put_poll_char(struct uart_port *port, unsigned char ch)
 Michal> +{
 Michal> +	while (ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_TXFULL)
 Michal> +		cpu_relax();


You could reuse ulite_console_wait_tx() like ulite_console_putchar()
does.

Otherwise it looks fine.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
