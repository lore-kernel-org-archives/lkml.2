Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1FGLPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:15:07 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:51869 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1FGLPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:15:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DEE0A1A.9040508@cam.ac.uk>
Date: Tue, 07 Jun 2011 12:23:06 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: anish kumar <anish198519851985@gmail.com>
CC: Greg KH <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        manuel.stahl@iis.fraunhofer.de
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
References: <1307387257.4327.12.camel@anish-desktop>	<20110606215549.GA7543@suse.de>	<1307398257.4994.30.camel@Joe-Laptop>	<20110606222118.GA29883@suse.de>	<1307399309.4994.34.camel@Joe-Laptop>	<20110606224126.GA2668@suse.de> <BANLkTimZP1=tOdsn9eNiERr0Up0xHrr=3g@mail.gmail.com> <4DEDF2B8.5020502@cam.ac.uk> <235574A8AA3344EF9A7F9D1D3B128B70@your6c359a3bdc>
In-Reply-To: <235574A8AA3344EF9A7F9D1D3B128B70@your6c359a3bdc>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 11:32, anish kumar wrote:
> Jonathan Cameron wrote:
>> On 06/07/11 05:56, anish singh wrote:
>>>
>>>
>>> On Tue, Jun 7, 2011 at 4:11 AM, Greg KH <gregkh@suse.de
>>> <mailto:gregkh@suse.de>> wrote:
>>>
>>>     On Mon, Jun 06, 2011 at 03:28:29PM -0700, Joe Perches wrote:
>>>     > On Mon, 2011-06-06 at 15:21 -0700, Greg KH wrote:
>>>     > > On Mon, Jun 06, 2011 at 03:10:57PM -0700, Joe Perches wrote:
>>>     > > > On Mon, 2011-06-06 at 14:55 -0700, Greg KH wrote:
>>>     > > > > On Tue, Jun 07, 2011 at 12:37:37AM +0530, anish wrote:
>>>     > > > > > From: anish kumar <anish198519851985@gmail.com
>>>     <mailto:anish198519851985@gmail.com>> > > > > > Replace kmalloc with
>>>     local variables as it was un-necessary and > > > > > also removed the
>>>     redudant code after this change. > > > > SPI data, like USB data, has to
>>>     come from kmalloced data, not from the > > > > stack, or bad things can,
>>>     and will, happen. > > > Perhaps just add a comment like:
>>>     > > > +       u8 *tx = kmalloc(2, GFP_KERNEL);  /* can't be on stack */
>>>     > > You really want to do to that for _EVERY_ SPI and USB driver?  I
>>>     don't > > think so.
>>>     >
>>>     > Nope, only the ones that look especially odd because
>>>     >       kmalloc(sizeof(struct foo), ...)
>>>     > or
>>>     >       kmalloc(sizeof("type), ...)
>>>     > is not used.
>>>     >
>>>     > It might be better to just declare a 2 byte struct.
>>>
>>>     No, this is a very common thing for all USB and SPI drivers.  It's so
>>>     obvious that once I saw the Subject: line, I knew this patch was going
>>>     to be wrong.
>>>
>>>     This is something that the USB and SPI developers know all about, it's
>>>     the way things work, and this driver works, so why are people trying to
>>>     "clean" it up in ways that will break it, or cause extra work with
>>>     structures where they are not needed at all?
>>>
>>> Sorry for noise as i didn't the SPI requirements,thought it is similar to
>>> I2C and
>>> in cleaning up below part i wrongly cleaned SPI part also.Below was also part
>>> of patch.
>> Not to worry, you are far from the first person to fall into this issue!
>> Also, you have highlighted a weird corner in that driver, that could do with
>> tidying up (just not quite the fix you had in mind!).
>>> static int max1363_write_basic_config(struct i2c_client *client,
>>>                                      unsigned char d2)
>>>  {
>>>        int ret;
>>> -       u8 *tx_buf = kmalloc(2, GFP_KERNEL);
>>> +       u8 tx_buf[2];
>>>        if (!tx_buf)
>>>                return -ENOMEM;
>>> @@ -215,7 +215,6 @@ static int max1363_write_basic_config(struct i2c_client
>>>        *client, tx_buf[1] = d2;
>>>        ret = i2c_master_send(client, tx_buf, 2);
>>> -       kfree(tx_buf);
>>>        return (ret > 0) ? 0 : ret;
>>>  }
>>> I think above patch is ok as it is I2C and I2C doesn't have that requirement.
>> Yes.  I2C bus drivers that do dma do the copy into dma safe memory internally.
>> Makes for more bouncing around of data, but i2c is slow anyway so it doesn't
>> matter. Also, based on a quick look this morning, the dma buffers tend to
>> require various headers to be in place etc which isn't typically the case for
>> spi (a much more 'raw' bus).
> I couldn't understand this comment.Specifically "various headers"?
principally looking at some drivers, i2c has an address.  This is sometimes at the
start of the dma buffer sent to the controller.
> Will appreciate it if you kindly explain.
Take a look at say, i2c-cpm.c (first example grep gave me ;)
cpm_i2c_parse_message
is the function that builds up the dma buffer contents.
The memcpy gives it away, as that is copying to +1 in the buffer that is dma'd off
to the controller.  The tb[0] contains the address.

Anyhow, this is probably needed for some spi controllers as well, but certainly not
all of them. Digging down in pxa2xx_spi for example, we have a the original tx and rx
pointers passed all the way through to the eventual dma transfer ( I think, that driver
isn't all that easy to follow!).

Jonathan


