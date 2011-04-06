Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab1DFPTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:19:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1DFPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CXmXS/LZuOeDftAHcYOd1uyzjiUxcqNRjPoYZX6PWHziC6Bmg9+QGLlXxvg1Q36OS4
         IgTLONqvnNF8toWKXySVMuG6DE7qc8s6313rn/5uIVKhm29hRviQK4oUZF7E5wDKdzEG
         qpMFOmPOEcVS/e13x3/5QikII0pfZCfzAtLwI=
Date: Wed, 6 Apr 2011 17:19:01 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
 information
Message-ID: <20110406151901.GE2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
 <20110406161401.1c0ab6de@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406161401.1c0ab6de@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 04:14:01PM +0200, Jean Delvare wrote:
> On Tue, 5 Apr 2011 16:45:36 +0200, Andreas Herrmann wrote:
> > From: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > This CPU family provides NB register values to gather following
> > TDP information
> > 
> > * ProcessorPwrWatts: Specifies in Watts the maximum amount of power
> >   the processor can support.
> > * CurrPwrWatts: Specifies in Watts the current amount of power being
> >   consumed by the processor.
> > 
> > This driver provides
> > 
> > * power1_cap (ProcessorPwrWatts)
> > * power1_input (CurrPwrWatts)
> 
> Just a few random comments as I don't have the time for a complete
> review:
> 
> > 
> > Changes from v1::
> >  - removed deprecated code line,
> >  - fixed comment,
> >  - report power only once per socket (Power information is provided
> >    for the entire package. On multi-node processors it should only be
> >    reported on internal node 0.)
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  drivers/hwmon/Kconfig      |   10 ++
> >  drivers/hwmon/Makefile     |    1 +
> >  drivers/hwmon/f15h_power.c |  216 ++++++++++++++++++++++++++++++++++++++++++++
> 
> I would prefer fam15h to f15h. The latter is a little too cryptic for
> me.

Hmm, (unfortunately;-) seconded, e.g.

  linux-2.6 $ grep -rs fam10h arch/x86 | wc
       71     450    7930
  linux-2.6 $ grep -rs f10h arch/x86 | wc
       0       0       0

Will change it.

  [snip]

> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -62,6 +62,7 @@ obj-$(CONFIG_SENSORS_JC42)	+= jc42.o
> >  obj-$(CONFIG_SENSORS_JZ4740)	+= jz4740-hwmon.o
> >  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
> >  obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
> > +obj-$(CONFIG_SENSORS_F15H_POWER) += f15h_power.o
> 
> Alphabetic order please.

ok.

[snip]

> > +static ssize_t show_power(struct device *dev,
> > +			  struct device_attribute *attr, char *buf)
> > +{
> > +	u32 val, btdp, tdpl, tdp2w, arange;
> > +	s32 acap;
> > +	u64 ctdp;
> 
> These variable names aren't easy to understand.

Just random names which eventually map to the spec:

btdp - base_tdp
tdpl - tdp_limit
tdp2w - tdp_to_watt
acap - average_accumulator_capture (or even worse how about "processor_tdp_running_average_accumulator":(
arange - average_range

I don't think that changing the names make it much easier to
reconstruct the calculation but if you insist in changing it I'll
adapt it.

> > +	struct pci_dev *f4 = to_pci_dev(dev);
> > +	struct pci_dev *f5;
> > +
> > +	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
> > +	btdp = (val >> 16) & 0xffff;
> 
> Useless masking.

To be removed.

> > +
> > +	f5 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5));
> > +	if (!f5) {
> > +		dev_err(dev, "no function 5 available on this slot\n");
> > +		return 0;
> > +	}
> > +
> > +	pci_read_config_dword(f5, REG_TDP_RUNNING_AVERAGE, &val);
> 
> Does this value change over time?

Yes.

> > +	acap = (val >> 4) & 0x3fffff;
> > +	acap = sign_extend32(acap, 22);
> > +	arange = val & 0xf;
> > +
> > +	pci_read_config_dword(f5, REG_TDP_LIMIT3, &val);
> 
> Same question here. If these values don't change over time, they should
> be stored in a per-device structure to avoid repeated PCI configuration
> space access.

The parts I use from this register shouldn't change => code to be modified.

> > +	pci_dev_put(f5);
> > +
> > +	tdpl = (val >> 16) & 0x1fff;
> > +	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
> > +	ctdp = tdpl - (s32)(acap >> (arange + 1)) + btdp;
> > +	ctdp *= tdp2w;
> > +
> > +	/*
> > +	 * Convert to microWatt
> > +	 *
> > +	 * power is in Watt provided as fixed point integer with
> > +	 * scaling factor 1/(2^16).  For conversion we use
> > +	 * (10^6)/(2^16) = 15625/(2^10)
> > +	 */
> > +	ctdp = (ctdp * 15625) >> 10;
> > +	return sprintf(buf, "%d\n", (u32) ctdp);
> 
> %d and u32 aren't compatible. %lu and long unsigned int would be OK.

already fixed in v3

> > +}
> > +static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);
> > +
> > +static ssize_t show_power_cap(struct device *dev,
> > +			     struct device_attribute *attr, char *buf)
> > +{
> > +	u32 val, tdp2w;
> > +	u64 ptdp;
> > +	struct pci_dev *f4 = to_pci_dev(dev);
> > +	struct pci_dev *f5;
> > +
> > +	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
> > +	ptdp = val & 0xffff;
> > +
> > +	f5 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5));
> > +	if (!f5) {
> > +		dev_err(dev, "no function 5 available on this slot\n");
> > +		return 0;
> > +	}
> > +
> > +	pci_read_config_dword(f5, REG_TDP_LIMIT3, &val);
> 
> Same question as above, can this value change over time?

