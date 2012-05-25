Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2EYS4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:56:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:17979 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab2EYS4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104384695"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Topic: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Index: AQHNOqBYr6jLO/PX8Ee8ZH/5SHvSCZba1ybw
Date: Fri, 25 May 2012 18:55:24 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F0D42@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
In-Reply-To: <20120525180102.GA27280@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Fri, May 25, 2012 at 05:56:56PM +0000, Liu, Jinsong wrote:
>> Konrad Rzeszutek Wilk wrote:
>>>>>>>> -static struct miscdevice mce_chrdev_device = {
>>>>>>>> +struct miscdevice mce_chrdev_device = {
>>>>>>>>  	MISC_MCELOG_MINOR,
>>>>>>>>  	"mcelog",
>>>>>>>>  	&mce_chrdev_ops,
>>>>>>> 
>>>>>>> You're still reusing those - pls, define your own 'struct
>>>>>>> miscdevice mce_chrdev_device' in drivers/xen/ or somewhere
>>>>>>> convenient and your own mce_chrdev_ops. The only thing you
>>>>>>> should be touching in arch/x86/.../mcheck/ is the export of
>>>>>>> MISC_MCELOG_MINOR. 
>>>>>>> 
>>>>>>> Thanks.
>>>>>> 
>>>>>> I'm *not* reuse native code.
>>>>>> I have defined 'struct miscdevice xen_mce_chrdev_device' in
>>>>>> drivers/xen, and I also implement xen_mce_chrdev_ops, they are
>>>>>> all xen-self-contained. 
>>>>>> 
>>>>>> The patch just redirect native mce_chrdev_device to
>>>>>> xen_mce_chrdev_device when running under xen environment.
>>>>>> It didn't change any native code (except just cancel
>>>>>> mce_chrdev_device 'static'), and will not break native logic.
>>>>> 
>>>>> Why are you doing that?
>>>>> 
>>>>> Why don't you do
>>>>> 
>>>>> 	misc_register(&xen_mce_chrdev_device);
>>>>> 
>>>>> in xen_early_init_mcelog() ?
>>>>> 
>>>>> This way there'll be no arch/x86/ dependencies at all.
>>>> 
>>>> The reason is, if we do so, it would be covered by native
>>>> misc_register(&mce_chrdev_device) later when native kernel init
>>>> (xen init first and then start native kernel).
>>> 
>>> Won't the second registration (so the original one) of the major
>>> fail? So the mce_log would just error out since somebody already
>>> registered?
>> 
>> No, that would be device confliction, the 2nd register return as
>> -EBUSY and un-predicetable result. 
> 
> And the existing code does not actually check the 'misc_register'
> return value? Ah yes. Perhaps then a fix to
> arch/x86/kernel/cpu/mcheck/mce.c to do the proper de-registration if
> 'misc_register' fails? 

It's weird. From code point of view, it indeed not check return value so it should go silently. mce.c didn't do misc_deregister.

> 
> Or just set 'mce_disabled=1' in the bootup of Xen, similar to
> how lguest.c does it?
> 
>> I test it in your way, mcelog fail to fetch any error log.
> 
> And that is b/c of? What exactly?

I don't know exactly what's the reason, but test again still fail.

Thanks,
Jinsong


