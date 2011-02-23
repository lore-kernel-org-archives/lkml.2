Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1BWMrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:47:43 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:57020 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753546Ab1BWMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:47:41 -0500
X-Greylist: delayed 2009 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 07:47:41 EST
Message-ID: <4D64FA12.4070800@dresearch.de>
Date: Wed, 23 Feb 2011 13:14:10 +0100
From: Steffen Sledz <sledz@dresearch.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
CC: Mario Schuknecht <m.schuknecht@dresearch.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Fred N. van Kempen" <waltje@uWalt.NL.Mugnet.ORG>,
        Mark Evans <evansmp@uhura.aston.ac.uk>,
        Corey Minyard <wf-rch!minyard@relay.EU.net>,
        Florian La Roche <flla@stud.uni-sb.de>,
        Charles Hedrick <hedrick@klinzhai.rutgers.edu>,
        Linus Torvalds <torvalds@cs.helsinki.fi>,
        Alan Cox <gw4pts@gw4pts.ampr.org>,
        Matthew Dillon <dillon@apollo.west.oic.com>,
        Arnt Gulbrandsen <arnt@gulbrandsen.priv.no>,
        Jorge Cwik <jorge@laser.satlink.net>,
        Matthew Dillon <dillon@crater.dragonflybsd.org>,
        Alan Cox <alc@FreeBSD.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Charles Hedrick <hedrick@rutgers.edu>,
        "" <Fred.van.Kempen@microwalt.nl>
Subject: Re: [PATCH] tcp: ioctl type SIOCOUTQNSD returns amount of data not
 sent
References: <1286271154-18600-1-git-send-email-m.schuknecht@dresearch.de>
In-Reply-To: <1286271154-18600-1-git-send-email-m.schuknecht@dresearch.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Feb 2011 12:14:10.0653 (UTC) FILETIME=[2D55B8D0:01CBD353]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.10.2010 11:32, schrieb Mario Schuknecht:
> In contrast to SIOCOUTQ which returns the amount of data sent
> but not yet acknowledged plus data not yet sent this patch only
> returns the data not sent.
> 
> For various methods of live streaming bitrate control it may
> be helpful to know how much data are in the tcp outqueue are
> not sent yet.
> 
> Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
> ---
>  include/asm-generic/ioctls.h |    1 +
>  include/linux/sockios.h      |    1 +
>  net/ipv4/tcp.c               |    9 +++++++++
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> index a321665..b87115b 100644
> --- a/include/asm-generic/ioctls.h
> +++ b/include/asm-generic/ioctls.h
> @@ -72,6 +72,7 @@
>  #define TCSETXF		0x5434
>  #define TCSETXW		0x5435
>  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
> +#define TIOCOUTQNSD	0x5437
>  
>  #define FIONCLEX	0x5450
>  #define FIOCLEX		0x5451
> diff --git a/include/linux/sockios.h b/include/linux/sockios.h
> index 241f179..4c5ca47 100644
> --- a/include/linux/sockios.h
> +++ b/include/linux/sockios.h
> @@ -23,6 +23,7 @@
>  /* Linux-specific socket ioctls */
>  #define SIOCINQ		FIONREAD
>  #define SIOCOUTQ	TIOCOUTQ
> +#define SIOCOUTQNSD	TIOCOUTQNSD
>  
>  /* Routing table calls. */
>  #define SIOCADDRT	0x890B		/* add routing table entry	*/
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1664a05..c2d52e8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -505,6 +505,15 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  		else
>  			answ = tp->write_seq - tp->snd_una;
>  		break;
> +	case SIOCOUTQNSD:
> +		if (sk->sk_state == TCP_LISTEN)
> +			return -EINVAL;
> +
> +		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
> +			answ = 0;
> +		else
> +			answ = tp->write_seq - tp->snd_nxt;
> +		break;
>  	default:
>  		return -ENOIOCTLCMD;
>  	}

Ping!

It would be nice to get some feedback on this. We really need an extension of this kind.

If the patch does something in a wrong way (esp. choosing the TIOCOUTQNSD id) please give us a hint how to do it in the right way.

Thx,
Steffen Sledz

-- 
DResearch Fahrzeugelektronik GmbH
Otto-Schmirgal-Str. 3, 10319 Berlin, Germany
Tel: +49 30 515932-237 mailto:sledz@DResearch.de
Fax: +49 30 515932-299
Geschäftsführer: Dr. Michael Weber, Werner Mögle;
Amtsgericht Berlin Charlottenburg; HRB 130120 B;
Ust.-IDNr. DE273952058

