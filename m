Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2EKUbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:31:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:15055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab2EKUbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99104894"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH 3/3] Xen physical cpus interface
Thread-Topic: [Xen-devel] [PATCH 3/3] Xen physical cpus interface
Thread-Index: AQHNLr1B1b8pDRiwSFiwkpXixs4X8JbDIYNQgAHTcp+AABcXMA==
Date: Fri, 11 May 2012 20:31:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351BCD16@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
 <20120510145745.GO26152@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5A2E@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351B873F@SHSMSX101.ccr.corp.intel.com>
 <20120511142758.GA29677@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351BC88D@SHSMSX101.ccr.corp.intel.com>
 <20120511190041.GA3785@phenom.dumpdata.com>
In-Reply-To: <20120511190041.GA3785@phenom.dumpdata.com>
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
> On Fri, May 11, 2012 at 06:04:21PM +0000, Liu, Jinsong wrote:
>> Konrad Rzeszutek Wilk wrote:
>>> On Fri, May 11, 2012 at 01:12:13PM +0000, Liu, Jinsong wrote:
>>>> Liu, Jinsong wrote:
>>>>> Just notice your reply (so quick :)
>>>>> 
>>>>> Agree and will update later, except 1 concern below.
>>>>> 
>>>>> Konrad Rzeszutek Wilk wrote:
>>>>>>> 
>>>>>>> Hmm, it's good if it's convenient to do it automatically via
>>>>>>> dev->release. However, dev container (pcpu) would be free at
>>>>>>> some other error cases, so I prefer do it 'manually'.
>>>>>> 
>>>>>> You could also call pcpu_release(..) to do it manually.
>>>>>> 
>>>>> 
>>>>> that means kfree(pcpu) would be done twice at some error cases,
>>>>> do you think it really good? 
>>>>> 
>>>> 
>>>> Ping.
>>>> 
>>>> I think error recovery should be kept inside error logic level
>>>> itself, if try to recover upper level error would bring trouble.
>>>> 
>>>> In our example, there are 2 logic levels:
>>>> pcpu level (as container), and dev level (subfield used for sys)
>>> 
>>> So you need to untangle free_pcpu from doing both. Meaning one does
>>> the SysFS and the other deals with free-ing the structure and
>>> removing itself from the list.
>>> 
>> 
>> free_cpu is very samll, just consist of the 2 parts your said:
>> * pcpu_sys_remove() deal with sysfs
>> * list_del/kfree(pcpu) deal with pcpu
>> 
>>> 
>>>> dev->release should only recover error occurred at dev/sys level,
>>>> and the pcpu error should be recovered at pcpu level.
>>>> 
>>>> If dev->release try to recover its container pcpu level error, like
>>>> list_del/kfree(pcpu), it would make confusing. i.e., considering
>>>> pcpu_sys_create(), 2 error cases: device_register fail, and
>>>> device_create_file fail --> how can the caller decide kfree(pcpu)
>>>> or not?
>>> 
>>> Then you should free it manually. But you can do this by a wrapper
>>> function: 
>>> 
>>> __pcpu_release(..) {
>>> 	..
>>> 	/* Does the removing itself from the list and kfree the pcpu */ }
>>> pcpu_release(..) {
>>> 	struct pcpcu *p= container_of(..)
>>> 	__pcpu_release(p);
>>> }
>>> 
>>> dev->release = &pcpu_release;
>>> 
>> 
>> Too weird way. If we want to release dev itself it's good to use
>> dev->release, but for pcpu I doubt it. (consider the example I gave
>> --> why we create issue (it maybe solved in weird method I agree),
>> just for using dev->release?)  
>> 
>> In kernel many dev->release keep NULL.
>> An example of using dev->release is cpu/mcheck/mce.c -->
>> mce_device_release(), it *just* deal dev itself. 
> 
> OK? I am not sure what are we arguing here anymore?
> I think using 'kfree(pcpu)' on the error paths (as long as it is
> done before device_register) is OK. I think that seperating
> the SysFS deletion from the pcpu deletion should be done to
> avoid races. Perhaps the SysFS deletion function should also
> remove the pcpu from the list.

How about static array pcpu[NR_CPUS]?
It seems solve all issues we argued :)

Thanks,
Jinsong