Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab0KSXiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:38:24 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15775 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0KSXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:38:22 -0500
Message-ID: <4CE70A67.9010203@caviumnetworks.com>
Date: Fri, 19 Nov 2010 15:38:15 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andy Fleming <afleming@gmail.com>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2] of/phylib: Use device tree properties to initialize
 Marvell PHYs.
References: <1290204798-28569-1-git-send-email-ddaney@caviumnetworks.com> <AANLkTikuikWgLbW67m1Ov0dt13A=DTSF150aTOs=PybT@mail.gmail.com>
In-Reply-To: <AANLkTikuikWgLbW67m1Ov0dt13A=DTSF150aTOs=PybT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2010 23:39:11.0988 (UTC) FILETIME=[F7FBBB40:01CB8842]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 03:02 PM, Andy Fleming wrote:
> On Fri, Nov 19, 2010 at 4:13 PM, David Daney<ddaney@caviumnetworks.com>  wrote:
>> Some aspects of PHY initialization are board dependent, things like
>> indicator LED connections and some clocking modes cannot be determined
>> by probing.  The dev_flags element of struct phy_device can be used to
>> control these things if an appropriate value can be passed from the
>> Ethernet driver.  We run into problems however if the PHY connections
>> are specified by the device tree.  There is no way for the Ethernet
>> driver to know what flags it should pass.
>>
>> If we are using the device tree, the struct phy_device will be
>> populated with the device tree node corresponding to the PHY, and we
>> can extract extra configuration information from there.
>>
>> The next question is what should the format of that information be?
>> It is highly device specific, and the device tree representation
>> should not be tied to any arbitrary kernel defined constants.  A
>> straight forward representation is just to specify the exact bits that
>> should be set using the "marvell,reg-init" property:
>>
>>       phy5: ethernet-phy@5 {
>>         reg =<5>;
>>         compatible = "marvell,88e1149r";
>>         marvell,reg-init =
>>                 /* led[0]:1000, led[1]:100, led[2]:10, led[3]:tx */
>>                 <3 0x10 0 0x5777>, /* Reg 3,16<- 0x5777 */
>>                 /* mix %:0, led[0123]:drive low off hiZ */
>>                 <3 0x11 0 0x00aa>, /* Reg 3,17<- 0x00aa */
>>                 /* default blink periods. */
>>                 <3 0x12 0 0x4105>, /* Reg 3,18<- 0x4105 */
>>                 /* led[4]:rx, led[5]:dplx, led[45]:drive low off hiZ */
>>                 <3 0x13 0 0x0a60>; /* Reg 3,19<- 0x0a60 */
>
>
> My inclination is to shy away from such hard-coded values.  I agreed
> with Grant's comment about separating into separate cells, but I think
> specification of hard-coded register writes is too rigid.  I think a
> better approach would be to specify configuration attributes, like:
>
> marvell,blink-periods =<blah>;
> marvell,led-config =<[drive type] [indicates]>;

I considered doing that, but rejected the idea because it is so complex. 
  There are literally probably a hundred different register fields with 
widths varying between 1 and 16 bits.  The number of settings that the 
driver might want to deal with are astronomical.  For any given PHY 
model there could be 30 different settings that you might want to tweak. 
  In the example above I configure 5 LEDs with two parameters each, and 
about 4 or 5 more blink settings, that is something like 15 register fields.

Take the marvell.c file.  It currently supports nine different PHY 
models, each would have a bunch of model specific settings, the 
complexity of decoding all that is formidable (and would be a lot more 
code) also there would invariably be settings that were not implemented 
in the first version, so people would have to repeatedly extend it.

My patch adds 550 bytes (not including the string storage) of code on 
MIPS64, and can handle many cases without any changes.

>
> For one, I always advocate making the DTS human-readable.  For
> another, I think that there are a number of configuration sequences
> that require read-modify-write, or write-wait-write.  In other words,
> I think that there are enough cases where actual software will be
> needed, that an attempt to generically specify a register
> initialization sequence will be impossible, and leave us with the same
> problems to solve later on.

We can always add more properties as you suggest, if the existing code 
does not prove to be sufficiently flexible.

>  For third...ly... allowing
> device-tree-specified register initializations might encourage
> developers to put all of their register initializations in the device
> tree.  Especially when they realize that the LED initialization for
> *their* PHY has to come between two standard initialization steps in
> the driver.  Or before.  Or after.
>
> By specifying actual functionality, the driver can work around those
> problems, while being aware of the functional goal.  However, I'm
> aware that such a path is more difficult, and perhaps just as futile,
> as PHY vendors frequently don't want to document what their magic
> sequences mean.
>

I certainly understand your desire to make the dts readable, but I think 
it has to be balanced against the complexity and chance for bugs in the 
drivers as well as churn in the bindings specifications.

David Daney
