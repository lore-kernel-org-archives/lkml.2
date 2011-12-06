Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab1LFHk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:40:57 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:38813 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab1LFHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:40:55 -0500
Subject: Re: [RFC] UASP on target (was: [RFC/PATCH v4 1/3] uas: MS UAS
 Gadget driver - Infrastructure)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org,
        Jerome Martin <jxm@risingtidesystems.com>
In-Reply-To: <20111205082326.GA2734@linutronix.de>
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
	 <20111205082047.GA2423@linutronix.de> <20111205082326.GA2734@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 23:40:44 -0800
Message-ID: <1323157244.25982.44.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 09:23 +0100, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
> 
> >* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
> >
> >>This patch implements the infrastructure for the UAS gadget driver.
> >>The UAS gadget driver registers as a second configuration of the MS
> >>gadet driver.
> >hch said to use target framework and you haven't done so. This is what I
> >have so far. It is not yet complete. What I need to do is:
> >- wire up command processing (currently here)
> >- wire up data processing
> >- check it works => post v1
> >- wire up command tagging => v2
> >- remove hard codings and fix whatever people complained about.
> 

Hi Sebastian,

So this looks like a reasonable first step to get a control plane up
for /sys/kernel/config/target/uasp/.  I have not at the USB parts beyond
the initial patch so I can't really comment there, but thanks for using
tcm_mod_builder.py to generate your initial skeleton.  

Just a minor few comments below on the target-related pieces below, and
a few comments to keep in mind for he main I/O path with struct
uasp_cmd->se_cmd descriptor usage.

> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> index e66fcc7..64d3204 100644
> --- a/drivers/target/Kconfig
> +++ b/drivers/target/Kconfig
> @@ -50,3 +50,4 @@ source "drivers/target/tcm_qla2xxx/Kconfig"
>  source "drivers/target/tcm_vhost/Kconfig"
>  
>  endif
> +source "drivers/target/uasp/Kconfig"
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 1945dba..b1135d5 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -28,3 +28,4 @@ obj-$(CONFIG_TCM_FC)		+= tcm_fc/
>  obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
>  obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx/
>  obj-$(CONFIG_TCM_VHOST)		+= tcm_vhost/
> +obj-$(CONFIG_TARGET_UASP)	+= uasp/
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f7cb64f..127496a 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -162,6 +162,13 @@ static struct config_group *target_core_register_fabric(
>  				" tcm_loop.ko: %d\n", ret);
>  			return ERR_PTR(-EINVAL);
>  		}
> +	} else if (!strncmp(name, "uasp", 4)) {
> +		ret = request_module("tcm_uasp");
> +		if (ret < 0) {
> +			pr_err("request_module() failed for"
> +				" tcm_loop.ko: %d\n", ret);
> +			return ERR_PTR(-EINVAL);
> +		}
>  	}
>  
>  	tf = target_core_get_fabric(name);

So making the request_module() calls was an original feature of v3.x
target core code, but this is not strictly required for normal usage
after loading the module, or with rtslib /var/target/spec/uasp.spec
usage.

As we are trying to avoid extra request_module() usage in target-core,
please go ahead and drop this part for now..

> diff --git a/drivers/target/uasp/Kconfig b/drivers/target/uasp/Kconfig
> new file mode 100644
> index 0000000..0d48a58
> --- /dev/null
> +++ b/drivers/target/uasp/Kconfig
> @@ -0,0 +1,6 @@
> +config TARGET_UASP
> +	tristate "UASP fabric module"
> +	depends on TARGET_CORE && CONFIGFS_FS
> +	depends on USB_GADGET
> +	---help---
> +	Say Y here to enable the UASP fabric module
> diff --git a/drivers/target/uasp/Makefile b/drivers/target/uasp/Makefile
> new file mode 100644
> index 0000000..25883ab
> --- /dev/null
> +++ b/drivers/target/uasp/Makefile
> @@ -0,0 +1,5 @@
> +CFLAGS_gadget.o			:= -I$(srctree)/drivers/usb/gadget
> +tcm_uasp-objs			:= uasp_fabric.o \
> +					gadget.o \
> +					   uasp_configfs.o
> +obj-$(CONFIG_TARGET_UASP)	+= tcm_uasp.o
> diff --git a/drivers/target/uasp/gadget.c b/drivers/target/uasp/gadget.c
> new file mode 100644

