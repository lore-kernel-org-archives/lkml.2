Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0C2CoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:44:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:11185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab0C2CoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:44:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,325,1267430400"; 
   d="scan'208";a="504437658"
Date: Mon, 29 Mar 2010 10:48:38 +0800
From: Feng Tang <feng.tang@intel.com>
To: Christian Pellegrin <chripell@fsfe.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH v1 3/4] max3100: adds console support for MAX3100
Message-ID: <20100329104838.49c18075@feng-i7>
In-Reply-To: <1269340170-6558-1-git-send-email-chripell@fsfe.org>
References: <1269340105-6503-1-git-send-email-chripell@fsfe.org>
	<1269340170-6558-1-git-send-email-chripell@fsfe.org>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I modified the code a little and run it on our HW platform, it really show
some sigh of life: it can boots to console (the print format is not so good),
I can input command and it execute correctly, but very slow, I type 3
characters and it takes about 2 seconds to echo back on screen and start the
execution, and after about 1 minute, the console hang there and input stopped
to work.

I also have some comments inline.

Thanks,
Feng


On Tue, 23 Mar 2010 18:29:30 +0800
Christian Pellegrin <chripell@fsfe.org> wrote:

> This patch adds console support for the MAX3100 UART
> (console=ttyMAX0,11500). The SPI subsystem and an

115200?

>  
> +#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
> +
> +static void max3100_console_work(struct work_struct *w)
> +{
> +	struct max3100_port *s = container_of(w, struct max3100_port,
> +					      console_work);
> +	unsigned long start;
> +	u16 tx, rx;
> +
> +	while (s->console_head != s->console_tail &&
> +	       (s->console_flags & MAX3100_SUSPENDING) == 0) {
> +		start = jiffies;
> +		do {
> +			tx = MAX3100_RC;
> +			max3100_sr(s, tx, &rx);
> +		} while ((rx & MAX3100_T) == 0 &&
> +			 !time_after(jiffies, start +
> s->console_tout));
> +		tx = s->console_buf[s->console_tail];
> +		max3100_calc_parity(s, &tx);
> +		tx |= MAX3100_WD | MAX3100_RTS;

Does this imply to have to work with HW flow control? on my platform
I have to remove the RTS bit to make it work.

> +		max3100_sr(s, tx, &rx);

It doesn't handle received characters here? If the console is printing out
a bulk of message while user input some command, the command may be ignored.
Myself have met the same problem in our driver.


> +		s->console_tail = (s->console_tail + 1) %
> CONSOLE_BUF_SIZE;
> +	}
> +}
> +
> +static void max3100_console_putchar(struct uart_port *port, int ch)
> +{
> +	struct max3100_port *s = to_max3100_port(port);
> +	int next = (s->console_head + 1) % CONSOLE_BUF_SIZE;
> +
> +	if (next != s->console_tail) {
> +		s->console_buf[next] = ch;
> +		s->console_head = next;
> +	}

Also I saw max3100_sr() uses cpu_to_be16() and be16_to_cpu(), is it really
necessary, our platform is little-endian(x86), and I have to disable them
to make the code work. Is your test platform big-endian?

