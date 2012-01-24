Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2AXWl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:41:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2AXWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:41:57 -0500
Date: Tue, 24 Jan 2012 14:41:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, guenter.roeck@ericsson.com,
        durgadoss.r@intel.com, khali@linux-fr.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] thermal: thermal_sys: Fix build warning
Message-Id: <20120124144155.e05118e4.akpm@linux-foundation.org>
In-Reply-To: <1327250761-7071-1-git-send-email-festevam@gmail.com>
References: <1327249995-18682-1-git-send-email-festevam@gmail.com>
	<1327250761-7071-1-git-send-email-festevam@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 14:46:01 -0200
Fabio Estevam <festevam@gmail.com> wrote:

> Fix the following build warning:
> 
> drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but not used
> 
> ,which happens when CONFIG_NET is not set.
> 
> Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Change since v1:
> - Sent corrupted patch in v1, and fixed now
>  drivers/thermal/thermal_sys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index dd9a574..11f5955 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
>  static LIST_HEAD(thermal_cdev_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>  
> -static unsigned int thermal_event_seqnum;
> -
>  static int get_idr(struct idr *idr, struct mutex *lock, int *id)
>  {
>  	int err;
> @@ -1304,6 +1302,8 @@ static struct genl_multicast_group thermal_event_mcgrp = {
>  	.name = THERMAL_GENL_MCAST_GROUP_NAME,
>  };
>  
> +static unsigned int thermal_event_seqnum;
> +
>  int generate_netlink_event(u32 orig, enum events event)
>  {
>  	struct sk_buff *skb;

It is better to make this variable local to the (only) function which
uses it:

--- a/drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning-fix
+++ a/drivers/thermal/thermal_sys.c
@@ -1302,8 +1302,6 @@ static struct genl_multicast_group therm
 	.name = THERMAL_GENL_MCAST_GROUP_NAME,
 };
 
-static unsigned int thermal_event_seqnum;
-
 int thermal_generate_netlink_event(u32 orig, enum events event)
 {
 	struct sk_buff *skb;
@@ -1312,6 +1310,7 @@ int thermal_generate_netlink_event(u32 o
 	void *msg_header;
 	int size;
 	int result;
+	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
 	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
_

