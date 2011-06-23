Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1FWKPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:15:21 -0400
Received: from remail2.raritan.com ([62.132.199.138]:44716 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab1FWKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:15:20 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jun 2011 06:15:19 EDT
Message-ID: <4E0310E3.9030605@raritan.com>
Date: Thu, 23 Jun 2011 12:09:39 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: claudio.scordino@gmail.com
Subject: atmel_serial: receive data lost in RS485 mode
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Jun 2011 10:09:40.0333 (UTC) FILETIME=[AA3F59D0:01CC318D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on our AT91 board we use the RS485 mode on the serial port and noticed 
some data loss in some circumstances. (kernel 2.6.38.7)

What happens is the following: When starting TX the RX part is disabled:

atmel_start_tx():
		...
		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
			atmel_stop_rx(port);
		...

When TX is done it is enabled again:

atmel_tx_dma():
		...
		if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
			/* DMA done, stop TX, start RX for RS485 */
			atmel_start_rx(port);
		}
		...

Since the RS485 mode is only half duplex this looks ok (or at least not 
wrong) at the first glance but it only works if RX is enabled 
synchronously when TX is done. Actually it happens under some 
circumstances that there is a latency between TX done and enabling RX 
again. All data received during that time is lost.

So the question is: Why disabling RX at all during TX? I can't see any 
benefit. I removed this two code parts above and all works perfectly 
well and no data is lost anymore.

greets,
ron

PS: I'm not on the list - please keep me in Cc. Thx!

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler
