Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2HSIpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:45:33 -0400
Received: from antcom.de ([188.40.178.216]:41460 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab2HSIpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:45:25 -0400
Message-ID: <5030A7A0.3080308@antcom.de>
Date: Sun, 19 Aug 2012 10:45:20 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH RESEND 2/2] i2c: pnx: Fix read transactions of >= 2 bytes
References: <1344411752-23469-1-git-send-email-stigge@antcom.de> <1344411752-23469-2-git-send-email-stigge@antcom.de> <20120818095212.GC24812@pengutronix.de>
In-Reply-To: <20120818095212.GC24812@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18/08/12 11:52, Wolfram Sang wrote:
> On Wed, Aug 08, 2012 at 09:42:32AM +0200, Roland Stigge wrote:
>> On transactions with n>=2 bytes, the controller actually wrongly
>> clocks in n+1 bytes. This is caused by the (wrong) assumption
>> that RFE in the Status Register is 1 iff there is no byte already
>> ordered (via a dummy TX byte). This lead to the implementation of
>> synchronized byte ordering, e.g.:
>> 
>> Dummy-TX - RX - Dummy-TX - RX - ...
>> 
>> But since RFE actually stays high after some Dummy-TX, it rather
>> looks like:
>> 
>> Dummy-TX - Dummy-TX - RX - Dummy-TX - RX - (RX)
>> 
>> The last RX byte is clocked in by the bus controller, but ignored
>> by the kernel when filling the userspace buffer.
>> 
>> This patch fixes the issue by asking for RX via Dummy-TX
>> asynchronously. Introducing a separate counter for TX bytes.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> 
>> --- Applies to v3.6-rc1
>> 
>> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx,
>> not yet in mainline). Can you please test?
>> 
>> Thanks in advance!
> 
> I assume you checked this on LPC32xx?

Yes.

The bug surfaced when we debugged unexpected behaviour with I2C
clients. A colleague noticed that sometimes, there were more bytes
transferred than expected, confusing some I2C clients.

The patch fixes exactly that.

Thanks,

Roland
