Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1FVBLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:11:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:47462 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab1FVBLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:11:45 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw3NpaUJWKUTIVmTSTJ
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error
 flooding problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thomas Reim <reimth@googlemail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
In-Reply-To: <20110621212705.1420c63e@endymion.delvare>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	 <20110621212705.1420c63e@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 03:11:24 +0200
Message-ID: <1308705084.3556.74.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Jean, 

thank you for the detailed reply. If I got you right you rose the
following main points:
1. Root cause leading to flooding problem (you assume i2c bus not 
   working correctly, i. e. "stuck bus") not adequately addressed by 
   the fix 
2. Alternative proposal: Fix the verbose logging issue
3. i2c EDID probing inefficiently implemented
4. Strange coding and commenting style

Point 1:
The Asus M2A-VM HDMI EDID error flooding problem was already addressed
in this mailing list in April this year
(https://lkml.org/lkml/2011/4/15/36). But it was not further discussed,
maybe due to missing bug information. I wanted to provide this
information to that thread, but your mail was faster :-). In the
following, you can see the i2c dump of the DVI connector of the AMD 690G
chip, where the monitor is connected to:
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 00 ff ff ff ff ff ff 00 4c 2d ed 00 39 31 49 44    ........L-?.91ID
10: 2d 0e 01 03 80 26 1e 78 2a ee 95 a3 54 4c 99 26    -????&?x*???TL?&
20: 0f 50 54 bf ef 80 81 80 71 4f 01 01 01 01 01 01    ?PT?????qO??????
30: 01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70    ??????0*.?Q.*@0p
40: 13 00 78 2d 11 00 00 1e 00 00 00 fd 00 38 4c 1e    ?.x-?..?...?.8L?
50: 51 0e 00 0a 20 20 20 20 20 20 00 00 00 fc 00 53    Q?.?      ...?.S
60: 79 6e 63 4d 61 73 74 65 72 0a 20 20 00 00 00 ff    yncMaster?  ....
70: 00 48 34 4a 58 42 30 31 35 30 33 0a 20 20 00 e4    .H4JXB01503?  .?
80: 00 ff ff ff ff ff ff 00 4c 2d ed 00 39 31 49 44    ........L-?.91ID
90: 2d 0e 01 03 80 26 1e 78 2a ee 95 a3 54 4c 99 26    -????&?x*???TL?&
a0: 0f 50 54 bf ef 80 81 80 71 4f 01 01 01 01 01 01    ?PT?????qO??????
b0: 01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70    ??????0*.?Q.*@0p
c0: 13 00 78 2d 11 00 00 1e 00 00 00 fd 00 38 4c 1e    ?.x-?..?...?.8L?
d0: 51 0e 00 0a 20 20 20 20 20 20 00 00 00 fc 00 53    Q?.?      ...?.S
e0: 79 6e 63 4d 61 73 74 65 72 0a 20 20 00 00 00 ff    yncMaster?  ....
f0: 00 48 34 4a 58 42 30 31 35 30 33 0a 20 20 00 e4    .H4JXB01503?  .?

Then we have the i2c dump of the HDMI connector with no monitor
connected: 
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 00 00 00 00 00 00 00 00 00 00 1f 00 00 00 00 00    ..........?.....
10: 00 00 00 00 00 XX 00 01 00 00 00 00 1f 00 00 00    .....X.?....?...
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
30: 00 00 00 00 00 XX 00 00 00 00 00 7f 00 00 00 00    .....X.....?....
40: 00 00 1f 00 00 00 00 00 00 00 00 00 00 00 00 00    ..?.............
50: 00 00 00 00 00 07 00 01 00 00 00 00 00 00 00 00    .....?.?........
60: 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00    .....?..........
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
80: 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
90: 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00    .....?..........
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
b0: 00 00 00 00 00 ff 00 00 3f 00 00 00 00 00 00 00    ........?.......
c0: 00 00 00 00 00 00 00 00 00 03 00 00 00 00 00 00    .........?......
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
f0: 00 00 00 00 XX 00 00 7f 00 00 00 00 00 00 00 00    ....X..?........

For this connector radeon_ddc_probe() reports a working DDC, which leads
to the catastrophic situation that drm_get_edid() and
drm_edid_block_valid() flood the logs with EDID error messages and
dumps.

Finally, we have the i2c dump of the VGA connector, where also no
monitor is connected to:
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
40: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
50: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
60: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
70: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
80: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
90: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
a0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
b0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
c0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
d0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
e0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
f0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX

radeon_ddc_probe() reports no DDC.

Do you really believe that this is caused by a stuck i2c bus? Following
the i2c dumps it really makes sense to add a limited check of some major
EDID parts from i2c register for DDC probing. Current radeon_ddc_probe()
just checks that we CAN get data from i2c register 0x50 and leaves the
rest to the log flooding drm_edid functions.

Point 2:
Your proposal has been intensively discussed after release of kernel
2.35. Many users suffered from this log flooding. Many people proposed
fixes, e. g. log EDID errors only once. None of the proposals was taken
over by the kernel developers. The linux distributions' bug lists are
full of these unsolved bug reports. Also in kernel 3.0 no solution was
released. For me that means, kernel people have stringent reasons to NOT
touch the log flooding functions in DRM. Therefore, I spent my time to
fix the problem in the hardware related domain. And the few changes in
radeon code have solved the problem from 2.35 up to the latest 3.0 git
version.

Point 3:
> I don't like this. radeon_ddc_edid_probe() is partly redundant with
> radeon_ddc_probe() and also partly redundant with drm_get_edid() and
> drm_edid_is_valid(). It will add yet another round of I2C transactions,
> and these transactions are slow, so the fewer we have at driver load
> time, the happier we are. This is even more true these days when every
> graphics card gets 8 I2C buses created.
> 
> If nothing else, you should call radeon_ddc_edid_probe() instead of,
> not after, radeon_ddc_probe(), to save a transaction.

This is correct, I was not sure about possible side effects. Therefore,
I used both functions in my first proposal but limited the new one to
the DRM_MODE_CONNECTOR_HDMIA types of the eight i2c busses. 

> +bool radeon_ddc_edid_probe(struct radeon_connector *radeon_connector)
> > +{
> > +	u8 out_buf[] = { 0x0, 0x0};
> 
> You only use the first byte (same in radeon_ddc_probe, could be
> optimized.)
> 
> > +	u8 block[20];
> > +	int ret;
> > +	struct i2c_msg msgs[] = {
> > +		{
> > +			.addr	= 0x50,
> > +			.flags	= 0,
> > +			.len	= 1,
> > +			.buf	= out_buf,
> > +		}, {
> > +			.addr	= 0x50,
> > +			.flags	= I2C_M_RD,
> > +			.len	= 20,
> > +			.buf	= block,
> > +		}
> > +	};
> > +
> > +	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
> 
> You are reading 20 bytes when you really only need 10. It would be more
> efficient to read 8 bytes first, and only if needed, the two remaining
> ones..
> 

What shall we do? On the one hand you complain about the intensive use
of the slow i2c bus. On the other hand you ask to add a second check for
the good case, when we get a valid EDID via i2c. I'm not experienced at
all in i2c bus driver handling. How would we have to change both
radeon_ddc probing functions to request only the first byte?


Point 4:
I've checked your comments and updated the patch. Hopefully, it fits now
better to the linux kernel coding style. Thank you for the hints.


A subsequent mail will contain the updated patch proposal. 

Best regards

Thomas

