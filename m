Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2EXKKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:10:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:2009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2EXKKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:10:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147220751"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Index: AQHNN/ybbJSbBggbSyWVZxOOOr38ZpbYtUrg
Date: Thu, 24 May 2012 10:10:34 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
In-Reply-To: <20120522092354.GB18578@aftab.osrc.amd.com>
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
> On Tue, May 22, 2012 at 05:45:04AM +0000, Liu, Jinsong wrote:
>> From 4df7496eea9e92a3e267ffb0a4b8f5e6e0c29c36 Mon Sep 17 00:00:00
>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Mon, 21 May 2012 05:07:47 +0800
>> Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform
>> 
>> When MCA error occurs, it would be handled by Xen hypervisor first,
>> and then the error information would be sent to initial domain for
>> logging. 
>> 
>> This patch gets error information from Xen hypervisor and convert
>> Xen format error into Linux format mcelog. This logic is basically
>> self-contained, not touching other kernel components.
>> 
>> By using tools like mcelog tool users could read specific error
>> information, 
>> like what they did under native Linux.
>> 
>> To test follow directions outlined in
>> Documentation/acpi/apei/einj.txt 
>> 
>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
>> Signed-off-by: Ke, Liping <liping.ke@intel.com>
>> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> If you're sending the patch, you need to be the last on the SOB-chain
> and the SOB-chain has to show the proper path the patch took. See
> <Documentation/SubmittingPatches>.

Thanks! I will update it.
But I'm not quite clear 'the SOB-chain has to show the proper path the patch took', would you elaborate more?

> 
>> ---
>>  arch/x86/include/asm/xen/hypercall.h |    8 +
>>  arch/x86/kernel/cpu/mcheck/mce.c     |    4 +-
>>  arch/x86/xen/enlighten.c             |    9 +-
>>  drivers/xen/Kconfig                  |    8 +
>>  drivers/xen/Makefile                 |    1 +
>>  drivers/xen/mcelog.c                 |  395
>>  ++++++++++++++++++++++++++++++++++ include/linux/miscdevice.h      
>>  |    1 + include/xen/interface/xen-mca.h      |  389
>>  +++++++++++++++++++++++++++++++++ 8 files changed, 809
>>  insertions(+), 6 deletions(-) create mode 100644
>>  drivers/xen/mcelog.c create mode 100644
>> include/xen/interface/xen-mca.h 
>> 
>> diff --git a/arch/x86/include/asm/xen/hypercall.h
>> b/arch/x86/include/asm/xen/hypercall.h index 5728852..59c226d 100644
>> --- a/arch/x86/include/asm/xen/hypercall.h +++
>> b/arch/x86/include/asm/xen/hypercall.h @@ -48,6 +48,7 @@
>>  #include <xen/interface/sched.h>
>>  #include <xen/interface/physdev.h>
>>  #include <xen/interface/platform.h>
>> +#include <xen/interface/xen-mca.h>
>> 
>>  /*
>>   * The hypercall asms have to meet several constraints:
>> @@ -302,6 +303,13 @@ HYPERVISOR_set_timer_op(u64 timeout)  }
>> 
>>  static inline int
>> +HYPERVISOR_mca(struct xen_mc *mc_op)
>> +{
>> +	mc_op->interface_version = XEN_MCA_INTERFACE_VERSION;
>> +	return _hypercall1(int, mca, mc_op);
>> +}
>> +
>> +static inline int
>>  HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)  {
>>  	platform_op->interface_version = XENPF_INTERFACE_VERSION;
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
>> b/arch/x86/kernel/cpu/mcheck/mce.c 
>> index d086a09..24b2e86 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -57,8 +57,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
>> 
>>  int mce_disabled __read_mostly;
>> 
>> -#define MISC_MCELOG_MINOR	227
>> -
>>  #define SPINUNIT 100	/* 100ns */
>> 
>>  atomic_t mce_entry;
>> @@ -1791,7 +1789,7 @@ static const struct file_operations
>>  mce_chrdev_ops = {  	.llseek			= no_llseek, };
>> 
>> -static struct miscdevice mce_chrdev_device = {
>> +struct miscdevice mce_chrdev_device = {
>>  	MISC_MCELOG_MINOR,
>>  	"mcelog",
>>  	&mce_chrdev_ops,
> 
> You're still reusing those - pls, define your own 'struct miscdevice
> mce_chrdev_device' in drivers/xen/ or somewhere convenient and
> your own mce_chrdev_ops. The only thing you should be touching in
> arch/x86/.../mcheck/ is the export of MISC_MCELOG_MINOR.
> 
> Thanks.

I'm *not* reuse native code.
I have defined 'struct miscdevice xen_mce_chrdev_device' in drivers/xen, and I also implement xen_mce_chrdev_ops, they are all xen-self-contained.

The patch just redirect native mce_chrdev_device to xen_mce_chrdev_device when running under xen environment.
It didn't change any native code (except just cancel mce_chrdev_device 'static'), and will not break native logic.

The benefit is, userspace tools like mcelog can use the unified interface (/dev/mcelog) to get mcelog, no matter it running under bare metal or xen virtual platform.

Thanks,
Jinsong