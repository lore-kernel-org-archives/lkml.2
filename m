Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1HXIrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:47:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1HXIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:47:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Date: Wed, 24 Aug 2011 10:46:30 +0200
Message-ID: <73013289.R6WJLciOm2@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E53F750.2050408@suse.cz>
References: <13141210141189@kroah.org> <2337681.paSeVyBarJ@wuerfel> <4E53F750.2050408@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:h8w9lR7TZiyMRee4MHtRPPEj7un2LHiZtmfFMSFHW+/
 O3cDm7vGwwD3lnmgXP54ochHvlRa50Mv14NkvAxstOMhmkcWgf
 at/NsNvZWfLfCk0E08GpzVfRz7k1lRNCLYyW2xKgtubmUf+B5y
 5RsVi3eItxNeltHXzYIktv8KbpttFCUSkAJDpDu30zXAvWvV1N
 7OSGzrdvPoYK4xEu6ilgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 August 2011 20:54:08 Jiri Slaby wrote:
> On 08/23/2011 08:46 PM, Arnd Bergmann wrote:
> > According to http://kernelnewbies.org/BigKernelLock, I concluded back then
> > that tty_wait_until_sent would always be called without BTM held. Has that
> > changed recently, or did I miss a caller that holds the BTM?
> 
> Every tty_operations->close and ->hangup :).

Ah, right, I remember. The chart I did was only to prove that locking was
consistent (i.e. no deadlocks), it ignored that the function needs to be
called without BTM because I had incorrectly convinced myself that the
wait_event_interruptible_timeout() didn't need to release it.

I think I just saw another problem: uart_close takes port->mutex while
holding the BTM, then calls tty_wait_until_sent(). If this releases
and reaquires the BTM, you get an AB-BA deadlock with port->mutex.

	Arnd
