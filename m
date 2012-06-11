Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2FKOtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:49:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36616 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2FKOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:49:38 -0400
Message-ID: <1339426241.4999.62.camel@lappy>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, David Miller <davem@davemloft.net>,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Jun 2012 16:50:41 +0200
In-Reply-To: <1339425693.6001.2268.camel@edumazet-glaptop>
References: <1339423241.4999.53.camel@lappy>
	 <20120611144134.GX22557@sortiz-mobl>
	 <1339425693.6001.2268.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 16:41 +0200, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 16:41 +0200, Samuel Ortiz wrote:
> > Hi Sasha,
> > 
> > On Mon, Jun 11, 2012 at 04:00:41PM +0200, Sasha Levin wrote:
> > > Hi all,
> > > 
> > > I've stumbled on the following while fuzzing with trinity inside a KVM tools guest, running on 3.5-rc2:
> > > 
> > Thanks for the report, it could be worth adding this one to
> > bugzilla.kernel.org.
> > 
> > What's trinity ?
> > Also, if this one is reproducible, would you mind sharing some details about
> > how we could reproduce it ?
> 
> Well, bugfix should be trivial enough ;)
> 
> diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> index ec1134c..208416e 100644
> --- a/net/nfc/rawsock.c
> +++ b/net/nfc/rawsock.c
> @@ -54,11 +54,12 @@ static int rawsock_release(struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
>  
> -	pr_debug("sock=%p\n", sock);
> -
> -	sock_orphan(sk);
> -	sock_put(sk);
> +	pr_debug("sock=%p sk=%p\n", sock, sk);
>  
> +	if (sk) {
> +		sock_orphan(sk);
> +		sock_put(sk);
> +	}
>  	return 0;
>  }

Eric, Is there something that documents at what state each of the
callbacks in the network subsystem can be called? Like a big flow chart
of some sorts?

I'm asking because I've looked at this as well before sending this mail,
and while the fix does look trivial, I wasn't sure whether it is really
the correct fix, or the problem is that this callback wasn't supposed be
called at all so something else is broken (we had such issue with
namespaces and unshare() not long ago).



