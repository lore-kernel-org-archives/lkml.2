Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2LKKLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:11:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2LKKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:11:18 -0500
Date: Tue, 11 Dec 2012 19:10:42 +0900 (JST)
Message-Id: <20121211.191042.313387652.hdk@igel.co.jp>
To: laurent.pinchart@ideasonboard.com
Cc: lethal@linux-sh.org, magnus.damm@gmail.com, linux@arm.linux.org.uk,
        horms@verge.net.au, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, matsu@igel.co.jp, dhobsong@igel.co.jp
Subject: Re: [PATCH v4 1/2] iommu/shmobile: Add iommu driver for Renesas
 IPMMU modules
From: Hideki EIRAKU <hdk@igel.co.jp>
In-Reply-To: <3581114.cp3kRzV18i@avalon>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
	<1350290093-998-2-git-send-email-hdk@igel.co.jp>
	<3581114.cp3kRzV18i@avalon>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thank you for your comments.

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v4 1/2] iommu/shmobile: Add iommu driver for Renesas IPMMU modules
Date: Mon, 10 Dec 2012 16:55:58 +0100

> On Monday 15 October 2012 17:34:52 Hideki EIRAKU wrote:
>> This is the Renesas IPMMU driver and IOMMU API implementation.
>> 
>> The IPMMU module supports the MMU function and the PMB function.
> 
> That sentence make me believe that both MMU and PMB were supported by the 
> driver, as "module" often refers to Linux kernel modules in this context. 
> Maybe you could replace "module" by "hardware module".

OK,

>> The MMU function provides address translation by pagetable compatible with
>> ARMv6. The PMB function provides address translation including tile-linear
>> translation. This patch implements the MMU function.
>>
>> The iommu driver does not register a platform driver directly because:
>> - the register space of the MMU function and the PMB function
>>   have a common register (used for settings flush), so they should ideally
>>   have a way to appropriately share this register.
>> - the MMU function uses the IOMMU API while the PMB function does not.
>> - the two functions may be used independently.
>> 
>> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
>> ---
>>  arch/arm/mach-shmobile/Kconfig              |    6 +
>>  arch/arm/mach-shmobile/Makefile             |    3 +
>>  arch/arm/mach-shmobile/include/mach/ipmmu.h |   16 ++
>>  arch/arm/mach-shmobile/ipmmu.c              |  150 ++++++++++++
>>  drivers/iommu/Kconfig                       |   56 +++++
>>  drivers/iommu/Makefile                      |    1 +
>>  drivers/iommu/shmobile-iommu.c              |  352 ++++++++++++++++++++++++
>>  7 files changed, 584 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-shmobile/include/mach/ipmmu.h
>>  create mode 100644 arch/arm/mach-shmobile/ipmmu.c
>>  create mode 100644 drivers/iommu/shmobile-iommu.c
> 
> What is the reason for splitting the driver in two files ? Can't you put all 
> the code in drivers/iommu/shmobile-iommu.c ? Storing driver code in arch/* is 
> discouraged.

The reason is that I described in the above text. The PMB function is
completely different from the MMU function but both functions are on
the same IPMMU hardware module and sharing the register space. I think
that a driver using the PMB part which is not yet released should not
depend on the Linux's iommu interface, so I split the driver in two
files: the IPMMU platform driver part (in arch/arm/mach-shmobile/) and
Linux's iommu part (in drivers/iommu/).  For the IPMMU platform driver part,
do you have any suggestions other than arch/* where this should go? It is
a generic platform device.

>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 
>> USA
> 
> You can remove this last paragraph, we don't want to patch every file in the 
> kernel if the FSF moves to a new building :-)

OK, I will remove the paragraph.

>> +	for (dev = ipmmu_devices; dev; dev = dev->archdata.iommu) {
>> +		if (arm_iommu_attach_device(dev, iommu_mapping))
>> +			pr_err("arm_iommu_attach_device failed\n");
>> +	}
>> +err:
>> +	spin_unlock(&lock_add);
>> +	return 0;
>> +}
>> +
>> +void ipmmu_add_device(struct device *dev)
>> +{
>> +	spin_lock(&lock_add);
>> +	dev->archdata.iommu = ipmmu_devices;
>> +	ipmmu_devices = dev;
> 
> That looks a bit hackish to me. I'd like to suggest a different approach, that 
> would be compatible with supporting multiple IPMMU instances.
> 
> dev->archdata.iommu should point to a new sh_ipmmu_arch_data structure that 
> would contain an IPMMU name (const char *) and a pointer to a struct 
> shmobile_iommu_priv.
> 
> ipmmu_add_device() would take a new IPMMU name argument, allocate an 
> sh_ipmmu_arch_data instance dynamically and initialize its name field to the 
> name passed to the function. The shmobile_iommu_priv pointer would be set to 
> NULL. No other operation would be performed (you will likely get rid of the 
> global ipmmu_devices and iommu_mapping variables).
> 
> Then, the attach_dev operation handler would retrieve the dev->archdata.iommu 
> pointer, cast that to an sh_ipmmu_arch_data, and retrieve the IPMMU associated 
> with the name (either by walking a driver-global list of IPMMUs, or by using 
> driver_find_device()).
> 
> This mechanism would get rid of several global variables in the driver 
> (several of them would move to the shmobile_ipmmu_priv structure - which I 
> would have named shmobile_ipmmu or even sh_ipmmu, but that's up to you) and 
> add support for several IPMMU instances (there's 3 of them in the sh7372, even 
> if we only need to support one right now it's still a good practice to design 
> the driver in a way that multiple instances can be supported).
> 
> Could you try to rework the driiver in that direction ? You can have a look at 
> the OMAP IOMMU driver if you need sample code, and obviously feel free to 
> contact me if you have any question.

I agree about this is hackish. I don't mean to make an excuse, but I
could not find good sample code because no other drivers in the
upstream kernel use the arm_iommu_attach_device() API.

But I will try to modify the driver to support for several IPMMU
instances.

-- 
Hideki EIRAKU <hdk@igel.co.jp>
