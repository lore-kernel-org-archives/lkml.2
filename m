Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881Ab0J2UUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:20:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39578 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab0J2UUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PevTgsoIG7O0cz87ggGRhdf9xFfsSuCHZY+Udilf7jbcCclu64a3nWMwGkllBesGpX
         /SyWFZuWz2ocGnZWP9iMV9d0QKO6jBmlALwgCaaXwwmmV6si70xgpF9g+lcCYjKwieKR
         D1QMRB9x73FkHljMFv7m0DHWoq3QhLGU9yCb8=
Subject: Re: [PATCH 0/1] RFC: poll/select performance on datagram sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Alban Crequy <alban.crequy@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>
In-Reply-To: <alpine.DEB.2.00.1010291306390.8517@davide-lnx1>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
	 <1288380431.2680.3.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1010291306390.8517@davide-lnx1>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 22:20:14 +0200
Message-ID: <1288383614.2680.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 octobre 2010 à 13:08 -0700, Davide Libenzi a écrit :

> Yeah, epoll does check for event hints coming with the callback wakeup, 
> and avoid waking up epoll_wait() waiters, for non matching events.
> Most of the devices we care about, have been modified to report the event 
> mask with the wakeup call.

Alban test program is _very_ pathological :

All the time is consumed in do_select() because of false sharing between
two tasks.

We can probably rearrange variables in do_select() to make this false
sharing less problematic. I am taking a look at this.

Events: 3K cycles
+     26.14%  uclient  [kernel.kallsyms]  [k] do_raw_spin_lock              
+     21.11%  uclient  [kernel.kallsyms]  [k] do_select                     
+     13.38%  uclient  [kernel.kallsyms]  [k] pollwake                      
+      9.22%  uclient  [kernel.kallsyms]  [k] unix_dgram_poll               
+      5.24%  uclient  [kernel.kallsyms]  [k] unix_peer_get                 
+      3.04%  uclient  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore   
+      3.03%  uclient  [kernel.kallsyms]  [k] task_rq_lock                  
+      2.85%  uclient  [kernel.kallsyms]  [k] do_raw_spin_unlock            
+      1.84%  uclient  [kernel.kallsyms]  [k] try_to_wake_up                
+      1.55%  uclient  [kernel.kallsyms]  [k] fget_light                    
+      1.34%  uclient  [kernel.kallsyms]  [k] core_kernel_text              


annotate :

   5.66 :        410fb342:       85 ff                   test   %edi,%edi                  
    0.00 :        410fb344:       74 1f                   je     410fb365 <do_select+0x3d5> 
    0.13 :        410fb346:       85 b5 6c fd ff ff       test   %esi,-0x294(%ebp)          
    0.00 :        410fb34c:       74 17                   je     410fb365 <do_select+0x3d5> 
         :                                                        res_out |= bit;           
    0.00 :        410fb34e:       09 b5 5c fd ff ff       or     %esi,-0x2a4(%ebp)          
         :                                                        retval++;                 
    0.00 :        410fb354:       83 85 64 fd ff ff 01    addl   $0x1,-0x29c(%ebp)          
         :                                                        wait = NULL;              
    0.00 :        410fb35b:       c7 85 7c fd ff ff 00    movl   $0x0,-0x284(%ebp)          
    0.00 :        410fb362:       00 00 00                                                  
         :                                               }            
         :                                                if ((mask & POLLEX_SET) && (ex & bit)) {
   43.27 :        410fb365:       85 d2                   test   %edx,%edx                 
    0.00 :        410fb367:       0f 84 f3 fe ff ff       je     410fb260 <do_select+0x2d0>
    0.00 :        410fb36d:       85 b5 74 fd ff ff       test   %esi,-0x28c(%ebp)         
    0.00 :        410fb373:       0f 84 e7 fe ff ff       je     410fb260 <do_select+0x2d0>
         :                                                        res_ex |= bit;           
    0.00 :        410fb379:       09 b5 58 fd ff ff       or     %esi,-0x2a8(%ebp)         
         :                                if (all_bits == 0) {   
         :                                        i += __NFDBITS;
         :                                        continue;
         :                                }


