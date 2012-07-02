Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2GBRo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:44:29 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:32377 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755058Ab2GBRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:44:27 -0400
Message-ID: <1341251063.2590.5.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH net-next 09/15] net: bus: Add garbage collector for
 AF_BUS sockets.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Mon, 2 Jul 2012 18:44:23 +0100
In-Reply-To: <1340988354-26981-10-git-send-email-vincent.sanders@collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
	 <1340988354-26981-10-git-send-email-vincent.sanders@collabora.co.uk>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:45 +0100, Vincent Sanders wrote:
> From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> This patch adds a garbage collector for AF_BUS sockets.
[...]
> +struct sock *bus_get_socket(struct file *filp)
> +{
> +	struct sock *u_sock = NULL;
> +	struct inode *inode = filp->f_path.dentry->d_inode;
> +
> +	/*
> +	 *	Socket ?
> +	 */
> +	if (S_ISSOCK(inode->i_mode) && !(filp->f_mode & FMODE_PATH)) {
> +		struct socket *sock = SOCKET_I(inode);
> +		struct sock *s = sock->sk;
> +
> +		/*
> +		 *	PF_BUS ?
> +		 */
> +		if (s && sock->ops && sock->ops->family == PF_BUS)
> +			u_sock = s;
> +	}
> +	return u_sock;
> +}
[...]

What about references cycles involving both AF_BUS and AF_UNIX sockets?
I think you must either specifically prevent passing AF_UNIX sockets
through AF_BUS sockets, or make a single garbage collector handle them
both.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

