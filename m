Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab1DYISM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 04:18:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab1DYISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 04:18:11 -0400
From: Martin <marogge@onlinehome.de>
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: Re: ehci_hcd 0000:00:1d.0: HC died; cleaning up
Date: Mon, 25 Apr 2011 10:18:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck3; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104251018.08229.marogge@onlinehome.de>
X-Provags-ID: V02:K0:5h8Ed6fiOSXJVz/00kKzqWvQQLzGCdplVM5fasm68rw
 E2qBiQeOm6B+B6qUlOUwkJJni2FmaJImiAxw7M7RsFf7i+nCIy
 XIEXSE7RKmEgFz2IiHdap1kdouPx6nmTfEIOCh016GxzsIuCf8
 2IOMCAOwHibt4gUhz2x4b6+U1CAoOve9rT+IKK85KMfAD7c0CE
 S12agqbQx14l6KpNkTqvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin wrote:

> recently, when plugging in my webcam (UVC driver) my USB stack seems to
> collapse. All USB devices including the mouse & keyboard stop working, the
> syslog says:
> 
> Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: fatal error
> Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: force halt;
> handshake ffffc90000052024 00004000 00004000 -> -110
> Apr 24 19:03:45 arnold kernel: ehci_hcd 0000:00:1d.0: HC died; cleaning up

I was dabbling a bit further and can re-play the final scene of what must have 
happened: the IRQ routine detected a fatal error, threw the hands in the air 
and turned the computer into a brick. Question now is what caused the fatal 
error.

static irqreturn_t ehci_irq (struct usb_hcd *hcd)
{
        struct ehci_hcd         *ehci = hcd_to_ehci (hcd);
        u32                     status, masked_status, pcd_status = 0, cmd;
        int                     bh;

        spin_lock (&ehci->lock);

        status = ehci_readl(ehci, &ehci->regs->status);
[...]
        /* PCI errors [4.15.2.4] */
        if (unlikely ((status & STS_FATAL) != 0)) {
                ehci_err(ehci, "fatal error\n");
                dbg_cmd(ehci, "fatal", cmd);
                dbg_status(ehci, "fatal", status);
                ehci_halt(ehci);
dead:
                ehci_reset(ehci);
                ehci_writel(ehci, 0, &ehci->regs->configured_flag);
                /* generic layer kills/unlinks all urbs, then
                 * uses ehci_stop to clean up the rest
                 */
                bh = 1;
        }

        if (bh)
                ehci_work (ehci);
        spin_unlock (&ehci->lock);
        if (pcd_status)
                usb_hcd_poll_rh_status(hcd);
        return IRQ_HANDLED;
}
