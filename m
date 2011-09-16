Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1IPK5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab1IPK5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:57:47 -0400
Date: Fri, 16 Sep 2011 18:58:56 +0800
From: Han Pingtian <phan@redhat.com>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix EDAC sdram_scrub_rate read failure
Message-ID: <20110916105856.GA13253@hpt.nay.redhat.com>
Mail-Followup-To: mchehab@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sdram scrubbing rate ins't implemented on current system, read it
will cause an error:

cat: /sys/devices/system/edac/mc//mc0/sdram_scrub_rate: Invalid argument

The eba042a81edd6baaff44831b2d719b14a6d21e58 let it returning -EINVAL,
but according to the document, it should show -1:

dram memory scrubbing rate:

        'sdram_scrub_rate'

        Read/Write attribute file that controls memory scrubbing. The scrubbing
        rate is set by writing a minimum bandwidth in bytes/sec to the attribute
        file. The rate will be translated to an internal value that gives at
        least the specified rate.

        Reading the file will return the actual scrubbing rate employed.

        If configuration fails or memory scrubbing is not implemented, the value
        of the attribute file will be -1.

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 29ffa35..602fdcf 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -475,7 +475,7 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 	int bandwidth = 0;
 
 	if (!mci->get_sdram_scrub_rate)
-		return -EINVAL;
+		return sprintf(date, "%d\n", -1);
 
 	bandwidth = mci->get_sdram_scrub_rate(mci);
 	if (bandwidth < 0) {
-- 
1.7.1
