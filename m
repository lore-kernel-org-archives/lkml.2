Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1DNMEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:04:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43393 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1DNMEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xpcyDGrtGzZSbfL9eUpsRxm1/Wc9Kg/ITvbWsoIC9gbp+CU2zukbKW8k3o6SlszI0R
         PjvFnSVuPfc7/5H7cJcpMRJTupEDIo3wolq2F490cOaeaYLHFLJKQyKD6DgYyYaG2p9k
         9up6qW0BKhunIgT9QLfFjTovRGD0x7139mx4Q=
MIME-Version: 1.0
In-Reply-To: <1302781431.21145.6.camel@dev.znau.edu.ua>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<1302781431.21145.6.camel@dev.znau.edu.ua>
Date: Thu, 14 Apr 2011 14:04:05 +0200
Message-ID: <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 14 kwietnia 2011 13:43 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
>> We have slightly improved our knowledge of new Broadcom's bus. It
>> appears Broadcom took standard AMBA bus and put on it two cores for
>> every device:
>> 1) First core from each pair is real AMBA device, it has CID and PID.
>> Broadcom called it wrapper, it is used to control second core
>> (enabling second, disabling second, resetting second, setting flags of
>> second).
>> 2) Second core from each pair is Broadcom specific device. It can
>> *not* be treated as standard AMBA core - attempting to read it's CID
>> on PID leads to machine hang. Instead it is identified by MANUF, ID,
>> REV and CLASS. Example can be 80211 core.
>>
>> One of the idea is to integrate with current AMBA driver:
>> 1) First driver read info about all cores in Broadcom specific way. It
>> registers all *wrapper* (AMBA type) cores as amba_device(s).
>> 2) Second driver registers for cores with PID 0x103BB369 (Broadcom
>> specific I believe). It receives wrappers (from AMBA bus) and exposes
>> wrapper-related Broadcom specific core in the system.
>>
>> Problem: how to expose Broadcom specific cores in the system? Remember
>> we can not use amba_device, because Broadcom specific cores are
>> programmed and identified differently.
>>
>> Could we register some virtual bcm_amba bus in the system and register
>> Broadcom specific cores with it? Or is there something better for this
>> case? In summary everything I need is to make driver (for example b43)
>> able to register for Broadcom specific core with Broadcom specific
>> identifiers. For example:
>> static const struct axi_device_id b43_axi_tbl[] = {
>>       AXI_CORE(AXI_MANUF_BCM, AXI_CORE_80211, 0x17, AXI_ANY_CLASS),
>>       AXI_CORETABLE_END
>> };
>> MODULE_DEVICE_TABLE(axi, b43_axi_tbl);
>>
>> We have problems deciding architecture, the whole proposed layout is
>> not approved as final yet. Right now I try to check possibilities.
>>
> If you beleive you do need to register broadcom ip core devices on amba
> bus then I would suggest you to introduce class driver for broadcom
> cores rather than breaking into bus_type layout. But to be honest I
> think it is bad idea and your original approach where you managed agents
> internally and registered _broadcom_ devices on dedicated _broadcom_ bus
> have much more sense. Going your original way you still can also
> register agents on amba thus registering two buses per host but honestly
> registering them just for the sake of registering makes no sense at all.

I think you may be right, but we got so messed with so many ideas we
need to clean this out. Our old ideas:
1) Extending ssb
2) Separated library (brcmaxi)
3) Broadcom specific bus (bcmai)
4) AMBA AXI bus (axi)
5) Integrating with drivers/amba

I simply decide to consider every idea seriously and decide which will
fit our needs the best way.

Hauke: you were proposing integrating with drivers/amba. I really
expect you to comment on this, please tell us how do you see this now,
when we have better overview. I took your proposal seriously, you can
see the results above.

I think I agree with George that in proposed architecture we are using
drivers/amba just for the idea of using it. We don't get anything from
it, we don't provide anything to it that could be used anywhere else.
I think we should simply take the last version of my patch, rename it
to bcmamba, fix last issues and commit. It looks we use almos nothing
AMBA specific in your driver.

But as I said, I treat every proposal seriously. So please share your
minds Hauke & others.

-- 
Rafał
