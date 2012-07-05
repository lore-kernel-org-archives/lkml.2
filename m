Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2GEXx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:53:28 -0400
Received: from mail.snarked.org ([67.43.172.250]:60326 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab2GEXx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:53:27 -0400
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Re: Intel e1000 ethernet device, change in kernel v3.4, and jumbo frames setting DENIED.
Date: Thu, 5 Jul 2012 16:53:18 -0700
Message-ID: <jt59dm$fiq$1@snarked.org>
References: <jjE3E-5PM-29@gated-at.bofh.it> <jjGoO-7l0-19@gated-at.bofh.it>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3555.308
In-Reply-To: <jjGoO-7l0-19@gated-at.bofh.it>
X-Newsreader: Microsoft Windows Live Mail 15.4.3555.308
Importance: Normal
X-Priority: 3
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Henrique de Moraes Holschuh"  wrote in message 
news:jjGoO-7l0-19@gated-at.bofh.it...
On Wed, 04 Jul 2012, D. Stussy wrote:
> There has been some changes to the driver such that things like
> checksum verification is offloaded from the CPU.  However, this
> blocks the ability to set a jumbo frame.  The kernel does record an
> error indicating that checksum offloading need be disabled fro jumbo
> frame MTU sizes to be used.  My e1000 interfaces use the 82574L
> chipset.
>
> 1)  Was this an intentional change?

Yes, but I understand Intel is trying to come up with a way not to need it.
==============
OK, found the modification.  NETIF_F_RXHASH turned on by default in a 
modification ("Receive Packet Steering support") from January 26, 2012.

Features which have no OFF setting should DEFAULT OFF and wait to be 
explicitly enabled.  The change which was inserted is stupid.
==============

> 2)  How do I disable that function so I can set jumbo frames with
> "ifconfig" or "ip"?  I simply don't know what setting I need to
> pass.

ethtool can do it.  Check its manpage, it can manipulate the various NIC
offload engines, as well as other parameters such as dma ring buffer size,
etc.
===============
Got it:  ethtool -K eth0 rx off

However, I'd prefer to turn off hashing instead of the checksum and I didn't 
recognize a single setting which would do that.  Under "ethtool -N", there 
seem to be 8 settings, but none of the options seemed to disable hashing 
(without simultaneously dropping packets).  I still need help:  What is the 
correct setting I need to disable this?  I don't see a simple OFF setting.

Else, this part of the patch should be reversed:
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6136,6 +6213,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
NETIF_F_HW_VLAN_TX |
NETIF_F_TSO |
NETIF_F_TSO6 |
+                NETIF_F_RXHASH |
NETIF_F_RXCSUM |
NETIF_F_HW_CSUM); 

