Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1FPWx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:53:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39507 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1FPWx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXmctjeuOTeHTpPWeLBgVXaz7EMPZmAgZOwwxhb4S5NbeaC5DVDGrRDmFHlg/QqHF9
         XyZQfluN/naX4/wzTDDewXTPXA4ZTHKjYNqCCO/Rt5xLOj+QqSxet/vf4WzztbVhCFNl
         Fb5E2Dw8ViXS4ZMYo24mRtmChV0fbtSBcNcZ0=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106162359560.8140@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106162359560.8140@swampdragon.chaosbits.net>
Date: Thu, 16 Jun 2011 15:53:24 -0700
Message-ID: <BANLkTimwzbB9ZwbG3u=oRNAHSECioEJ3dQ@mail.gmail.com>
Subject: Re: rionet: NULL pointer dereference
From: Connor Hansen <cmdkhh@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 3:06 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi
>
> Just noticed that drivers/net/rionet.c::rionet_remove() can cause a NULL
> deref when it calls unregister_netdev().
> It initializes local variable 'ndev' to NULL and nothing changes this
> before the call to unregister_netdev(ndev) - that functions then calls:
> unregister_netdevice > unregister_netdevice_queue > list_move_tail >
> __list_del_entry  which dereferences the pointer (which, being NULL, will
> end in tears).

unregister_netdevice(struct net_device *dev)
{
        unregister_netdevice_queue(dev, NULL);
}

 so unregister_netdevice_queue is being called with NULL,NULL

void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
{
        ASSERT_RTNL();

        if (head) {
                list_move_tail(&dev->unreg_list, head);
        } else {
                rollback_registered(dev);
                /* Finish processing unregister after unlock */
                net_set_todo(dev);
        }
}

if head is null, which it is from the call, then we call
rollback_registered, and not list_move_tail()

the else calls rollback_registered(NULL) then net_set_todo(NULL)

both of which dereference null when passed, so yes there is a null
dereference, just not in the code branch you thought.

static void rollback_registered(struct net_device *dev)
{
        LIST_HEAD(single);

        list_add(&dev->unreg_list, &single);    null dereference
        rollback_registered_many(&single);
        list_del(&single);
}

static void net_set_todo(struct net_device *dev)
{
        list_add_tail(&dev->todo_list, &net_todo_list);  null dereference
}

Connor

>
> I won't claim to know this code nor what the proper fix is; just thought
> i'd report it so someone else with more knowledge of this could perhaps
> come up with a fix.
>
> Have a nice day.
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
