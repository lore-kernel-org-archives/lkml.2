Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0J3OuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:50:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59698 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0J3Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KhqHwIJmeFqRZxWpzgwjZfX6tZNg2juPK0zofHTo1evHVR8ShxeG9bOZX1tVg3b3c+
         hodcux3qLiQh8EdzYltq33EKjpga3fd7xNdtj9YsQAt/xMVnwkB5wNBGH42ujfLS6TpA
         HzCoCU0SpUeMKLyIoVcjqfv35lO5iQ1ZVid3Y=
Date: Sat, 30 Oct 2010 18:49:51 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: sock: fix information leak to userland
Message-ID: <20101030144951.GA25135@albatros>
References: <1288448801-6303-1-git-send-email-segooon@gmail.com>
 <1288449350.2680.970.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288449350.2680.970.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 16:35 +0200, Eric Dumazet wrote:
> Le samedi 30 octobre 2010 à 18:26 +0400, Vasiliy Kulikov a écrit :
> > "Address" variable might be not fully initialized in sock->ops->get_name().
> > The only current implementation is get_name(), it leaves some padding
> > fields of sockaddr_tipc uninitialized.  It leads to leaking of contents
> > of kernel stack memory.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  Compile tested.
> > 
> >  net/core/sock.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 3eed542..759dd81 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -930,6 +930,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
> >  	{
> >  		char address[128];
> >  
> > +		memset(&address, 0, sizeof(address));
> >  		if (sock->ops->getname(sock, (struct sockaddr *)address, &lv, 2))
> >  			return -ENOTCONN;
> >  		if (lv < len)
> 
> ???
> 
> Please fix the real bug.

What if somebody want to create his own implementation of getname()?
IMO it's much safer to introduce memset() here and relax getname()'s
responsibilities.  Quite many drivers "forget" to initialize outputs
structures.  E.g. new net_device's private field is kzalloc'ed to
simplify driver's code.

-- 
Vasiliy