<SNIP>

> diff --git a/drivers/target/uasp/uasp_configfs.c b/drivers/target/uasp/uasp_configfs.c
> new file mode 100644
> index 0000000..7f6b280
> --- /dev/null
> +++ b/drivers/target/uasp/uasp_configfs.c
> @@ -0,0 +1,333 @@
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/version.h>
> +#include <generated/utsrelease.h>
> +#include <linux/utsname.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/kthread.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/configfs.h>
> +#include <linux/ctype.h>
> +#include <asm/unaligned.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_fabric.h>
> +#include <target/target_core_fabric_configfs.h>
> +#include <target/target_core_configfs.h>
> +#include <target/configfs_macros.h>
> +
> +#include "uasp_base.h"
> +#include "uasp_fabric.h"
> +#include "gadget_ops.h"
> +
> +/* Local pointer to allocated TCM configfs fabric module */
> +struct target_fabric_configfs *uasp_fabric_configfs;
> +
> +static const char *uasp_check_wwn(const char *name)
> +{
> +	const char *n;
> +	unsigned int len;
> +
> +	n = strstr(name, "naa.");
> +	if (!n)
> +		return NULL;
> +	n += 4;
> +	len = strlen(n);
> +	if (len == 0 || len > UASP_NAMELEN - 1)
> +		return NULL;
> +	return n;
> +}
> +

Note this is currently using naa. prefixed targetnames for UASP
endpoints, as loopback does with SAS proto_id port emulation..

> +int uasp_register_configfs(void)
> +{
> +	struct target_fabric_configfs *fabric;
> +	int ret;
> +
> +	printk(KERN_INFO "UASP fabric module %s on %s/%s"
> +		" on "UTS_RELEASE"\n",UASP_VERSION, utsname()->sysname,
> +		utsname()->machine);
> +	/*
> +	 * Register the top level struct config_item_type with TCM core
> +	 */
> +	fabric = target_fabric_configfs_init(THIS_MODULE, "uasp");
> +	if (!(fabric)) {
> +		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
> +		return -ENOMEM;
> +	}

This should be checking using IS_ERR() with fabric, which is a current
bug in tcm_mod_builder.py

> +	/*
> +	 * Setup fabric->tf_ops from our local uasp_ops
> +	 */
> +	fabric->tf_ops = uasp_ops;
> +	/*
> +	 * Setup default attribute lists for various fabric->tf_cit_tmpl
> +	 */
> +	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = uasp_wwn_attrs;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = uasp_base_attrs;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
> +	/*
> +	 * Register the fabric for use within TCM
> +	 */
> +	ret = target_fabric_configfs_register(fabric);
> +	if (ret < 0) {
> +		printk(KERN_ERR "target_fabric_configfs_register() failed"
> +				" for UASP\n");
> +		return ret;
> +	}
> +	/*
> +	 * Setup our local pointer to *fabric
> +	 */
> +	uasp_fabric_configfs = fabric;
> +	printk(KERN_INFO "UASP[0] - Set fabric -> uasp_fabric_configfs\n");
> +	return 0;
> +};
> +
> +void uasp_deregister_configfs(void)
> +{
> +	if (!(uasp_fabric_configfs))
> +		return;
> +
> +	target_fabric_configfs_deregister(uasp_fabric_configfs);
> +	uasp_fabric_configfs = NULL;
> +	printk(KERN_INFO "UASP[0] - Cleared uasp_fabric_configfs\n");
> +};

