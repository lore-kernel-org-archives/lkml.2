Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937980Ab0CPRWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:22:24 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61508 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759919Ab0CPRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ak/iDzeodQ8yviaiVdLcyxR4ZqQWbePsPm7lnspFw89oI7mrqSEtfpYaUj2shSjxi5
         9sYe/jcu99lfOt+ta8FX1UrETWcU7B75/tH2IjPVYpGXrct2wFL+o8zRKrv0WijNiG6Z
         e4DSBG+K0NmU4MWlVz0ilX1a/V98G6PNAaUhc=
Message-ID: <4B9FBE49.6010709@gmail.com>
Date: Tue, 16 Mar 2010 18:22:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.4 Thunderbird/3.1b1
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Jiri Slaby <jslaby@suse.cz>, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel Borkmann <danborkmann@googlemail.com>
Subject: Re: [PATCH 1/1] NET: netpoll, fix potential NULL ptr dereference
References: <1268753394-17765-1-git-send-email-jslaby@suse.cz> <1268759527.25503.2980.camel@calx>
In-Reply-To: <1268759527.25503.2980.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 06:12 PM, Matt Mackall wrote:
> I don't get it. The source of the branch tests for !ndev->npinfo and the
> original destination of the branch also tests for !ndev->npinfo. I don't
> see how it gets dereferenced.

Let's look at more of the context:
         if (!ndev->npinfo) {
                 npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
                 if (!npinfo) {         // npinfo is NULL
                         err = -ENOMEM;
                         goto release;
                 }
...
release:                           // npinfo is still NULL
         if (!ndev->npinfo) {       // condition is the same (holds)
              // dereference below: vvvvvvvvvvvvvvv
                 spin_lock_irqsave(&npinfo->rx_lock, flags);
                 list_for_each_entry_safe(npe, tmp, &npinfo->rx_np, rx) {
                         npe->dev = NULL;
                 }
                 spin_unlock_irqrestore(&npinfo->rx_lock, flags);

                 kfree(npinfo);
         }

thanks,
-- 
js
