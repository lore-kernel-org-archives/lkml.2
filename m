Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1ATVky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:40:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34840 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab1ATVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vYXCsS0Mv+4uxiWUzg0h2YS3j8EkPspP2cTWhOhw1cQ3sTRGAcGhtKvRLB4qm/EbF/
         IwiBknCw5sEbfjk7LLDSNfvoAZVJvngkLw5sALOJ7iqGHJPOixErASNvSFDa3DVi/jHp
         sugFre28RHgTbqBM5JaXVwCC/RpoGo9dqN6Rw=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com>
References: <20110119.180418.216749267.davem@davemloft.net>
	 <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 22:40:46 +0100
Message-ID: <1295559646.2613.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 janvier 2011 à 13:12 -0800, Linus Torvalds a écrit :



>   ...
>   read(3, 0x9806500, 4096)                = -1 EAGAIN (Resource
> temporarily unavailable)
>   poll([{fd=4, events=POLLIN}, {fd=3, events=POLLIN}, {fd=12,
> events=POLLIN|POLLPRI}, {fd=14, events=POLLIN|POLLPRI}, {fd=9,
> events=POLLIN|POLLPRI}, {fd=10, events=POLLIN|POLLPRI}, {fd=15,
> events=POLLIN}, {fd=16, events=POLLIN}, {fd=17, events=0}, {fd=19,
> events=POLLIN}], 10, -1) = ? ERESTART_RESTARTBLOCK (To be restarted)
>   restart_syscall(
> 

Hmm, poll() here on fd=3 only asks events=POLLIN

> and that's it - it's now hung. So why did it work when I straced it
> while hung? And why is it doing that ERESTART_RESTARTBLOCK in the
> first place, I'm not seeing any signals there?
> 
> So I tried sending it a useless signal, which will re-animate the
> strace, and now I get:
> 
>   restart_syscall(<... resuming interrupted call ...>) = 1
>   --- SIGWINCH (Window changed) @ 0 (0) ---
>   poll([{fd=3, events=POLLIN|POLLOUT}], 1, -1) = 1 ([{fd=3, revents=POLLOUT}])
> 

Then here ask for fd=3 both POLLIN and POLLOUT :
kernel answers : OK for POLLOUT (not POLLIN), so previous poll() call
was OK to be blocked after all...

So I'm wondering if it could be a userland bug, that triggers with
recent kernel changes.