> diff --git a/drivers/target/uasp/uasp_fabric.c b/drivers/target/uasp/uasp_fabric.c
> new file mode 100644
> index 0000000..304c934
> --- /dev/null
> +++ b/drivers/target/uasp/uasp_fabric.c
> @@ -0,0 +1,287 @@
> +#include <linux/slab.h>
> +#include <linux/kthread.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <asm/unaligned.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/libfc.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_fabric.h>
> +#include <target/target_core_configfs.h>
> +
> +#include "uasp_base.h"
> +#include "uasp_fabric.h"
> +
> +int uasp_check_true(struct se_portal_group *se_tpg)
> +{
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return 1;
> +}
> +
> +int uasp_check_false(struct se_portal_group *se_tpg)
> +{
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return 0;
> +}
> +
> +char *uasp_get_fabric_name(void)
> +{
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return "uasp";
> +}
> +
> +u8 uasp_get_fabric_proto_ident(struct se_portal_group *se_tpg)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	struct uasp_tport *tport = tpg->tport;
> +	u8 proto_id;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +	default:
> +		proto_id = sas_get_fabric_proto_ident(se_tpg);
> +		break;
> +	}
> +
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return proto_id;
> +}
> +
> +char *uasp_get_fabric_wwn(struct se_portal_group *se_tpg)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	struct uasp_tport *tport = tpg->tport;
> +
> +	printk(KERN_ERR "%s(%d) '%s'\n", __func__, __LINE__, tport->tport_name);
> +	return &tport->tport_name[0];
> +}
> +
> +u16 uasp_get_tag(struct se_portal_group *se_tpg)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	printk(KERN_ERR "%s(%d) %d\n", __func__, __LINE__, tpg->tport_tpgt);
> +	return tpg->tport_tpgt;
> +}
> +
> +u32 uasp_get_default_depth(struct se_portal_group *se_tpg)
> +{
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return 1;
> +}
> +
> +u32 uasp_get_pr_transport_id(
> +	struct se_portal_group *se_tpg,
> +	struct se_node_acl *se_nacl,
> +	struct t10_pr_registration *pr_reg,
> +	int *format_code,
> +	unsigned char *buf)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	struct uasp_tport *tport = tpg->tport;
> +	int ret = 0;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +	default:
> +		ret = sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
> +					format_code, buf);
> +		break;
> +	}
> +
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return ret;
> +}
> +
> +u32 uasp_get_pr_transport_id_len(
> +	struct se_portal_group *se_tpg,
> +	struct se_node_acl *se_nacl,
> +	struct t10_pr_registration *pr_reg,
> +	int *format_code)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	struct uasp_tport *tport = tpg->tport;
> +	int ret = 0;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +	default:
> +		ret = sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
> +					format_code);
> +		break;
> +	}
> +
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return ret;
> +}
> +
> +char *uasp_parse_pr_out_transport_id(
> +	struct se_portal_group *se_tpg,
> +	const char *buf,
> +	u32 *out_tid_len,
> +	char **port_nexus_ptr)
> +{
> +	struct uasp_tpg *tpg = container_of(se_tpg,
> +				struct uasp_tpg, se_tpg);
> +	struct uasp_tport *tport = tpg->tport;
> +	char *tid = NULL;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SAS:
> +	default:
> +		tid = sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
> +					port_nexus_ptr);
> +	}
> +
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return tid;
> +}
> +
> +struct se_node_acl *uasp_alloc_fabric_acl(struct se_portal_group *se_tpg)
> +{
> +	struct uasp_nacl *nacl;
> +
> +	nacl = kzalloc(sizeof(struct uasp_nacl), GFP_KERNEL);
> +	if (!(nacl)) {
> +		printk(KERN_ERR "Unable to alocate struct uasp_nacl\n");
> +		return NULL;
> +	}
> +
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	return &nacl->se_node_acl;
> +}
> +
> +void uasp_release_fabric_acl(
> +	struct se_portal_group *se_tpg,
> +	struct se_node_acl *se_nacl)
> +{
> +	struct uasp_nacl *nacl = container_of(se_nacl,
> +			struct uasp_nacl, se_node_acl);
> +	printk(KERN_ERR "%s(%d)\n", __func__, __LINE__);
> +	kfree(nacl);
> +}
> +

<SNIP>

So for the primary incoming I/O path, you'll want to be using the new
target_submit_cmd() call that we've been working on in
lio-core.git/qla_tgt-3.3 recently, as this will simplify incoming I/O +
exception handling for struct uasp_cmd from processing context usage.

Also, do you expect this new driver to pass pre-populated scatterlists,
or to leave se_cmd->t_data_sg allocation up to target-core..?  Depending
on the expected usage this will look slightly different from the current
usage in tcm_loop/tcm_vhost that both pass pre-populated scatterlists
from Linux/SCSI.

Aside from that, let me know if you have questions while filling in the
write_pending and response (queue_data_in + queue_status) fabric
callbacks.

Thanks!

--nab

