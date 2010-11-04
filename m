Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0KDGHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:07:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65374 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0KDGHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uJF5d4+J9232CY/CQERkbtmXCiuBrHTuJhZlq9COTzv2POmNqkm89UQxN3Yd65dUsX
         C6lbqzF+DVNEwW6LgZWrZNlAPdM6U7Ns3AD4wHa7A1zz09mDtfQjFoGaENZzMziDnSB6
         dzJ3JBN0CuhtNhEaw7Jk6wN/Y9ahse8BJWi68=
Subject: Re: out of memory error from kernel when I open hundred of
 thousands of TCP connections
From: Eric Dumazet <eric.dumazet@gmail.com>
To: springzhong <davidmahorse@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1288850316.5575.1.camel@zhongjiu>
References: <1288850316.5575.1.camel@zhongjiu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 07:07:01 +0100
Message-ID: <1288850821.2718.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 13:58 +0800, springzhong a écrit :
> The source of serve is like:
> ListeningThread listeningThread(this, nPortNum);
> listeningThread.nPortNum=6475;
> listeningThread.Start();
> ListeningThread listeningThread2(this, 6476);
> listeningThread2.nPortNum=6476;
> listeningThread2.Start();
> ListeningThread listeningThread3(this, 6477);
> listeningThread3.nPortNum=6477;
> listeningThread3.Start();
> ListeningThread listeningThread4(this, 6477);
> listeningThread4.nPortNum=6478;
> listeningThread4.Start();
> 
> The source of client is like:
> for (int i = 0; i < 60000; i++)
> {
> this->Connect("127.0.0.1", nPortNum, false, pClientSocket);
> this->Connect("127.0.0.1", 6476, false, pClientSocket);
> this->Connect("127.0.0.1", 6477, false, pClientSocket);
> this->Connect("127.0.0.1", 6478, false, pClientSocket);
> }
> 
> I want to test the maximum tcp connections of linux in my netbook with
> 2G memeory.
> But I just found It cannot exceed 240000 connections.Then an 
> "out of memory error" occured. But it looks like there is still a lot of
> free memory in my computer.
> 
> I want to rechange the kernel to accept more TCP connections like one
> million tcp connections in my network.
> But I find there are too many source codes in it. 
> Could you give me any suggestions?
> I have changed my environment like this with epoll:
> /etc/security/limits.conf
> * soft nofile 802400
> * hard nofile 802400
> # End of file
> 
> cat /proc/sys/fs/file-max
> 2204218
> 
> cat /etc/sysctl.conf
> net.ipv4.ip_local_port_range = 1024 65000
> 
> cat /proc/sys/fs/epoll/max_user_watches
> 2500873
> 
> It is not the limitation of file ids of linux.It is an error from kernel
> of LINUX
> 

If you run a 32bit kernel, you probably hit a LOWMEM limit : sockets
structures are kernel structures, allocated from LOWMEM zone.
This is about 900 MBytes in 32bit kernel, even if you have 4GB of total
ram.

grep Low /proc/meminfo

If your netbook has 2GB of memory, you could compile a kernel with a
2G/2G User/Kernel split

CONFIG_VMSPLIT_2G=y



