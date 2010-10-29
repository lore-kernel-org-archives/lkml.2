Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab0J2T1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:27:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0J2T1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dABudc5YUrq5HMEzSlnVdF6hb+tP1OszWeIFO+DUTwXAyT5pTlQv/82FJizTKncxOv
         nYnB3oscuGBNt0iVLW/GaItEz0gFAvYJzGVpiLoYbqOuqY+IXykzN/8sCPnpJ4R3r5aE
         giDKuTx+jKqjqZr3W6XR1lQHCVWqwBYSxeRq8=
Subject: Re: [PATCH 0/1] RFC: poll/select performance on datagram sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>
In-Reply-To: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 21:27:11 +0200
Message-ID: <1288380431.2680.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 octobre 2010 à 19:18 +0100, Alban Crequy a écrit :
> Hi,
> 
> When a process calls the poll or select, the kernel calls (struct
> file_operations)->poll on every file descriptor and returns a mask of
> events which are ready. If the process is only interested by POLLIN
> events, the mask is still computed for POLLOUT and it can be expensive.
> For example, on Unix datagram sockets, a process running poll() with
> POLLIN will wakes-up when the remote end call read(). This is a
> performance regression introduced when fixing another bug by
> 3c73419c09a5ef73d56472dbfdade9e311496e9b and
> ec0d215f9420564fc8286dcf93d2d068bb53a07e.
> 
> The attached program illustrates the problem. It compares the
> performance of sending/receiving data on an Unix datagram socket and
> select(). When the datagram sockets are not connected, the performance
> problem is not triggered, but when they are connected it becomes a lot
> slower. On my computer, I have the following time:
> 
> Connected datagram sockets: >4 seconds
> Non-connected datagram sockets: <1 second
> 
> The patch attached in the next email fixes the performance problem: it
> becomes <1 second for both cases. I am not suggesting the patch for
> inclusion; I would like to change the prototype of (struct
> file_operations)->poll instead of adding ->poll2. But there is a lot of
> poll functions to change (grep tells me 337 functions).
> 
> Any opinions?

My opinion would be to use epoll() for this kind of workload.

Also, about unix_datagram_poll() being slow, it probably can be
addressed separately.



