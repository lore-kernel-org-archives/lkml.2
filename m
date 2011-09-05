Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1IEOlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:41:01 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:43196 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1IEOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:40:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E64E16A.6060401@cam.ac.uk>
Date: Mon, 05 Sep 2011 15:49:14 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regmap bulk read styles.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I'm looking at the using your regmap stuff for IIO.
Other than the minor queries in the other emails I've sent,
the big issue for me is that of bulk reading.

The two most common forms we have are 'burst read'
and what might be termed a 'gather read'.

The burst read is pretty much what you have covered by
regmap_bulk_read. I assume an implementation for spi
doing

TX Addr1 XXXXX XXXXX XXXXX XXXXX
RX XXXXX Data1 Data2 Data3 Data4 ...

would be general enough to be worth providing? Any device
that doesn't understand this should simply not use it.

The second is more interesting.  It actually looks quite like
your gather write.  We have a set of registers that we need
to read.  A classic example is that a coherent set will only
be received (e.g. valid at an instant in time) if we read
all channels of an accelerometer in one go (between chip selects).

typically involves either

TX  Addr1  Addr2  Addr3  XXXXX
RX  XXXXX  Data1  Data2  Data3

Or

TX Addr1  00000 Addr2 00000
RX XXXXX  Data1 XXXXX Data2

One slight complexity is cs_change, but that probably needs fixing
in the spi core which doesn't currently allowing setting up a
default for that.  This second case would be a set of transfers
(read then writes effectively).

Would you be in favour of an interface to handle this use case
or is it better just to bypass regmap for this use case?
(which would be a pity as it leads to duplication as all the
configuration stuff fits nicely).

As an aside, isn't your gather write more typically described
as a scatter write?  (writes one coherent set to a number of
disjoint locations?)

Alternatively should I just be bypassing regmap entirely for
read only data registers like these?  Caching is kind of pointless
other than for debugging purposes (though that would be nice).

Thanks,

Jonathan
