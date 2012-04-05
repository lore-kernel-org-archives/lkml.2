Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2DEQnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:43:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50196 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab2DEQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:43:29 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Veaceslav Falico <vfalico@redhat.com>
cc: netdev@vger.kernel.org, Andy Gospodarek <andy@greyhouse.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bonding: properly unset current_arp_slave on slave link up
In-reply-to: <20120405134743.GB16870@darkmag.usersys.redhat.com>
References: <20120405134743.GB16870@darkmag.usersys.redhat.com>
Comments: In-reply-to Veaceslav Falico <vfalico@redhat.com>
   message dated "Thu, 05 Apr 2012 15:47:43 +0200."
X-Mailer: MH-E 8.2; nmh 1.4; GNU Emacs 23.4.1
Date: Thu, 05 Apr 2012 09:43:22 -0700
Message-ID: <27159.1333644202@death.nxdomain>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040516-9360-0000-0000-0000052F32DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Veaceslav Falico <vfalico@redhat.com> wrote:

>When a slave comes up, we're unsetting the current_arp_slave without
>removing active flags from it, which can lead to situations where we have
>more than one slave with active flags in active-backup mode.
>
>To avoid this situation we must remove the active flags from a slave before
>removing it as a current_arp_slave.
>
>Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

>---
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 0c76186..ad731a1 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3001,7 +3001,11 @@ static void bond_ab_arp_commit(struct bonding *bond, int delta_in_ticks)
> 					   trans_start + delta_in_ticks)) ||
> 			    bond->curr_active_slave != slave) {
> 				slave->link = BOND_LINK_UP;
>-				bond->current_arp_slave = NULL;
>+				if (bond->current_arp_slave) {
>+					bond_set_slave_inactive_flags(
>+						bond->current_arp_slave);
>+					bond->current_arp_slave = NULL;
>+				}
>
> 				pr_info("%s: link status definitely up for interface %s.\n",
> 					bond->dev->name, slave->dev->name);
>

