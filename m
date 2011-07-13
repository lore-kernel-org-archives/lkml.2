Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222Ab1GMJy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:54:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52137 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965091Ab1GMJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:54:55 -0400
Date: Wed, 13 Jul 2011 10:51:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mrst_pmu: driver for Intel Moorestown Power Management
 Unit
Message-ID: <20110713105105.63e2fbcb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1107122328180.4502@x980>
References: <alpine.LFD.2.02.1107122328180.4502@x980>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct mrst_device *pci_id_2_mrst_dev(u16 pci_dev_num)
> +{
> +	int index;
> +
> +	if ((pci_dev_num >= 0x0800) && (pci_dev_num <= 0x815))
> +		index = pci_dev_num - 0x800;
> +	else if (pci_dev_num == 0x084F)
> +		index = 22;
> +	else if (pci_dev_num == 0x4102)
> +		index = 23;
> +	else if (pci_dev_num == 0x4110)
> +		index = 24;
> +	else
> +		BUG();
> +
> +	BUG_ON(pci_dev_num != mrst_devs[index].pci_dev_num);

That strikes me as needlessly unfriendly, you could warn/return NULL and
propogate a WARN_ONCE back to the user.

> +static int __init scu_fw_check(void)
> +{
> +	int ret;
> +	u32 fw_version;
> +
> +	sfi_table_parse("OEMB", NULL, NULL, pmu_sfi_parse_oem);
> +
> +	if (ia_major < 0x6005 || ia_minor < 0x1525) {
> +		WARN(1, "mrst_pmu: IA FW version too old\n");
> +		return -1;
> +	}
> +
> +	ret = intel_scu_ipc_command(IPCMSG_FW_REVISION, 0, NULL, 0,
> +					&fw_version, 1);
> +
> +	if (ret) {
> +		WARN(1, "mrst_pmu: IPC FW version? %d\n", ret);
> +	} else {
> +		int scu_major = (fw_version >> 8) & 0xFF;
> +		int scu_minor = (fw_version >> 0) & 0xFF;
> +
> +		printk(KERN_INFO "mrst_pmu: firmware v%x\n", fw_version);
> +
> +		if ((scu_major >= 0xC0) && (scu_minor >= 0x49)) {
> +			printk(KERN_INFO "mrst_pmu: enabling S0i3\n");
> +			mrst_pmu_s0i3_enable = true;
> +		} else {
> +			WARN(1, "mrst_pmu: S0i3 disabled, old firmware %X.%X",
> +					scu_major, scu_minor);
> +		}
> +	}
> +	return 0;
> +}
> +late_initcall(scu_fw_check);

NAK. I pointed this problem with the driver to you way back - this code
gets run always - even on machines that are not in fact Moorestown which
are then going to crash.

You need to check that the platform is Moorestown (not just the CPU
either because of Oaktrail)