Needs to be modified.

> > +	pci_dev_put(f5);
> > +
> > +	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
> > +	ptdp *= tdp2w;
> > +
> > +	/* result not allowed to be >= 256W */
> > +	WARN_ON(ptdp>>16 >= 256);
> > +
> > +	/* convert to microWatt */
> > +	ptdp = (ptdp * 15625) >> 10;
> > +	return sprintf(buf, "%d\n", (u32) ptdp);
> 
> %d and u32 aren't compatible. %lu and long unsigned int would be OK.

fixed in v3.

> > +}
> > +static DEVICE_ATTR(power1_cap, S_IRUGO, show_power_cap, NULL);
> > +
> > +static ssize_t show_name(struct device *dev,
> > +			 struct device_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "f15h_power\n");
> > +}
> > +static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> > +
> > +static int __devinit f15h_power_is_internal_node0(struct pci_dev *f4)
> > +{
> > +	u32 val;
> > +	struct pci_dev *f3;
> > +
> > +	f3 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3));
> > +	if (!f3) {
> > +		dev_err(&f4->dev, "no function 3 available on this slot\n");
> 
> Please use %d and pass the number as a parameter, and do the same for
> the 2 similar messages above. This will let the compiler reuse the
> string.

message removed in v3

> > +		return 0;
> > +	}
> > +
> > +	pci_read_config_dword(f3, REG_NORTHBRIDGE_CAP, &val);
> > +	pci_dev_put(f3);
> > +
> > +	if ((val & BIT(29)) && ((val >> 30) & 3))
> > +		return 0;
> > +
> > +	return 1;
> > +}
> > +
> > +static int __devinit f15h_power_probe(struct pci_dev *pdev,
> > +				      const struct pci_device_id *id)
> > +{
> > +	struct device *hwmon_dev;
> > +	int err = -ENODEV;
> 
> You should move this initialization to the only case which needs it.
> Otherwise you're slowing down the success path with no good reason.

to be done

> > +
> > +	if (!f15h_power_is_internal_node0(pdev))
> > +		goto exit;
> > +
> > +	err = device_create_file(&pdev->dev, &dev_attr_power1_input);
> > +	if (err)
> > +		goto exit;
> > +	err = device_create_file(&pdev->dev, &dev_attr_power1_cap);
> > +	if (err)
> > +		goto exit_remove;
> > +
> > +	err = device_create_file(&pdev->dev, &dev_attr_name);
> > +	if (err)
> > +		goto exit_remove;
> 
> Please consider defining and using an attribute group, it makes the
> code more simple.

Will think about it.

> > +
> > +	hwmon_dev = hwmon_device_register(&pdev->dev);
> > +	if (IS_ERR(hwmon_dev)) {
> > +		err = PTR_ERR(hwmon_dev);
> > +		goto exit_remove;
> > +	}
> > +	dev_set_drvdata(&pdev->dev, hwmon_dev);
> 
> pci_set_drvdata()

Are you sure?
No single hwmon driver is using this wrapper around dev_set_drvdata() so far. (Or I just missed it.)
At the moment only dev_set_drvdata() is used by

 drivers/hwmon/adcxx.c
 drivers/hwmon/lm70.c
 drivers/hwmon/ultra45_env.c
 drivers/hwmon/ibmpex.c
 drivers/hwmon/k10temp.c
 drivers/hwmon/ibmaem.c
 drivers/hwmon/k8temp.c

> > +
> > +	return 0;
> > +
> > +exit_remove:
> > +	device_remove_file(&pdev->dev, &dev_attr_name);
> > +	device_remove_file(&pdev->dev, &dev_attr_power1_input);
> > +	device_remove_file(&pdev->dev, &dev_attr_power1_cap);
> > +exit:
> > +	return err;
> > +}
> > +
> > +static void __devexit f15h_power_remove(struct pci_dev *pdev)
> > +{
> > +	hwmon_device_unregister(dev_get_drvdata(&pdev->dev));
> > +	device_remove_file(&pdev->dev, &dev_attr_name);
> > +	device_remove_file(&pdev->dev, &dev_attr_power1_input);
> > +	device_remove_file(&pdev->dev, &dev_attr_power1_cap);
> > +	dev_set_drvdata(&pdev->dev, NULL);
> 
> pci_set_drvdata()
> 
> > +}
> > +
> > +static const struct pci_device_id f15h_power_id_table[] = {
> > +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
> 
> Not defined anywhere, causing the driver to fail building:
> 
> drivers/hwmon/f15h_power.c:193:1: error: 'PCI_DEVICE_ID_AMD_15H_NB_LINK' undeclared here (not in a function)
> make[2]: *** [drivers/hwmon/f15h_power.o] Error 1
> make[1]: *** [drivers/hwmon] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2

The macro changed with .39-rc2
Already fixed in v3

Thanks for your review,

Please let me know whether changing the variable names and using
pci_set_drvdata() is strictly required.


Andreas
