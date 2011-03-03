Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab1CCWJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:09:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55450 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab1CCWJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <20110303230253.0e8455c2@endymion.delvare>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
 <20110303115151.GF3649@pengutronix.de> <20110303132025.51e0d92e@endymion.delvare>
 <20110303132549.GG3649@pengutronix.de> <20110303172653.GB22940@angua.secretlab.ca>
 <20110303230253.0e8455c2@endymion.delvare>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 3 Mar 2011 15:09:28 -0700
X-Google-Sender-Auth: CLDdsbQAK_teEH1V15rmgoylHB8
Message-ID: <AANLkTikXzJEAYg7+5ekMzTj_V-Hs63Psgru4Vc_QGhRy@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
To: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Dirk Eibach <eibach@gdsys.de>,
        devicetree-discuss@lists.ozlabs.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 3:02 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 3 Mar 2011 10:26:53 -0700, Grant Likely wrote:
>> On Thu, Mar 03, 2011 at 02:25:49PM +0100, Wolfram Sang wrote:
>> > OK. The thing is you can't map platform_data 1:1 to bindings, because
>> > most are very specific to the Linux-driver. Do you think something like
>> > "active-channels" would be sufficent for those other hwmon devices, too?
>> > (I still do not like "exported-channels", because there is no need to
>> > export the channels for the OS. The devicetree is primarily a hardware
>> > description language) Or maybe we go specific and say "ads1015,channel1
>> > = 1"? Maybe somebody knows of a similar chips as a reference?
>>
>> Yes, Wolfram's correct.  The focus should be on what the connections
>> actually are instead of what the OS should attempt to do with them.
>> ie. give the active channels actual names for what they do, or use a
>> phandle to reference them from another node.  The driver can then make
>> a decision based on whether or not a channel has a configuration
>> provided.
>>
>> From the little information I have, I'd recommend something like:
>>
>> sensor@49 {
>>       compatible = "ti,ads1015"
>>       reg = <0x49>;
>>
>>       // Each child node (one node per channel) has an address with
>>       // no range
>>       #address-cells = <1>;
>>       #size-cells = <0>;
>>
>>       adc@2 {
>>               ti,measurement = "cpu voltage";
>>               reg = <2>;
>>       };
>>
>>       adc@4 {
>>               ti,measurement = "base voltage";
>>               reg = <4>;
>>       };
>> };
>>
>> However, after taking a little look at the data sheet, this binding
>> might end up being a little naive for what the part can do.  It might
>> make more sense to do something like:
>>
>> sensor@49 {
>>       compatible = "ti,ads1015"
>>       reg = <0x49>;
>>
>>       // Each child node (one node per channel) has an address with
>>       // no range
>>       #address-cells = <1>;
>>       #size-cells = <0>;
>>
>>       measurement@0 {
>>               reg = <0>;      // This reg value no longer reflects
>>                               // the chip, it's just a handle for
>>                               // logical measurement channels
>
> If there any hard requirement for this? From the driver's perspective,
> the multiplexer setting can be used as the channel ID, and it's easier
> this way than using arbitrary identifiers.

Nope, not a hard requirement.  Just a suggestion.  It would be
valuable if (and only if) there was ever reason to have more than one
configuration for a particular multiplexer setting.

>> It's more verbose than a single exported-channels property, but it is
>> flexible enough that it can be easily extended with extra
>> configuration data per channel.
>
> I will leave it up to Dirk to decide how much time he wants to spend on
> this. He has already been very patient with the driver review process
> and I do not want to abuse his patience.

BTW Dirk, I'm happy to help show how to write the parser code for the
sub-node approach if you need it.

g.
