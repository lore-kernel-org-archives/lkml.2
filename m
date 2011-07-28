Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1G1GqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:46:20 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:39940 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1G1GqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:46:14 -0400
From: "Jack Wang" <jack_wang@usish.com>
To: "'Luben Tuikov'" <ltuikov@yahoo.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <JBottomley@Parallels.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Subject: RE: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 28 Jul 2011 14:46:04 +0800
Message-ID: <53763DE9A1F742C9A192F448132FCBD4@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcxM3qRP7u6jpbnlQH6NvXAvh2gAXgADN+cA
In-Reply-To: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Allow expander table-to-table attachments for
> expanders that support it.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |   20 ++++++++++++++------
>  include/scsi/libsas.h              |    3 +++
>  include/scsi/sas.h                 |   14 ++++++++++++--
>  3 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index f84084b..e8d0115 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct
domain_device
> *dev,
>      dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
>      dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
>      dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
> +    dev->ex_dev.t2t_supp = rg->t2t_supp;
>      dev->ex_dev.conf_route_table = rg->conf_route_table;
>      dev->ex_dev.configuring = rg->configuring;
>      memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_logical_id,
> 8);
> @@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(struct
> domain_device *child,
>      };
>      struct domain_device *parent = child->parent;
> 
> -    sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x "
> -           "has %c:%c routing link!\n",
> +    sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx "
> +           "(T2T supp:%d) phy 0x%x has %c:%c routing link!\n",
> 
>             ex_type[parent->dev_type],
>             SAS_ADDR(parent->sas_addr),
> +           parent->ex_dev.t2t_supp,
>             parent_phy->phy_id,
> 
>             ex_type[child->dev_type],
>             SAS_ADDR(child->sas_addr),
> +           child->ex_dev.t2t_supp,
>             child_phy->phy_id,
> 
>             ra_char[parent_phy->routing_attr],
> @@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct
> domain_device *child)
>                      sas_print_parent_topology_bug(child, parent_phy,
> child_phy);
>                      res = -ENODEV;
>                  }
> -            } else if (parent_phy->routing_attr == TABLE_ROUTING &&
> -                   child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
> -                sas_print_parent_topology_bug(child, parent_phy,
> child_phy);
> -                res = -ENODEV;
> +            } else if (parent_phy->routing_attr == TABLE_ROUTING) {
> +                if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
> +                    (child_phy->routing_attr == TABLE_ROUTING &&
> +                     child_ex->t2t_supp && parent_ex->t2t_supp)) {
> +                    /* All good */;
> +                } else {
> +                    sas_print_parent_topology_bug(child, parent_phy,
> child_phy);
> +                    res = -ENODEV;
> +                }
>              }
>              break;
>          case FANOUT_DEV:
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ee86606..793f80b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -142,8 +142,11 @@ struct expander_device {
>      u16    ex_change_count;
>      u16    max_route_indexes;
>      u8     num_phys;
> +
> +    u8     t2t_supp:1;
>      u8     configuring:1;
>      u8     conf_route_table:1;
> +
>      u8     enclosure_logical_id[8];
> 
>      struct ex_phy *ex_phy;
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index e9fd022..f59f182 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -341,7 +341,12 @@ struct report_general_resp {
> 
>      u8      conf_route_table:1;
>      u8      configuring:1;
> -    u8      _r_b:6;
> +    u8    config_others:1;
> +    u8    orej_retry_supp:1;
> +    u8    stp_cont_awt:1;
> +    u8    self_config:1;
> +    u8    zone_config:1;
> +    u8    t2t_supp:1;
> 
>      u8      _r_c;
> 
> @@ -528,7 +533,12 @@ struct report_general_resp {
>      u8      _r_a;
>      u8      num_phys;
> 
> -    u8      _r_b:6;
> +    u8    t2t_supp:1;
> +    u8    zone_config:1;
> +    u8    self_config:1;
> +    u8    stp_cont_awt:1;
> +    u8    orej_retry_supp:1;
> +    u8    config_others:1;
>      u8      configuring:1;
>      u8      conf_route_table:1;
> 

[Jack Wang] Looks nice to me ,thanks for doing this.
Reviewed-by: Jack Wang <jack_wang@usish.com>

