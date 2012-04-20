Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2DTWv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:51:58 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22509 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2DTWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:51:56 -0400
From: "Shergill, Gurinder" <gurinder.shergill@hp.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gates, Matt" <matthew.gates@hp.com>,
        "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mikem@beardog.cce.hp.com" <mikem@beardog.cce.hp.com>,
        "james.bottomley@hansenpartnership.com" 
	<james.bottomley@hansenpartnership.com>
Date: Fri, 20 Apr 2012 23:51:16 +0100
Subject: RE: [PATCH 06/17] hpsa: retry driver initiated commands on busy
 status
Thread-Topic: [PATCH 06/17] hpsa: retry driver initiated commands on busy
 status
Thread-Index: Ac0fCOktsMPmkLfdQB25PBcSU/TJFgAPv09g
Message-ID: <C508F8684F59FF47960D08B35B998FFE6563003D68@GVW1341EXA.americas.hpqcorp.net>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
 <20120420150646.10596.37875.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150646.10596.37875.stgit@beardog.cce.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3KMq4dr007333


| -----Original Message-----
| From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
| owner@vger.kernel.org] On Behalf Of Stephen M. Cameron
| Sent: Friday, April 20, 2012 8:07 AM
| To: james.bottomley@hansenpartnership.com
| Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Gates, Matt;
| stephenmcameron@gmail.com; thenzl@redhat.com; akpm@linux-foundation.org;
| mikem@beardog.cce.hp.com
| Subject: [PATCH 06/17] hpsa: retry driver initiated commands on busy
| status
| 
| From: Matt Bondurant <Matthew.dav.bondurant@hp.com>
| 
| In shared SAS configurations we might get a busy status during driver
| initiated commands (e.g. during rescan for devices).  We should retry the
| command in such cases rather than giving up.

This may or may not apply to your situation. Some targets/disks return TASK SET FULL when they can't accept any new SCSI commands. If that applies to your situation, it may make sense to also check for SCSI status of SAM_STAT_TASK_SET_FULL.

Sunny

| 
| Signed-off-by: Matt Bondurant <Matthew.dav.bondurant@hp.com>
| Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
| ---
|  drivers/scsi/hpsa.c |   12 +++++++++++-
|  1 files changed, 11 insertions(+), 1 deletions(-)
| 
| diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index
| fcb9fb2..7355891 100644
| --- a/drivers/scsi/hpsa.c
| +++ b/drivers/scsi/hpsa.c
| @@ -234,6 +234,15 @@ static int check_for_unit_attention(struct ctlr_info
| *h,
|  	return 1;
|  }
| 
| +static int check_for_busy(struct ctlr_info *h, struct CommandList *c) {
| +	if (c->err_info->CommandStatus != CMD_TARGET_STATUS ||
| +		c->err_info->ScsiStatus != SAM_STAT_BUSY)
| +		return 0;
| +	dev_warn(&h->pdev->dev, HPSA "device busy");
| +	return 1;
| +}
| +
|  static ssize_t host_store_rescan(struct device *dev,
|  				 struct device_attribute *attr,
|  				 const char *buf, size_t count)
| @@ -1379,7 +1388,8 @@ static void
| hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
|  		memset(c->err_info, 0, sizeof(*c->err_info));
|  		hpsa_scsi_do_simple_cmd_core(h, c);
|  		retry_count++;
| -	} while (check_for_unit_attention(h, c) && retry_count <= 3);
| +	} while ((check_for_unit_attention(h, c) ||
| +			check_for_busy(h, c)) && retry_count <= 3);
|  	hpsa_pci_unmap(h->pdev, c, 1, data_direction);  }
| 
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
| the body of a message to majordomo@vger.kernel.org More majordomo info at
| http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
