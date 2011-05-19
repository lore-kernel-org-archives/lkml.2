Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab1ESPP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:15:58 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19304
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933014Ab1ESPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:15:57 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD533DE.1020705@freescale.com>
Date: Thu, 19 May 2011 10:14:38 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com>	<1305813272-31826-7-git-send-email-timur@freescale.com> <20110519153358.5876f310@lxorguk.ukuu.org.uk>
In-Reply-To: <20110519153358.5876f310@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> ttys = tty_port_tty_get(&bc->port);
> stuff
> if (ttys != NULL)
> 	tty stuff
> 	tty_kref_put(ttys);

Under what circumstances can ttys be NULL?  I currently only use this code in
the RX and TX interrupt handlers, which are both enabled in the
tty_port_operations.activate() function.

Is this right for the TX handler:

static irqreturn_t ehv_bc_tty_tx_isr(int irq, void *data)
{
	struct ehv_bc_data *bc = data;
	struct tty_struct *ttys = tty_port_tty_get(&bc->port);

	ehv_bc_tx_dequeue(bc);
	if (ttys) {
		tty_wakeup(ttys);
		tty_kref_put(ttys);
	}

	return IRQ_HANDLED;
}

I just want to make sure that testing for NULL is really necessary in my
interrupt handlers.

>> > +		len = min_t(unsigned int,
>> > +			    CIRC_CNT_TO_END(bc->head, bc->tail, BUF_SIZE),
>> > +			    EV_BYTE_CHANNEL_MAX_BYTES);
> The kfifo API is probably faster and cleaner. Much of tty still uses
> CIRC_* because they predate the new APIs.

Ok, I'll change it.

> You really also need a hangup method so vhangup() does the right thing
> and you can securely do logins etc and sessions on your console. As
> you've got no hardware entangled in this and you already use tty_port
> helpers the hangup helper will do the work for you.

Ok.

> 
> I guess the only other thing to consider is whether you want to implement
> a SYSRQ interface on your console ?

I don't think byte channels can support SYSRQ, but I'll look into it.

-- 
Timur Tabi
Linux kernel developer at Freescale

