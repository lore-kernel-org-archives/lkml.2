Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0KYHOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:14:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43603 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0KYHOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:14:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V191ynILg3+urYu/y3LkjN1oqA7Hv0BCiCZwsHkTaZR6FxdLMzTjqqRdXYOSkZRgB5
         53D+tPMj4B1sTwcuUdgok7HT9zQwcSdIq12YH8UK8Lt9IYlm2VNlVaeXB/FnuFcTQWVn
         DYaKNiyG1Y9tMn0H4SmsxX0B0yTyn2VbjMK4M=
Subject: Re: Simple kernel attack using socketpair. easy, 100%
 reproductiblle, works under guest. no way to protect :(
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=D0=9C=D0=B0=D1=80=D0=BA_?=
	 =?UTF-8?Q?=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
	<socketpair@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <1290666501.2798.84.camel@edumazet-laptop>
References: <AANLkTikCeddPFRGojPGuB6oq3xGYgovtm8r4=WhjEDpe@mail.gmail.com>
	 <1290666501.2798.84.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 08:14:02 +0100
Message-ID: <1290669242.2798.110.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 07:28 +0100, Eric Dumazet a écrit :

> 
> Since you obviously read recent mails on this subject yesterday, why
> dont you Cc netdev ?
> 
> There is a very easy way to protect against this actually.
> 
> A patch was posted yesterday, and need some adjustements.
> 
> 
> diff --git a/net/unix/garbage.c b/net/unix/garbage.c
> index c8df6fd..40df93d 100644
> --- a/net/unix/garbage.c
> +++ b/net/unix/garbage.c
> @@ -259,9 +259,16 @@ static void inc_inflight_move_tail(struct unix_sock *u)
>  }
>  
>  static bool gc_in_progress = false;
> +#define UNIX_INFLIGHT_TRIGGER_GC 2000
>  
>  void wait_for_unix_gc(void)
>  {
> +	/*
> +	 * If number of inflight sockets is insane,
> +	 * force a garbage collect right now.
> +	 */
> +	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
> +		unix_gc();
>  	wait_event(unix_gc_wait, gc_in_progress == false);
>  }
>  
> 

Hmm... it seems its another problem, chains are very long so we hit a
NMI watchdog.

I guess we should limit to a very small number, like 64, or rewrite the
garbage collector to a better algo.



