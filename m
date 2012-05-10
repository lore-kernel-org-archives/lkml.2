Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2EJMo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:44:27 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:58442 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2EJMoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:44:25 -0400
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 08:44:25 EDT
Date: Thu, 10 May 2012 14:18:57 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm: take iphdr size into account for esp payload
 size calculation
Message-ID: <20120510121857.GJ1021@secunet.com>
References: <1336602952-10479-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336602952-10479-1-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 May 2012 12:18:57.0303 (UTC) FILETIME=[12C68A70:01CD2EA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:35:52PM -0400, Benjamin Poirier wrote:
> 
> According to what is done, mainly in esp_output(), net_header_len aka
> sizeof(struct iphdr) must be taken into account before doing the alignment
> calculation.

Why do you need to take the ip header into account here? Your patch breaks
pmtu discovery, at least on tunnel mode with aes-sha1 (aes blocksize 16 bytes).

With your patch applied:

tracepath -n 192.168.1.2
 1?: [LOCALHOST]     pmtu 1442
 1:  send failed
 1:  send failed
     Resume: pmtu 1442

Without your patch:

tracepath -n 192.168.1.2
 1?: [LOCALHOST]     pmtu 1438
 1:  192.168.1.2       0.736ms reached
 1:  192.168.1.2       0.390ms reached
     Resume: pmtu 1438 hops 1 back 64 

Your patch increases the mtu by 4 bytes. Be aware that adding
one byte of payload may increase the packet size up to 16 bytes
in the case of aes, as we have to pad the encryption payload
always to a multiple of the cipher blocksize.

> -
> -	switch (x->props.mode) {
> -	case XFRM_MODE_TUNNEL:
> -		break;
> -	default:
> -	case XFRM_MODE_TRANSPORT:
> -		/* The worst case */
> -		mtu -= blksize - 4;
> -		mtu += min_t(u32, blksize - 4, rem);
> -		break;

Btw. why we are doing the calculation above for transport mode?
