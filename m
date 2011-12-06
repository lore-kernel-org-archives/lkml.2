Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab1LFJTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:19:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:59175 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab1LFJTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:19:30 -0500
Message-ID: <4EDDDE1C.1080106@linutronix.de>
Date: Tue, 06 Dec 2011 10:19:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org,
        Jerome Martin <jxm@risingtidesystems.com>
Subject: Re: [RFC] UASP on target
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>	 <20111205082047.GA2423@linutronix.de> <20111205082326.GA2734@linutronix.de> <1323157244.25982.44.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1323157244.25982.44.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 08:40 AM, Nicholas A. Bellinger wrote:
> Hi Sebastian,

Hi Nicholas,

> So this looks like a reasonable first step to get a control plane up
> for /sys/kernel/config/target/uasp/.  I have not at the USB parts beyond
> the initial patch so I can't really comment there, but thanks for using
> tcm_mod_builder.py to generate your initial skeleton.

Thanks for providing the skeleton building script :)
I don't have more yet. Storage on USB should provide two
configurations: BOT and UASP. BOT is currently served by drivers/usb
/gadget/mass_storage.c. The configuration (modprobe parameters) and
protocol handling is done there. Since UASP brings its own
configuration I think that it will be too complicated to merge both
code basis (not to mention the way both handling things internally). So
I decided first to integrate UASP with target and then worry about BOT.

> Just a minor few comments below on the target-related pieces below, and
> a few comments to keep in mind for he main I/O path with struct
> uasp_cmd->se_cmd descriptor usage.
>
>> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
>> index e66fcc7..64d3204 100644
>> --- a/drivers/target/Kconfig
>> +++ b/drivers/target/Kconfig
>> @@ -50,3 +50,4 @@ source "drivers/target/tcm_qla2xxx/Kconfig"
>>   source "drivers/target/tcm_vhost/Kconfig"
>>
>>   endif
>> +source "drivers/target/uasp/Kconfig"
>> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
>> index 1945dba..b1135d5 100644
>> --- a/drivers/target/Makefile
>> +++ b/drivers/target/Makefile
>> @@ -28,3 +28,4 @@ obj-$(CONFIG_TCM_FC)		+= tcm_fc/
>>   obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
>>   obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx/
>>   obj-$(CONFIG_TCM_VHOST)		+= tcm_vhost/
>> +obj-$(CONFIG_TARGET_UASP)	+= uasp/
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index f7cb64f..127496a 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -162,6 +162,13 @@ static struct config_group *target_core_register_fabric(
>>   				" tcm_loop.ko: %d\n", ret);
>>   			return ERR_PTR(-EINVAL);
>>   		}
>> +	} else if (!strncmp(name, "uasp", 4)) {
>> +		ret = request_module("tcm_uasp");
>> +		if (ret<  0) {
>> +			pr_err("request_module() failed for"
>> +				" tcm_loop.ko: %d\n", ret);
>> +			return ERR_PTR(-EINVAL);
>> +		}
>>   	}
>>
>>   	tf = target_core_get_fabric(name);
>
> So making the request_module() calls was an original feature of v3.x
> target core code, but this is not strictly required for normal usage
> after loading the module, or with rtslib /var/target/spec/uasp.spec
> usage.
I see.

> As we are trying to avoid extra request_module() usage in target-core,
> please go ahead and drop this part for now..

Okay.

