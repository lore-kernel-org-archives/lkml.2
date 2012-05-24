Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2EXQPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:15:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:32278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2EXQPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147369952"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Index: AQHNOZg5bJSbBggbSyWVZxOOOr38ZpbZF9pg
Date: Thu, 24 May 2012 16:15:02 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
In-Reply-To: <20120524103023.GA27063@aftab.osrc.amd.com>
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

Borislav Petkov wrote:
> On Thu, May 24, 2012 at 10:10:34AM +0000, Liu, Jinsong wrote:
>>>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
>>>> Signed-off-by: Ke, Liping <liping.ke@intel.com>
>>>> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
>>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> 
>>> If you're sending the patch, you need to be the last on the
>>> SOB-chain and the SOB-chain has to show the proper path the patch
>>> took. See <Documentation/SubmittingPatches>.
> 
>> Thanks! I will update it. But I'm not quite clear 'the SOB-chain has
>> to show the proper path the patch took', would you elaborate more?
> 
> Section 12 in the SubmittingPatches readme has more or less an example
> about it, here's what I mean:
> 
> Signed-off-by: Initial Patch Author <ipa@example.com>
> Signed-off-by: Second Patch Author <spa@example.com>
> Signed-off-by: Third Patch Author <tpa@example.com>
> ...
> Signed-off-by: Patch Submitter <ps@example.com>
> 
> Some of the lines above may or may not be present depending on your
> case. If you're sending the patch, you're the last in chain so your
> SOB should be last.
> 
> That's what I mean with "proper path" the patch took, i.e. the SOB
> chain should show how exactly this patch was created and who handled
> it on its way upstream.
> 

Oh, I see your meaning now. Thanks for telling me kernel habit / culture about SOB. I will update accordingly.

> 
>>>> -static struct miscdevice mce_chrdev_device = {
>>>> +struct miscdevice mce_chrdev_device = {
>>>>  	MISC_MCELOG_MINOR,
>>>>  	"mcelog",
>>>>  	&mce_chrdev_ops,
>>> 
>>> You're still reusing those - pls, define your own 'struct miscdevice
>>> mce_chrdev_device' in drivers/xen/ or somewhere convenient and
>>> your own mce_chrdev_ops. The only thing you should be touching in
>>> arch/x86/.../mcheck/ is the export of MISC_MCELOG_MINOR.
>>> 
>>> Thanks.
>> 
>> I'm *not* reuse native code.
>> I have defined 'struct miscdevice xen_mce_chrdev_device' in
>> drivers/xen, and I also implement xen_mce_chrdev_ops, they are all
>> xen-self-contained.  
>> 
>> The patch just redirect native mce_chrdev_device to
>> xen_mce_chrdev_device when running under xen environment. 
>> It didn't change any native code (except just cancel
>> mce_chrdev_device 'static'), and will not break native logic. 
> 
> Why are you doing that?
> 
> Why don't you do
> 
> 	misc_register(&xen_mce_chrdev_device);
> 
> in xen_early_init_mcelog() ?
> 
> This way there'll be no arch/x86/ dependencies at all.

The reason is, if we do so, it would be covered by native misc_register(&mce_chrdev_device) later when native kernel init (xen init first and then start native kernel).
Under such case, if linux running under xen platform, /dev/mcelog point to vcpu, that's pointless since it cannot get any mcelog from physical cpu (which owned by xen).

Yes, we can use another misc device like /dev/xen-mcelog, w/ another device minor like 226, but that's not good for userspace mcelog tools. As far as I know, Novell mcelog use unified /dev/mcelog interface for linux running under either bare metal or xen platform.

This patch just do redirection at xen code path, and that would not hurt anything to native kernel.

Thanks,
Jinsong


