Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0DTLHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:07:04 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50687 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0DTLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NW3wgiDCgjJ9csiNsazty0Al1+lIpa6D9QYXx1RKTHaJsr5dVRYlT1LGJqFTqbhaJK
         jzseND+3Wty6z6/UIdddbJKzZLQXE85A4cZjxnnmwFssEcnEtAxm9sYgcUVsejxyvWEf
         CDo8K+wbnblhBCq4/Ib4w3uRWjYzij576Fph0=
Subject: Re: A possible bug in reqsk_queue_hash_req()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Li Yu <raise.sail@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <i2x9b948ee41004200335vc229a59cvc0a08c35c949d7dd@mail.gmail.com>
References: <i2x9b948ee41004200335vc229a59cvc0a08c35c949d7dd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 13:06:51 +0200
Message-ID: <1271761611.3845.223.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 avril 2010 à 18:35 +0800, Li Yu a écrit :
> Hi,
> 
>      I found out a possible bug in reqsk_queue_hash_req(), it seem
> that we should move "req->dl_next = lopt->syn_table[hash];" statement
> into follow write lock protected scope.
> 
>      As I browsed source code, this function only can be call at rx
> code path which is protected a spin lock over struct sock , but its
> caller (  inet_csk_reqsk_queue_hash_add() ) is a GPL exported symbol,
> so I think that we'd best move this statement into below write lock
> protected scope.
> 
>      Below is the patch to play this change, please do not apply it on
> source code, it's just for show.
> 
>     Thanks.
> 
> Yu
> 
> --- include/net/request_sock.h  2010-04-09 15:27:14.000000000 +0800
> +++ include/net/request_sock.h        2010-04-20 18:11:32.000000000 +0800
> @@ -247,9 +247,9 @@ static inline void reqsk_queue_hash_req(
>         req->expires = jiffies + timeout;
>         req->retrans = 0;
>         req->sk = NULL;
> -       req->dl_next = lopt->syn_table[hash];
> 
>         write_lock(&queue->syn_wait_lock);
> +       req->dl_next = lopt->syn_table[hash];
>         lopt->syn_table[hash] = req;
>         write_unlock(&queue->syn_wait_lock);
>  }

I believe its not really necessary, because we are the only possible
writer at this stage.

The write_lock() ... write_unlock() is there only to enforce a
synchronisation with readers.

All callers of this reqsk_queue_hash_req() must have the socket locked