>> diff --git a/drivers/target/uasp/uasp_configfs.c b/drivers/target/uasp/uasp_configfs.c
>> new file mode 100644
>> index 0000000..7f6b280
>> --- /dev/null
>> +++ b/drivers/target/uasp/uasp_configfs.c
>> @@ -0,0 +1,333 @@
>> +#include<linux/module.h>
>> +#include<linux/moduleparam.h>
>> +#include<linux/version.h>
>> +#include<generated/utsrelease.h>
>> +#include<linux/utsname.h>
>> +#include<linux/init.h>
>> +#include<linux/slab.h>
>> +#include<linux/kthread.h>
>> +#include<linux/types.h>
>> +#include<linux/string.h>
>> +#include<linux/configfs.h>
>> +#include<linux/ctype.h>
>> +#include<asm/unaligned.h>
>> +
>> +#include<target/target_core_base.h>
>> +#include<target/target_core_fabric.h>
>> +#include<target/target_core_fabric_configfs.h>
>> +#include<target/target_core_configfs.h>
>> +#include<target/configfs_macros.h>
>> +
>> +#include "uasp_base.h"
>> +#include "uasp_fabric.h"
>> +#include "gadget_ops.h"
>> +
>> +/* Local pointer to allocated TCM configfs fabric module */
>> +struct target_fabric_configfs *uasp_fabric_configfs;
>> +
>> +static const char *uasp_check_wwn(const char *name)
>> +{
>> +	const char *n;
>> +	unsigned int len;
>> +
>> +	n = strstr(name, "naa.");
>> +	if (!n)
>> +		return NULL;
>> +	n += 4;
>> +	len = strlen(n);
>> +	if (len == 0 || len>  UASP_NAMELEN - 1)
>> +		return NULL;
>> +	return n;
>> +}
>> +
>
> Note this is currently using naa. prefixed targetnames for UASP
> endpoints, as loopback does with SAS proto_id port emulation..

Not sure if this is the right thing to do. I've seen it in loop and
vhost that once "naa." has been found, the protocol was set to SAS.
I think I have to use SAS so I am using the same prefix here.

>> +int uasp_register_configfs(void)
>> +{
>> +	struct target_fabric_configfs *fabric;
>> +	int ret;
>> +
>> +	printk(KERN_INFO "UASP fabric module %s on %s/%s"
>> +		" on "UTS_RELEASE"\n",UASP_VERSION, utsname()->sysname,
>> +		utsname()->machine);
>> +	/*
>> +	 * Register the top level struct config_item_type with TCM core
>> +	 */
>> +	fabric = target_fabric_configfs_init(THIS_MODULE, "uasp");
>> +	if (!(fabric)) {
>> +		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
>> +		return -ENOMEM;
>> +	}
>
> This should be checking using IS_ERR() with fabric, which is a current
> bug in tcm_mod_builder.py

Okay, will fix in both.

> <SNIP>
>
> So for the primary incoming I/O path, you'll want to be using the new
> target_submit_cmd() call that we've been working on in
> lio-core.git/qla_tgt-3.3 recently, as this will simplify incoming I/O +
> exception handling for struct uasp_cmd from processing context usage.

Okay, will look at that.

> Also, do you expect this new driver to pass pre-populated scatterlists,
> or to leave se_cmd->t_data_sg allocation up to target-core..?  Depending
> on the expected usage this will look slightly different from the current
> usage in tcm_loop/tcm_vhost that both pass pre-populated scatterlists
> from Linux/SCSI.

USB has IN and OUT packets. OUT packets are sent by the HOST (received 
by the UDC or device and IN packets are received by the host and ..... 
OUT and IN is always seen / described from HOST's point of view. That 
means USB-OUT packet for the device is "receive-data".
I have to queue an USB-OUT packet for the endpoint that receives the
command. For that I have to allocate memory. That means cdb + sense can
be part of that. For both I don't know the exact size. For cdb I
allocate maxpacket size (that is 512 bytes for high speed and 1024
bytes for super speed) memory and I receive the size, the host sent to
me.
For DATA-IN/OUT transfers I think it would be easier to let the core
allocate the memory. After all I don't know the exact size of the
transfer. We don't have scatterlist support on the gadget framework yet
but Felipe is looking into. So sgl is perfect, will provide a buffer
fallback and people may udpate their drivers if it is too slow :)

> Aside from that, let me know if you have questions while filling in the
> write_pending and response (queue_data_in + queue_status) fabric
> callbacks.

Thanks for that. Once I have something I try to come up with a sane
question :)

> Thanks!
>
> --nab

Sebastian
