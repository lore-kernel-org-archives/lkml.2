Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1CQNIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1CQNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:08:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Thu, 17 Mar 2011 14:07:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103101720.53782.arnd@arndb.de> <99B09243E1A5DA4898CDD8B70011144810830AB119@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B70011144810830AB119@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171407.58164.arnd@arndb.de>
X-Provags-ID: V02:K0:5fTnGxDIlm0ahZheWFIdjFqgecWPV9oQcHnuT9GiWs0
 +VNI/itnW7tIILB0Av+wN2B3lRDBl3gs2x2MkJT/jI6QdThvBA
 Z2Vu0R56Ck/QqOQXrrXrkZNMSIx5KMpEzkKv+VgEMQDygJniCP
 S3+Q/i8GSTRA4fXBAEAUjTaF97ySqBOz54p/MqVFK3kCF3MXPg
 /uEAcNQloIthuEM/bC5dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >> >Note that the microread_is_busy() logic does not protect you from 
> >> >having multiple concurrent readers, because multiple threads may 
> >> >share a single file descriptor.
> >> 
> >> It's just used to ensure that only one reader can open the device.
> >> It's called only in open callback.
> >> The mutex actually secures concurrent read operations. 
> >
> >So if having multiple readers is safe (though possibly not 
> >meaningful), I guess you don't really need the 
> >microread_is_busy() logic.
> >
> >I suppose it doesn't hurt either, it just seems a bit 
> >pointless when it does the right thing most of the time, but 
> >not always.
> >
> 
> Could you give me an example when the microread_is_busy() logic does
> not do what it's intended to do. I don't really get your point here. 
> 

An application can open the device, and then do a pthread_create()
or a fork(). In either case, you have two concurrent threads that
have access to the file pointer and can read from it concurrently,
which is inherently racy regarding which of the processes gets the
data.

This is not very different from opening the file descriptor in
multiple processes, which you prevent using your logic.

You can of course argue that you try your best to prevent the
race. Traditionally, e.g. on serial ports and the like, we
don't do this but instead rely on user space synchronizing the
access. What you have to make sure of course is that multiple
threads calling read on the same file can never bring the
kernel driver into an invalid state.

	Arnd
