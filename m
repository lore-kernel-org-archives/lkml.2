Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab2CBKBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:01:35 -0500
Received: from mail.us.es ([193.147.175.20]:42246 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab2CBKBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:01:33 -0500
Date: Fri, 2 Mar 2012 11:01:28 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: santosh nayak <santoshprasadnayak@gmail.com>, bart.de.schuymer@pandora.be,
        kaber@trash.net, shemminger@vyatta.com, davem@davemloft.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Resend [PATCH] netfilter: Fix copy_to_user too small size
 parametre.
Message-ID: <20120302100128.GA12266@1984>
References: <1330621743-12883-1-git-send-email-santoshprasadnayak@gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B6E87@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E87@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 09:05:10AM -0000, David Laight wrote:
>  
> > -	if (copy_to_user(hlp, m->u.match->name, 
> > EBT_FUNCTION_MAXNAMELEN))
> > +	char name[EBT_FUNCTION_MAXNAMELEN] = {};
> > +
> > +	strncpy(name, m->u.match->name, sizeof(name));
> > +	if (copy_to_user(hlp, name, EBT_FUNCTION_MAXNAMELEN))
> >  		return -EFAULT;
> 
> strncpy() is very rarely the function you are looking for.
> In this case it MIGHT be right (since you do a fixed size
> copy_to_user).
> OTOH there is no need to also initialise name[].

We have to make sure that array is filled with zeros for the gap
between byte 29 and byte 32 due to backward compatibility issues.

I'll mangle the patch to add some comment close to strncpy and to
explain the way we're doing this.

> And it isn't entirely clear whether the application
> is allowed to be given a non-terminated string.

Match names are 29 bytes long, while ebtables expects 32 bytes. So
we're copying less bytes.

We can add the final \0 if you feel more confortable, but that string
is going to be null-terminated the way the code look now.
