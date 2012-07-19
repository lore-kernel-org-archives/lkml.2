Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2GSMDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:03:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50622 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2GSMDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:03:06 -0400
MIME-Version: 1.0
Date: Thu, 19 Jul 2012 14:03:04 +0200
Message-ID: <CAPkRUj8ix-NyuPHLOinX7MneFg+CpAyBinevOLD9-h=p08D6Lw@mail.gmail.com>
Subject: PROBLEM: Kernel Driver CAN for AT91SAM9263EK
From: Romain RODRIGUEZ <romain.rdgz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My name is Romain Rodriguez, french software engeener, and i'm working
on a at91sam9263ek board, which contains embedded Linux (3.4.4
versions)

I found a bug on the CAN driver.

the mailbox configured in Transmit can transmit only one message,
because the flag MSR_MRDY is never reached after the write.

According to the AT91sam9263EK datasheet :

• MRDY: Mailbox Ready
An interrupt is triggered when MRDY is set.
0 = Mailbox data registers can not be read/written by the software
application. CAN_MDx are locked by the CAN_MDx.
1 = Mailbox data registers can be read/written by the software application.

This flag is cleared by writing to CAN_MCRx register. (when we
transmit a message)

Mailbox Object Type Description
Receive :
At least one message has been received since the last mailbox transfer
order. Data from the first frame
received can be read in the CAN_MDxx registers.
After setting the MOT field in the CAN_MMR, MRDY is reset to 0.

Transmit :
Mailbox data have been transmitted.
After setting the MOT field in the CAN_MMR, MRDY is reset to 1.


In the CAN driver, the MOT field in the CAN_MMR register is never set
after a transmit.

I wrote a little soft who send frame (size : 6 B) on can0 in an infinity loop ,
I see 4 messages transmitted (1 per mailbox, because 4 mailbox
configured in transmit) , and after, nothing more.

can0      Link encap:UNSPEC  HWaddr
00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          UP RUNNING NOARP  MTU:16  Metric:1
          RX packets:29658 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:29656 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:10
          RX bytes:237264 (231.7 KiB)  TX bytes:24 (24.0 B)
          Interrupt:12

We can see, TX bytes is blocked to 24 B. (6 B * 4 mailbox)

I did that in the file drivers/net/can/at91_can.c :

line 381 (in function netdev_tx_t at91_start_xmit), I added :

reg_msr = at91_read(priv, AT91_MSR(mb));
if(!(reg_msr & AT91_MSR_MRDY))
{
set_mb_mode_prio(priv, mb, AT91_MB_MODE_TX, 0);
}

after my modification :

can0      Link encap:UNSPEC  HWaddr
00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          UP RUNNING NOARP  MTU:16  Metric:1
          RX packets:159588 errors:0 dropped:0 overruns:0 frame:0
          TX packets:88 errors:159584 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:10
          RX bytes:1276704 (1.2 MiB)  TX bytes:528 (528.0 B)
          Interrupt:12


I hope this time you receive this mail.

Best Regards
