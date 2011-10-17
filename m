Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1JQLcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:32:23 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57769 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1JQLcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:32:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C1249.5020408@cam.ac.uk>
Date: Mon, 17 Oct 2011 12:32:25 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com> <4E9BF8D9.8030301@cam.ac.uk> <20111017101959.GC3042@opensource.wolfsonmicro.com> <4E9C0423.5010909@cam.ac.uk> <20111017104642.GD3042@opensource.wolfsonmicro.com> <4E9C0DD7.7080105@cam.ac.uk> <20111017111807.GA27266@opensource.wolfsonmicro.com>
In-Reply-To: <20111017111807.GA27266@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 12:18, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 12:13:27PM +0100, Jonathan Cameron wrote:
>> On 10/17/11 11:46, Mark Brown wrote:
> 
>>> I think the PMIC case is a real one, assigning numbers people need to
>>> use to find things is doesn't really reflect actual usage.
> 
>> Just to make sure I'm understanding you correctly could you give an example
>> part.  The supplies one we explicitly handle anyway so I'm happy with that
>> one, I just want to confirm that this is what you are talking about.
> 
> The wm831x PMICs have an AUXADC with (actual wirings vary depending on
> the particular device):
Just to pin this down completely...
> 
>  - Some voltage inputs hard wired to particular system supplies.
Hard wired in the pmic?  (e.g. do not vary from device to device).
These I'm happy to see have names.  If it were a normal IIO device their
access attributes would be something like:

in_voltage0_supply3V_raw
in_voltage1_supply2.8V_raw

(have insist on indexing even with named channels because it is needed as
events codes don't want to carry a string.).

>  - One or more temperature inputs wired to particular place (eg, chip
>    and battery).
Not hard wired so to my mind these are just general purpose temperature inputs.
Hence naming doesn't make sense (at least not outside of board file or DT).
If there really is something that stops these being switched round then they can
be named (e.g. if one is actually in the pmic package!). IIO raw attribute would be: 

in_temp0_raw
in_temp1_raw etc

>  - Some channels that measure voltages on some of the pins with no
>    particular function allocated to them.
So these are nameless numbered channels.

in_voltage13_raw onwards.

There are some complexities to deal with that make me wonder if direct indexing
into a driver provided table isn't easier.  The other is channel types.

Perhaps something as involved as the following works - we are basically lifting about
half of struct iio_chan_spec into here:

struct adc_map {
/* Input / output side */
        struct device *adc_dev;
        const char *adc_dev_name;
	int channel_num1;
	int channel_num2;
	enum IIO_TYPE type /*adc etc*/
	bool differential.
/* User side */
        const char *channel;
        struct device *dev;
        const char *dev_name;
};

Is it so bad to insist that the dt writer or equivalent actually looks at the
driver in question and picks the underlying channel index directly?

I'm certainly going to implement that first then add the matching logic
afterwards anyway as it will make it easier to review / test.



