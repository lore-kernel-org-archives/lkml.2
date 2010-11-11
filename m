Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0KKLvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:51:39 -0500
Received: from www.tglx.de ([62.245.132.106]:54783 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0KKLvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:51:38 -0500
Date: Thu, 11 Nov 2010 12:51:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        x86@kernel.org
Subject: Re: [PATCH 2/6] ce4100: add PCI register emulation for CE4100
In-Reply-To: <40b6751381c2275dc359db5a17989cce22ad8db7.1289331834.git.dirk.brandewie@gmail.com>
Message-ID: <alpine.LFD.2.00.1011111247570.2900@localhost6.localdomain6>
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <40b6751381c2275dc359db5a17989cce22ad8db7.1289331834.git.dirk.brandewie@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, dirk.brandewie@gmail.com wrote:
> +
> +static int ce4100_conf_read(unsigned int seg, unsigned int bus,
> +			  unsigned int devfn, int reg, int len, u32 *value)
> +{
> +	int retval = 1;
> +	int i;
> +
> +	if (bus == 0 && (PCI_DEVFN(1, 0) == devfn))
> +		retval = bridge_read(devfn, reg, len, value);
> +
> +	if (bus == 1) {
> +		for (i = 0; i < num_bus1_fixups; i++) {
> +			if (bus1_fixups[i].dev_func == devfn &&
> +				bus1_fixups[i].reg == (reg & ~3) &&
> +				bus1_fixups[i].read) {
> +				bus1_fixups[i].read(&(bus1_fixups[i]),
> +					value);
> +				extract_bytes(value, reg, len);
> +				retval = 0;

  Shouldn't we return 0 here and be done ?

> +			}
> +		}
> +	}
> +	if (retval)
> +		retval = pci_direct_conf1.read(seg, bus, devfn, reg,
> +					len, value);
> +	return retval;
> +}
> +
> +
> +static int ce4100_conf_write(unsigned int seg, unsigned int bus,
> +			   unsigned int devfn, int reg, int len, u32 value)
> +{
> +	int retval = 1;
> +	int i;
> +
> +	if (bus == 1) {
> +		for (i = 0; i < num_bus1_fixups; i++) {
> +			if (bus1_fixups[i].dev_func == devfn &&
> +				bus1_fixups[i].reg == (reg & ~3) &&
> +				bus1_fixups[i].write) {
> +				bus1_fixups[i].write(&(bus1_fixups[i]),
> +					value);
> +				retval = 0;

  Ditto

> +			}
> +		}
> +	}
> +
> +	/* Discard writes to A/V bridge BAR. */
> +	if (bus == 0 && PCI_DEVFN(1, 0) == devfn &&
> +		((reg & ~3) == PCI_BASE_ADDRESS_0))
> +		retval = 0;

  Ditto

> +
> +	if (retval)
> +		retval = pci_direct_conf1.write(seg, bus, devfn, reg,
> +						len, value);
> +	return retval;
> +}

It took me some time to grok the above retval magic. I'd rather write
it this way:

+static int ce4100_conf_read(unsigned int seg, unsigned int bus,
+			    unsigned int devfn, int reg, int len, u32 *value)
+{
+	int i;
+
+	if (bus == 1) {
+		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+			    bus1_fixups[i].reg == (reg & ~3) &&
+			    bus1_fixups[i].read) {
+				bus1_fixups[i].read(&(bus1_fixups[i]),
+						    value);
+				extract_bytes(value, reg, len);
+				return 0;
+			}
+		}
+	}
+
+	if (bus == 0 && (PCI_DEVFN(1, 0) == devfn) &&
+	    !bridge_read(devfn, reg, len, value))
+		return 0;
+
+	return pci_direct_conf1.read(seg, bus, devfn, reg, len, value);
+}
+
+static int ce4100_conf_write(unsigned int seg, unsigned int bus,
+			     unsigned int devfn, int reg, int len, u32 value)
+{
+	int i;
+
+	if (bus == 1) {
+		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+			    bus1_fixups[i].reg == (reg & ~3) &&
+			    bus1_fixups[i].write) {
+				bus1_fixups[i].write(&(bus1_fixups[i]),
+						     value);
+				return 0;
+			}
+		}
+	}
+
+	/* Discard writes to A/V bridge BAR. */
+	if (bus == 0 && PCI_DEVFN(1, 0) == devfn &&
+	    ((reg & ~3) == PCI_BASE_ADDRESS_0))
+		return 0;
+
+	return pci_direct_conf1.write(seg, bus, devfn, reg, len, value);
+}

Thanks,

	tglx
