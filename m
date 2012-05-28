Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2E1Ngu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:36:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:33519 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2E1Ngs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105056399"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: RE: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Topic: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Index: AQHNOqBYr6jLO/PX8Ee8ZH/5SHvSCZba1ybwgARWupA=
Date: Mon, 28 May 2012 13:36:45 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F4313@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
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

Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
>> On Fri, May 25, 2012 at 05:56:56PM +0000, Liu, Jinsong wrote:
>>> Konrad Rzeszutek Wilk wrote:
>>>>>>>>> -static struct miscdevice mce_chrdev_device = {
>>>>>>>>> +struct miscdevice mce_chrdev_device = {
>>>>>>>>>  	MISC_MCELOG_MINOR,
>>>>>>>>>  	"mcelog",
>>>>>>>>>  	&mce_chrdev_ops,
>>>>>>>> 
>>>>>>>> You're still reusing those - pls, define your own 'struct
>>>>>>>> miscdevice mce_chrdev_device' in drivers/xen/ or somewhere
>>>>>>>> convenient and your own mce_chrdev_ops. The only thing you
>>>>>>>> should be touching in arch/x86/.../mcheck/ is the export of
>>>>>>>> MISC_MCELOG_MINOR. 
>>>>>>>> 
>>>>>>>> Thanks.
>>>>>>> 
>>>>>>> I'm *not* reuse native code.
>>>>>>> I have defined 'struct miscdevice xen_mce_chrdev_device' in
>>>>>>> drivers/xen, and I also implement xen_mce_chrdev_ops, they are
>>>>>>> all xen-self-contained. 
>>>>>>> 
>>>>>>> The patch just redirect native mce_chrdev_device to
>>>>>>> xen_mce_chrdev_device when running under xen environment.
>>>>>>> It didn't change any native code (except just cancel
>>>>>>> mce_chrdev_device 'static'), and will not break native logic.
>>>>>> 
>>>>>> Why are you doing that?
>>>>>> 
>>>>>> Why don't you do
>>>>>> 
>>>>>> 	misc_register(&xen_mce_chrdev_device);
>>>>>> 
>>>>>> in xen_early_init_mcelog() ?
>>>>>> 
>>>>>> This way there'll be no arch/x86/ dependencies at all.
>>>>> 
>>>>> The reason is, if we do so, it would be covered by native
>>>>> misc_register(&mce_chrdev_device) later when native kernel init
>>>>> (xen init first and then start native kernel).
>>>> 
>>>> Won't the second registration (so the original one) of the major
>>>> fail? So the mce_log would just error out since somebody already
>>>> registered?
>>> 
>>> No, that would be device confliction, the 2nd register return as
>>> -EBUSY and un-predicetable result.
>> 
>> And the existing code does not actually check the 'misc_register'
>> return value? Ah yes. Perhaps then a fix to
>> arch/x86/kernel/cpu/mcheck/mce.c to do the proper de-registration if
>> 'misc_register' fails?
> 
> It's weird. From code point of view, it indeed not check return value
> so it should go silently. mce.c didn't do misc_deregister. 

Have a debug it, the root cause is, 
1). it does misc_register(&xen_mce_chrdev_device) at xen_early_init_mcelog(), it's very early stage (at xen_start_kernel), linux kernel and dd didn't start yet, so it fail to register xen_mce_chrdev_device.
2). After native start_kernel, native mce_chrdev_device registered successfully, then it point to *native* mcelog logic.

> 
>> 
>> Or just set 'mce_disabled=1' in the bootup of Xen, similar to
>> how lguest.c does it?

Have a look at lguest, it disable whole mce logic.
Xen dom0 cannot do so since we need keep dom0 mce logic to handle memory error which belong to dom0 (hypervisor will inject vMCE to dom0 in the case).


===================

Borislav and Konrad,

An approach which basically same as you suggested but w/ slightly update, is
1). at xen/mcelog.c, do misc_register(&xen_mce_chrdev_device) at xen_late_init_mcelog, define it as device_initcall(xen_late_init_mcelog) --> now linux dd ready, so xen mcelog divice would register successfully;
2). at native mce.c, change 1 line from device_initcall(mcheck_init_device) to device_initcall_sync(mcheck_init_device) --> so misc_register(&mce_chrdev_device) would be blocked by xen mcelog device;

I have draft test it and works fine.
Thought?

Thanks,
Jinsong
