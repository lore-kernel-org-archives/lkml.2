Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1CXNAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:00:16 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:38601 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926Ab1CXNAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:00:13 -0400
Date: Thu, 24 Mar 2011 15:00:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Toby Gray <toby.gray@realvnc.com>
Cc: balbi@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110324130006.GM14602@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8121F6.9060600@keymile.com>
 <20110317000408.GA18911@kroah.com>
 <4D8389EC.5030704@keymile.com>
 <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
 <20110318180657.11570887@lxorguk.ukuu.org.uk>
 <20110321093255.GE1837@legolas.emea.dhcp.ti.com>
 <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
 <4D8B341C.4010406@realvnc.com>
 <20110324123708.GK14602@legolas.emea.dhcp.ti.com>
 <4D8B3E61.1090704@realvnc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B3E61.1090704@realvnc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 12:51:45PM +0000, Toby Gray wrote:
> On 24/03/2011 12:37, Felipe Balbi wrote:
> >Hi,
> >
> >On Thu, Mar 24, 2011 at 12:07:56PM +0000, Toby Gray wrote:
> >>Is this patch missing the changes to tty_buffer.c that were in
> >>http://permalink.gmane.org/gmane.linux.usb.general/28976
> >>
> >>Without the changes to tty_buffer.c to use the value returned from
> >>the receive_buf call then doesn't this patch not work correctly?
> >>
> <snip>
> >you are right, thanks for noticing that. Attached is an updated patch.
> >I left removal of receive_room out of this patch to prevent too invasive
> >change, that can be done on a separate patch.
> 
> I've just tried removing receive_room myself and noticed that it is
> still used in flush_to_ldisc to decide if it needs to schedule work
> to be done later:
> 
>    if (!tty->receive_room || seen_tail) {
>       schedule_work(&tty->buf.work);
>       break;
>    }
> 
> If receive_room is no longer being updated then isn't this the wrong
> thing to do? Shouldn't it check if some data was copied after calling
> receive_buf, and if there wasn't any then it should schedule the work
> and break?
> 
> The other query I've got is about the return value from receive_buf.
> I noticed that you've modified some drivers (such as
> bluetooth/hci_ldisc.c) so that they can return error values, such as
> -ENODEV. Won't this cause things to go wrong when flush_to_ldisc and
> paste_selection use the return value without checking for it being
> negative?
> 
> Thank you for your quick reply to my first query, it's appreciated.

Can you try this:

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 2f119e2..f0b9fb6 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -443,17 +443,19 @@ static void flush_to_ldisc(struct work_struct *work)
                           line discipline as we want to empty the queue */
                        if (test_bit(TTY_FLUSHPENDING, &tty->flags))
                                break;
-                       if (!tty->receive_room || seen_tail) {
-                               schedule_delayed_work(&tty->buf.work, 1);
-                               break;
-                       }
                        char_buf = head->char_buf_ptr + head->read;
                        flag_buf = head->flag_buf_ptr + head->read;
                        spin_unlock_irqrestore(&tty->buf.lock, flags);
                        copied = disc->ops->receive_buf(tty, char_buf,
                                                        flag_buf, count);
                        spin_lock_irqsave(&tty->buf.lock, flags);
+
                        head->read += copied;
+
+                       if (copied == 0 || seen_tail) {
+                               schedule_delayed_work(&tty->buf.work, 1);
+                               break;
+                       }
                }
                clear_bit(TTY_FLUSHING, &tty->flags);
        }


if I read the code correctly, when we have no space to receive bytes,
then we schedule work, that should be the same.

-- 
balbi
