Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2FNX6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2FNX6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:18 -0400
Message-Id: <20120614235645.255779542@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 11/20] hwmon: (fam15h_power) Increase output resolution
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@amd.com>

commit 941a956b0e387b21f385f486c34ef67576775cfc upstream.

On high CPU load the accumulating values in the running_avg_cap
register are very low (below 10), so averaging them too early leads
to unnecessary poor output resolution. Since we pretend to output
micro-Watt we better keep all the bits we have as long as possible.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/fam15h_power.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -61,14 +61,14 @@ static ssize_t show_power(struct device
 				  REG_TDP_RUNNING_AVERAGE, &val);
 	running_avg_capture = (val >> 4) & 0x3fffff;
 	running_avg_capture = sign_extend32(running_avg_capture, 21);
-	running_avg_range = val & 0xf;
+	running_avg_range = (val & 0xf) + 1;
 
 	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
 				  REG_TDP_LIMIT3, &val);
 
 	tdp_limit = val >> 16;
-	curr_pwr_watts = tdp_limit + data->base_tdp -
-		(s32)(running_avg_capture >> (running_avg_range + 1));
+	curr_pwr_watts = (tdp_limit + data->base_tdp) << running_avg_range;
+	curr_pwr_watts -= running_avg_capture;
 	curr_pwr_watts *= data->tdp_to_watts;
 
 	/*
@@ -78,7 +78,7 @@ static ssize_t show_power(struct device
 	 * scaling factor 1/(2^16).  For conversion we use
 	 * (10^6)/(2^16) = 15625/(2^10)
 	 */
-	curr_pwr_watts = (curr_pwr_watts * 15625) >> 10;
+	curr_pwr_watts = (curr_pwr_watts * 15625) >> (10 + running_avg_range);
 	return sprintf(buf, "%u\n", (unsigned int) curr_pwr_watts);
 }
 static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);


