Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab0G3S4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:56:12 -0400
Received: from kroah.org ([198.145.64.141]:35483 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab0G3ReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:04 2010
Message-Id: <20100730173103.943596359@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [013/140] hwmon: (k8temp) Bypass core swapping on single-core processors
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit cd4de21f7e65a8cd04860f5661b3c18648ee52a1 upstream.

Commit a2e066bba2aad6583e3ff648bf28339d6c9f0898 introduced core
swapping for CPU models 64 and later. I recently had a report about
a Sempron 3200+, model 95, for which this patch broke temperature
reading. It happens that this is a single-core processor, so the
effect of the swapping was to read a temperature value for a core
that didn't exist, leading to an incorrect value (-49 degrees C.)

Disabling core swapping on singe-core processors should fix this.

Additional comment from Andreas:

The BKDG says

  Thermal Sensor Core Select (ThermSenseCoreSel)-Bit 2. This bit
  selects the CPU whose temperature is reported in the CurTemp
  field. This bit only applies to dual core processors. For
  single core processors CPU0 Thermal Sensor is always selected.

k8temp_probe() correctly detected that SEL_CORE can't be used on single
core CPU. Thus k8temp did never update the temperature values stored
in temp[1][x] and -49 degrees was reported. For single core CPUs we
must use the values read into temp[0][x].

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Rick Moritz <rhavin@gmx.net>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/k8temp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -120,7 +120,7 @@ static ssize_t show_temp(struct device *
 	int temp;
 	struct k8temp_data *data = k8temp_update_device(dev);
 
-	if (data->swap_core_select)
+	if (data->swap_core_select && (data->sensorsp & SEL_CORE))
 		core = core ? 0 : 1;
 
 	temp = TEMP_FROM_REG(data->temp[core][place]) + data->temp_offset;


