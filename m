Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1BRLt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:49:57 -0500
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:57710 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1BRLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:49:54 -0500
X-Greylist: delayed 837 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 06:49:54 EST
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4D5E597F.6000801@ise.pw.edu.pl>
Date: Fri, 18 Feb 2011 12:35:27 +0100
From: =?UTF-8?B?V29qY2llY2ggWmFib8WCb3RueQ==?= <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Proposed changes/improvements to SPI drivers
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've worked with a SPI hardware requiring a little longer delay between 
deactivation and activation of CS line. To improve throughput, I had to 
perform transmission with a single spi_message consisting of
a few spi_transfers.
When debugging my driver, it appeared, that the usecs_delay allows me 
only to introduce delay
before CS gets deactivated. The delay between deactivation and 
activation of CS between transfers
is hardcoded:  (e.g. 
http://lxr.linux.no/linux+v2.6.37.1/drivers/spi/atmel_spi.c#L513 ).

I'd like to suggest adding another field (maybe "cs_inact_delay") like 
delay_usecs in the spi_transfer structure, which will define the time 
for which CS remains inactive:
(for example in atmel_spi it should look as follows:
  511   if (xfer->cs_change) {
  512          cs_deactivate(as, msg->spi);
  513          udelay(xfer->cs_inact_delay);
  514          cs_activate(as, msg->spi);
  515    }
)

Another problem, which I've faced was a little misleading description of 
the cs_change.
It has one additional functionality (at least in atmel_spi.c):
  When cs_change is set in the last transfer in a message, CS is not 
deactivated after the last transfer and is still active until the next 
spi_message is serviced (see 
http://lxr.linux.no/linux+v2.6.37.1/drivers/spi/atmel_spi.c#L395 , 
called from 
http://lxr.linux.no/linux+v2.6.37.1/drivers/spi/atmel_spi.c#L508 - if 
cs_change is non-zero, then "stay" is non-zero, and CS is not deactivated).

I don't know whether it is a bug or an undocumented feature...
-- 
Best Regards,
Wojciech Zabolotny

