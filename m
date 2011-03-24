Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1CXPsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:48:00 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:52400 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754032Ab1CXPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:47:59 -0400
Message-ID: <4D8B65F4.40306@keymile.com>
Date: Thu, 24 Mar 2011 16:40:36 +0100
From: Stefan Bigler <stefan.bigler@keymile.com>
Reply-To: stefan.bigler@keymile.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Toby Gray <toby.gray@realvnc.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com><20110317000408.GA18911@kroah.com><4D8389EC.5030704@keymile.com><20110318170801.GA2857@legolas.emea.dhcp.ti.com><20110318180657.11570887@lxorguk.ukuu.org.uk><20110321093255.GE1837@legolas.emea.dhcp.ti.com><20110322085344.GN1837@legolas.emea.dhcp.ti.com><4D8B341C.4010406@realvnc.com><20110324123708.GK14602@legolas.emea.dhcp.ti.com><4D8B3E61.1090704@realvnc.com>
	 <20110324130006.GM14602@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110324130006.GM14602@legolas.emea.dhcp.ti.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2011 15:40:36.0832 (UTC) FILETIME=[D20D6600:01CBEA39]
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this:
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 2f119e2..f0b9fb6 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c

I tried it and the console is working again.
There is still an problem on heavy load transfer from host to gadget.
I attached the patch to fix also this problem.

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 8e0f113..95d0a9c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1359,6 +1359,7 @@ static unsigned int n_tty_receive_buf(struct 
tty_struct *tty,
                 memcpy(tty->read_buf + tty->read_head, cp, i);
                 tty->read_head = (tty->read_head + i) & (N_TTY_BUF_SIZE-1);
                 tty->read_cnt += i;
+               ret += i;
                 spin_unlock_irqrestore(&tty->read_lock, cpuflags);
         } else {
                 ret = count;

With this patch I was able to transfer gigabytes without lost data.

