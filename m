Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0IHHQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:16:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60705 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab0IHHQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ws/gIWNK0TyxxLGebo3dF8dU+wPBL7fu7pRlgAKuk3JFWd8xfH3Oj0bD3Iaml7M/4v
         LfcBOsemA7fGCxs5/oHXs34TDdJZAk9RVKuUuTdP9RuVf5kxBchLAItNLu1sUMU8RvPw
         aHiU1RQ5UPZDrwe2igrZGIXKMz9u1OmYsTlQo=
Message-ID: <4C87385B.1000101@gmail.com>
Date: Wed, 08 Sep 2010 09:16:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: xgifb: Initialize uninitialized variables
References: <1283837645.6302.10.camel@lenovo> <4C85FBE3.4000605@gmail.com> <20100908003821.GC27719@suse.de>
In-Reply-To: <20100908003821.GC27719@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 02:38 AM, Greg KH wrote:
> On Tue, Sep 07, 2010 at 10:46:27AM +0200, Jiri Slaby wrote:
>> On 09/07/2010 07:34 AM, Javier Martinez Canillas wrote:
>>> Current patch solves compilation warnings in staging/xgifb for using possibly uninitialized variables.
>>>
>>> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
>>> ---
>>>  drivers/staging/xgifb/vb_setmode.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
>>> index c4db2fc..720a592 100644
>>> --- a/drivers/staging/xgifb/vb_setmode.c
>>> +++ b/drivers/staging/xgifb/vb_setmode.c
>>> @@ -376,7 +376,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
>>>  unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
>>>  			unsigned short ModeNo)
>>>  {
>>> -	unsigned short ModeIdIndex;
>>> +	unsigned short ModeIdIndex = 0;
>>>  	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
>>>  	struct vb_device_info VBINF;
>>>  	struct vb_device_info *pVBInfo = &VBINF;
>>
>> No, please don't. This is a compiler bug.
>>
>> The first use in that function is:
>> XGI_SearchModeID( ModeNo , &ModeIdIndex, pVBInfo );
>>
>> and that function contains:
>> if (XYZ) {
>>   for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
>>     ...
>> } else {
>>   for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
>>     ...
>> }
>>
>> So your compiler is foolish if that emits a warning.
> 
> No, I don't see a way that the compiler could really figure that type of
> logic out.  It doesn't know that XGI_SearchModeID() always will set that
> field.  Heck, at first glance I couldn't even figure it out :)

No, the compiler could. Trust me :). Actually you've just hidden a bug
in XGI_SearchModeID. There is #ifdef LINUX and LINUX is defined in
main.h. But that file is not included in vb_setmode.c. Hence the
uninitialized warnings...

> So I don't mind applying this patch, as I'll just constantly keep
> getting people sending me the same change, when they could be off
> working on other things that this driver needs.

So instead of hiding bugs, please fix the right ones.

thanks,
-- 
js
