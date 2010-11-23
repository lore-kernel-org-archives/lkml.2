Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0KWRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:16:58 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:42256
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab0KWRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:16:57 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4CEBF668.2080708@freescale.com>
Date: Tue, 23 Nov 2010 11:14:16 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101118163321.GA2723@suse.de>	<4CE5562B.8080604@freescale.com>	<20101118165136.GA3103@suse.de>	<4CE55ACB.80207@freescale.com>	<20101118171856.GA4283@suse.de>	<4CE5647F.5000203@freescale.com>	<20101118175832.GA4931@suse.de>	<4CE58005.7040308@freescale.com>	<20101118200230.GA25715@suse.de>	<4CE58736.4090703@freescale.com>	<20101118201035.GA26287@suse.de>	<4CE58FE5.3010502@freescale.com>	<20101118205647.677404ec@lxorguk.ukuu.org.uk>	<4CEA9B00.1000804@freescale.com> <20101123135621.5d100e81@lxorguk.ukuu.org.uk>
In-Reply-To: <20101123135621.5d100e81@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2010 17:15:26.0857 (UTC) FILETIME=[05968F90:01CB8B32]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Your console driver provides a device method (see kernel/printk.c).
> When /dev/console is opened the kernel iterates the console list looking
> for one with ->device and then calls that method. On success it expects
> the passed int * to contain the minor number to use.

Are you talking about this:

static struct tty_driver *ehv_bc_console_device(struct console *co, int *index)
{
	*index = co->index;

	return ehv_bc_driver;
}

I never really understood this function, but almost everyone does the same
thing, and it seems to work for me.  Looking at console_device(), it appears
that all of the xxx_console_device functions are called in order until one of
them returns non-NULL.

How is this related to add_preferred_console()?  When I call this function, I
also specify the same index and the name from the struct console device:

static struct console ehv_bc_console = {
	.name		= "ttyEHV",
	.write		= ehv_bc_console_write,
	.device		= ehv_bc_console_device,
	.flags		= CON_PRINTBUFFER | CON_ENABLED,
};

add_preferred_console(ehv_bc_console.name, ehv_bc_console.index, NULL);
register_console(&ehv_bc_console);

> I suspect in your case you probably want to attach the primary byte
> channel to minor 0 in the driver (and reserve it for that), or some
> similar rule.

Yes, that's a good idea.  It does simplify things a lot.

-- 
Timur Tabi
Linux kernel developer at Freescale

