Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2JYW0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:26:10 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:52322
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab2JYW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:26:06 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.133;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0610HT004.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <5089BC7A.80103@convergeddevices.net>
Date: Thu, 25 Oct 2012 15:26:02 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <hverkuil@xs4all.nl>, <mchehab@redhat.com>, <sameo@linux.intel.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] Add the main bulk of core driver for SI476x code
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net> <1351017872-32488-3-git-send-email-andrey.smirnov@convergeddevices.net> <20121025194524.GV18814@opensource.wolfsonmicro.com>
In-Reply-To: <20121025194524.GV18814@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 12:45 PM, Mark Brown wrote:
> On Tue, Oct 23, 2012 at 11:44:28AM -0700, Andrey Smirnov wrote:
>
>> +	core->regmap = devm_regmap_init_si476x(core);
>> +	if (IS_ERR(core->regmap)) {
> This really makes little sense to me, why are you doing this?  Does the
> device *really* layer a byte stream on top of I2C for sending messages
> that look like marshalled register reads and writes?
The SI476x chips has a concept of a "property". Each property having
16-bit address and 16-bit value. At least a portion of a chip
configuration is done by modifying those properties. In order to
manipulate those properties user is expected to issue what is called a
"command". For manipulating "properties" there are two "commands":
- SET_PROPERTY which is I2C write of 6 bytes of the following layout:
    | 0x13 | 0x00 | Address High Byte | Address Low Byte | Property Data
High Byte | Property Data Low Byte |
    After the command is finished being executed the 1 byte read would
contain the status byte

    followed by 1 byte read which contain status byte
- GET_PROPERTY which is I2C write of 4 bytes of the following layout:
    | 0x13 | 0x00 | Address High Byte | Address Low Byte |
    After the command is finished being executed the 4 byte read would
have the following layout:
    | Status Byte | Reserved Byte | Property Value High Byte | Property
Value Low Byte |

The chip does not operate continuously in the AM/FM frequency range,
instead the user is expected to power-down/power-up the chip in a
certain "mode" which in my case can be either AM or FM tuner. There are
two ways of doing that one is to send a power down command to the
device, the second one is to toggle reset line of the chip. Both methods
will reset the values of the aforementioned "properties". Because V4L2
user-space interface presents a tuner as the one continuously operating
in the whole AM/FM range it is necessary for me to do those AM/FM
switches transparently when handling tuning or seeking requests from the
user. That means that I need to cache the values of the properties I
care about in the driver and restore them when user switches to the
mode(for example when AM->FM->AM transition happens)

The other quirk of that chip is that some properties are only accessible
in certain modes(for example it is impossible to configure RDS interrupt
sources, which is FM specific, in AM mode), but some of the controls I
expose to user-land change the values of the properties and since AM/FM
switches happen transparently to the user in the situation when FM
specific property is changed while tuner is in AM mode, the driver has
to cache the value and write it when the switch to FM would take place.

Also due to the way the driver uses the chip it is only powered up when
the corresponding file in devfs(e.g. /dev/radio0) is opened at least by
one user which means that unless there is a user who opened the file all
the SET/GET_PROPERTY commands sent to it will be lost. The codec driver
for that chip does not have any say in the power management policy(while
all the audio configuration is done via "properties") if the chip is not
powered up the driver has to cache the configuration values it has so
that they can be applied later.

So, since I have to implement a caching functionality in the driver, in
order to avoid reinventing the wheel I opted for using 'regmap' API for
this.
Of course, It is possible that I misunderstood the purpose and
capabilities of the 'regmap' framework, which would make my code look
very silly indeed. If that is the case I'll just re-implement it using
some sort of ad-hoc version of caching.



