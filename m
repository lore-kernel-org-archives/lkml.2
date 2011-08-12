Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1HLD1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:27:47 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:58048 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab1HLD1q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:27:46 -0400
X-AuditID: 12074424-b7b0fae000000a08-7f-4e449dd722af
Message-ID: <20110811232735.u5qoybpr4gg8kckw@webmail.mit.edu>
Date: Thu, 11 Aug 2011 23:27:35 -0400
From: Adam M Belay <abelay@MIT.EDU>
To: Wang Shaoyan <stufever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] pnp: replace deprecated __check_region to
	request_region
References: <1312817901-5313-1-git-send-email-wangshaoyan.pt@taobao.com>
	<CAErSpo6Fh+zTMiSG+mjkNuA03cCEK7bej9y2oX+HfsScSYGFsw@mail.gmail.com>
	<CANxBZFrzmTDaUrmkGhKAVsZpXScEDxdJeBzcMbBjEW=6ozppGw@mail.gmail.com>
In-Reply-To: <CANxBZFrzmTDaUrmkGhKAVsZpXScEDxdJeBzcMbBjEW=6ozppGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.0.3)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsUixCmqpHt9roufQdcSQ4slTRkWy/f1M1pc
	3jWHzeLB/NOMFh8OHGZ2YPXYOesuu8eCTaUeS2c1sXt83iQXwBLFZZOSmpNZllqkb5fAlfHu
	/xvGgu3CFesfLGNqYNzP38XIySEhYCKx98QkVghbTOLCvfVsXYxcHEICOxklrm4+xQySEBLY
	wiix4WUJRGIHo8Tupy2sEM48RolXL05BOS2MEttfn2GGmBUp8fr0Q6hZhxgl2v8tAlvCK2Ar
	0X5wIzuIzSKgKvF49Uogm4ODTUBZ4ttjRRBTBCj8cYclSCuzwDRGiZ4nn1hB4sIC/hKf7kVB
	jLzGKNF47gALyBhOgSCJju+zmCHGC0qcnPkELM4s4Cjxt7eZDaSXWUBaYvk/DoiwtsSyha/B
	ykUFzCUe7N3BOIFRbBaS7llIumchdM9C0r2AkWUVo2xKbpVubmJmTnFqsm5xcmJeXmqRrrle
	bmaJXmpK6SZGUPSxu6jsYGw+pHSIUYCDUYmH9+Y/Zz8h1sSy4srcQ4ySHExKorx35rj4CfEl
	5adUZiQWZ8QXleakFgODjINZSYQ3eRZQjjclsbIqtSgfJiXNwaIkzmuz08FPSCA9sSQ1OzW1
	ILUIJivDwaEkwXtvKlCjYFFqempFWmZOCUKaiYMTZDgP0HCpuSDDiwsSc4sz0yHypxgVpcR5
	34BcJACSyCjNg+uFJcdXjOJArwjzeoC08wATK1z3K6DBTECD6+84gAwuSURISTUwujVWxE6b
	fP6Bwo9wjs35j48xGBcduWgiwuNc196Z9cD7irGT9dNv3Cydy7lY9628y7bg33ffuPZNz2Nr
	zdMeFZze9NBHysZc/xZbI1/AisUrQlqyfjWEbNFx1ol+nmFw81W/1OWs2WWVckJsf407Lzw4
	3hmi/+n8MqUTQffj87fOCjSSmFmtxFKckWioxVxUnAgA+fHuF2kDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

Yes, I think your description of the race condition is right. However, 
as Bjorn
mentioned, there are many x86 init paths that will try to reserve the same
resources as those reported by pnp/acpi. There needs to be a better way to
coordinate legacy device enumeration. Otherwise, the request_region() calls
could fail when there isn't an actual resource conflict.

IF we could find a good way to clean up the legacy users of request_region()
then we could probably make pnp behave more like pci with regard to resource
reservations.

Cheers,
Adam

Quoting Wang Shaoyan <stufever@gmail.com>:

> Hi
>
> 2011/8/12 Bjorn Helgaas <bhelgaas@google.com>:
>> We usually funnel PNP stuff through the linux-acpi@vger.kernel.org
>> mailing list, so I added a cc: to it.
>>
>
> Thanks for your reminding!
>
>> request_region() is not a drop-in replacement for __check_region()
>> because __check_region() releases the resource before it returns
>> success.  I agree that it would be good to get rid of
>> __check_region(), but I think it's a little more work than just this.
>>
>> I suppose you could just do the release_resource() in
>> pnp_check_port(), after request_region() was successful.  But the
>> problem with __check_region() is that it's racy, and moving the
>> release_resource() into pnp_check_port() doesn't remove the race.  It
>> just moves the problem from __check_region() (which is easy to grep
>> for) into PNP (where it's not so obvious).
>>
>
> I don't think the racy is still exist. In old days, the racy is exist
> in this situation:
> check_region()
> ...do something    <-- here another process may do check and request 
> same region
> request_region()   <-- if some process request the same resource, it
> will fail here
>
> But nowadays, request_region has replaced the check_region, it will
> check and request in the same function, so no racy still exist. Am I
> right?
>
>> Part of the problem is that the PNP core doesn't actually request any
>> of the resources used by PNP devices.  The PCI core *does* reserve
>> resources, independent of any drivers, and it would certainly be
>> reasonable to expect the PNP core to do the same, but it doesn't.
>> This is mostly because there are a bunch of hardcoded legacy resources
>> that conflict with PNP devices, and we haven't figured out a good way
>> to resolve the conflicts.
>>
>> Bjorn
>>
>
>
>
> --
> Wang Shaoyan
>


