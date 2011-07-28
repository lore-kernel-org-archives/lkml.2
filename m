Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1G1IAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:00:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47091 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1G1IAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:00:20 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 04:00:20 EDT
From: James Bottomley <jbottomley@parallels.com>
To: Luben Tuikov <ltuikov@yahoo.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Thread-Topic: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Thread-Index: AQHMTN2aQgG4jYpaVk++o3271MTNBJUB0hKA
Date: Thu, 28 Jul 2011 07:52:05 +0000
Message-ID: <1311839519.30253.16.camel@mulgrave>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
In-Reply-To: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA97DD317181294388FD61B018635A4F@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6S80fAU011110

On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
> Allow expander table-to-table attachments for
> expanders that support it.

This is half the code to do SAS 2.0 expanders.  You seem to have
additions from the other half (self configuring expanders) see below;
does this mean you have a patch for self configuring expanders in the
works?

> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |   20 ++++++++++++++------
>  include/scsi/libsas.h              |    3 +++
>  include/scsi/sas.h                 |   14 ++++++++++++--
>  3 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f84084b..e8d0115 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct domain_device *dev,
>      dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
>      dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
>      dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
> +    dev->ex_dev.t2t_supp = rg->t2t_supp;
>      dev->ex_dev.conf_route_table = rg->conf_route_table;
>      dev->ex_dev.configuring = rg->configuring;
>      memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_logical_id, 8);
> @@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
>      };
>      struct domain_device *parent = child->parent;
>  
> -    sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x "
> -           "has %c:%c routing link!\n",
> +    sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx "
> +           "(T2T supp:%d) phy 0x%x has %c:%c routing link!\n",
>  
>             ex_type[parent->dev_type],
>             SAS_ADDR(parent->sas_addr),
> +           parent->ex_dev.t2t_supp,
>             parent_phy->phy_id,
>  
>             ex_type[child->dev_type],
>             SAS_ADDR(child->sas_addr),
> +           child->ex_dev.t2t_supp,
>             child_phy->phy_id,
>  
>             ra_char[parent_phy->routing_attr],
> @@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct domain_device *child)
>                      sas_print_parent_topology_bug(child, parent_phy, child_phy);
>                      res = -ENODEV;
>                  }
> -            } else if (parent_phy->routing_attr == TABLE_ROUTING &&
> -                   child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
> -                sas_print_parent_topology_bug(child, parent_phy, child_phy);
> -                res = -ENODEV;
> +            } else if (parent_phy->routing_attr == TABLE_ROUTING) {
> +                if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
> +                    (child_phy->routing_attr == TABLE_ROUTING &&
> +                     child_ex->t2t_supp && parent_ex->t2t_supp)) {
> +                    /* All good */;
> +                } else {
> +                    sas_print_parent_topology_bug(child, parent_phy, child_phy);
> +                    res = -ENODEV;
> +                }
>              }
>              break;
>          case FANOUT_DEV:
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ee86606..793f80b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -142,8 +142,11 @@ struct expander_device {
>      u16    ex_change_count;
>      u16    max_route_indexes;
>      u8     num_phys;
> +
> +    u8     t2t_supp:1;
>      u8     configuring:1;
>      u8     conf_route_table:1;
> +
>      u8     enclosure_logical_id[8];
>  
>      struct ex_phy *ex_phy;
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index e9fd022..f59f182 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -341,7 +341,12 @@ struct report_general_resp {
>  
>      u8      conf_route_table:1;
>      u8      configuring:1;
> -    u8      _r_b:6;
> +    u8    config_others:1;
> +    u8    orej_retry_supp:1;
> +    u8    stp_cont_awt:1;
> +    u8    self_config:1;
> +    u8    zone_config:1;
> +    u8    t2t_supp:1;

>      u8      _r_c;
>  
> @@ -528,7 +533,12 @@ struct report_general_resp {
>      u8      _r_a;
>      u8      num_phys;
>  
> -    u8      _r_b:6;
> +    u8    t2t_supp:1;
> +    u8    zone_config:1;
> +    u8    self_config:1;
> +    u8    stp_cont_awt:1;
> +    u8    orej_retry_supp:1;
> +    u8    config_others:1;
>      u8      configuring:1;
>      u8      conf_route_table:1;
>  

These are all SAS2.0 additions to the reserved fields, but you only make
use of one of them.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
