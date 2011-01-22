Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1AVI7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 03:59:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37143 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1AVI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 03:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aeq0rIhg/qz58/7z5pnd4+8m3Zo0fpaYRkhQPU3bC8jJYLBr5HNzs0q7WPifVFNwxm
         zlRYIB8XpWO0lL6LFbneaScl4Fc6yY6UhCfyGy8XafkhmfjjD6g3JMLFSXjAvvht4MUG
         GFBr+vd9dKNe6qLQYAvwpn3TF703CHHaOkhNQ=
Subject: Re: Problems with /proc/net/tcp6  - possible bug - ipv6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: PK <runningdoglackey@yahoo.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <702550.61465.qm@web63902.mail.re1.yahoo.com>
References: <702550.61465.qm@web63902.mail.re1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 09:59:41 +0100
Message-ID: <1295686781.2609.37.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 janvier 2011 à 22:30 -0800, PK a écrit :
> Creating many ipv6 connections hits a ceiling on connections/fds ; okay, fine.
> 
> But in my case I'm seeing millions of entries spring up within a few seconds and 
> then vanish within a few minutes, in /proc/net/tcp6 (vanish due to garbage 
> collection?)
> 
> Furthermore I can trigger this easily on vanilla kernels from 2.6.36 to 
> 2.6.38-rc1-next-20110121  inside a ubuntu 10.10 amd64 vm, causing the kernel to 
> spew warnings.  There is also some corruption in the logs (see kernel-sample.log 
> line 296), but that may be unrelated.
> 
> More explanation, kernel config of the primary machine I saw this on, sample 
> ruby script to reproduce (inside the ubuntu VMs I apt-get and use ruby-1.9.1), 
> are located at
> https://github.com/runningdogx/net6-bug
> 
> Seems to only affect 64-bit.  So far I have not been able to reproduce on 32-bit 
> ubuntu VMs of any kernel version.
> Seems to only affect IPv6.  So far I have not been able to reproduce using IPv4 
> connections (and watching /proc/net/tcp of course).
> Does not trigger the bug if the connections are made to ::1.  Only externally 
> routable local and global IPv6 addresses seem to cause problems.
> Seems to have been introduced between 2.6.35 and 2.6.36 (see README on github 
> for more kernels I've tried)
> 
> All the tested Ubuntu VMs are stock 10.10 userland, with vanilla kernels (the 
> latest ubuntu kernel is 2.6.35-something, and my initial test didn't show it 
> suffering from this problem)
> 
> Originally noticed on separate Gentoo 64-bit non-vm system when doing web 
> benchmarking.
> 
> not subscribed, so please keep me in cc although I'll try to follow the thread
> 
> 

Hi PK (Sorry, your real name is hidden)

I could not reproduce this on current linux-2.6 kernel.

How many vcpus running in your VM, and memory ?

Note : a recent commit did fix /proc/net/tcp[6] behavior

commit 1bde5ac49398a064c753bb490535cfad89e99a5f
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu Dec 23 09:32:46 2010 -0800

    tcp: fix listening_get_next()
    
    Alexey Vlasov found /proc/net/tcp could sometime loop and display
    millions of sockets in LISTEN state.
    
    In 2.6.29, when we converted TCP hash tables to RCU, we left two
    sk_next() calls in listening_get_next().
    
    We must instead use sk_nulls_next() to properly detect an end of chain.
    
    Reported-by: Alexey Vlasov <renton@renton.name>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


