Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1FFQYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:24:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62210 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1FFQYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ecw+X3tVC0/If5+q4JNXPFpeGGAQeNOObNJfXi3gCODfvBW1eQ9HBVXvl217q3LdWH
         thRfiguG9v6ww58xJjZYdnsu6bulZF37+cgWCFbEHI4GUOol5Oiiw+MhDF3E78vQWsxD
         mvQcGB7Emfczx4HvaR+isCqDnQXVZzzxrjNo0=
MIME-Version: 1.0
In-Reply-To: <1307243793-31007-1-git-send-email-panweiping3@gmail.com>
References: <19046.1307130148@death>
	<1307243793-31007-1-git-send-email-panweiping3@gmail.com>
Date: Tue, 7 Jun 2011 00:24:04 +0800
Message-ID: <BANLkTi=9HbFEM0WxTX+gbiB8J37mW+PCUA@mail.gmail.com>
Subject: Re: [PATCH net-next] bonding: make 802.3ad use update lacp_rate (v2)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Weiping Pan <panweiping3@gmail.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 11:16 AM, Weiping Pan <panweiping3@gmail.com> wrote:
> There is a bug that when you modify lacp_rate via sysfs,
> 802.3ad won't use the new value of lacp_rate to transmit packets.
> That is because port->actor_oper_port_state isn't changed.
>
> Change Notes:
> v2)
> 1 Hold read_lock(&bond->lock) when iterate slaves, suggested by Jiri Pirko.
> 2 Modify actor_oper_port_state via a helper function in bond_3ad.c,
> suggested by Jay Vosburgh.
> 3 Hold slave->state_machine_lock,
> so we can modify port->actor_oper_port_state, no matter bond is up or down.
>
> Signed-off-by: Weiping Pan <panweiping3@gmail.com>
> ---
>  drivers/net/bonding/bond_3ad.c   |   27 +++++++++++++++++++++++++++
>  drivers/net/bonding/bond_3ad.h   |    1 +
>  drivers/net/bonding/bond_sysfs.c |    1 +
>  3 files changed, 29 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
> index c7537abc..5111e0d 100644
> --- a/drivers/net/bonding/bond_3ad.c
> +++ b/drivers/net/bonding/bond_3ad.c
> @@ -2473,3 +2473,30 @@ void bond_3ad_lacpdu_recv(struct sk_buff *skb, struct bonding *bond,
>        bond_3ad_rx_indication((struct lacpdu *) skb->data, slave, skb->len);
>        read_unlock(&bond->lock);
>  }
> +
> +/*
> + * When modify lacp_rate parameter via sysfs,
> + * update actor_oper_port_state of each port.
> + *
> + * Hold slave->state_machine_lock,
> + * so we can modify port->actor_oper_port_state,
> + * no matter bond is up or down.
> + */
> +void bond_3ad_update_lacp_rate(struct bonding *bond)
> +{
> +       int i;
> +       struct slave *slave;
> +       struct port *port = NULL;
> +
> +       read_lock(&bond->lock);
> +       bond_for_each_slave(bond, slave, i) {
> +               port = &(slave->ad_info.port);

Please use SLAVE_AD_INFO().

Other than this, it looks good to me,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
