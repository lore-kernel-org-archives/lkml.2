Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0LACnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:43:07 -0500
Received: from eastrmmtao103.cox.net ([68.230.240.9]:64511 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0LACnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:43:06 -0500
X-VR-Score: -235.00
X-Authority-Analysis: v=1.1 cv=f2Wgv+KVwlvowBhtJCNWyh9ERg7KylIyDx2PcquLkk4=
 c=1 sm=1 a=8nJEP1OIZ-IA:10 a=PNuEMszh5xg2EB3JV8u8OQ==:17 a=pGLkceISAAAA:8
 a=iE-e0aDHAAAA:8 a=i4umUFy8n_ICKVjxqz8A:9 a=GwSF5JYlSIlJIn0SI7MA:7
 a=tSdps0qc7GLS6dKzFGeJWKguPPgA:4 a=wPNLvfGTeEIA:10 a=MSl-tDqOz04A:10
 a=cLqIjics26UGNhcI:21 a=lvhUrqGJ2KeuGS-u:21 a=PNuEMszh5xg2EB3JV8u8OQ==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
Date: Tue, 30 Nov 2010 21:43:02 -0500
From: Mike Blumenkrantz <mike@zentific.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2 epoll questions
Message-ID: <20101130214302.3e0ca37a@darc.ath.cx>
In-Reply-To: <1291100631.2725.39.camel@edumazet-laptop>
References: <20101129191705.094f5c4d@darc.ath.cx>
	<1291100631.2725.39.camel@edumazet-laptop>
Organization: Zentific
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 08:03:51 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le lundi 29 novembre 2010 à 19:17 -0500, Mike Blumenkrantz a écrit :
> > Hi,
> > 
> > I am not subscribed to the list yet, and I would appreciate it if all
> > replies could be CCed to me :).
> > 
> > I have two questions regarding epoll.  The epoll code that I am using can
> > all be found in the file here for those interested:
> > https://svn.enlightenment.org/svn/e/trunk/ecore/src/lib/ecore/ecore_main.c
> > 
> > 1) Is there any known reason why adding fds to an epoll fd would begin to
> > slow down dramatically after ~6000 fds are added?  It is entirely possible
> > that the problem is not epoll at all, but I wanted to ask and see if there
> > was some O(n) code somewhere that was known.
> > 
> 
> No particular slowdown, I once used more than 1.5 million fds in epoll
> fd.
> 
> Of course, if you only add/remove fds as fast as possible, its going to
> be slower, since epoll fds are stored in a tree, and the time of
> insert/delete of one item depends on the tree depth. Maybe this is your
> case and your working set is larger than your cpu caches after ~6000
> fds ?
Upon hearing that you have successfully used 1.5 million fds, I began analyzing
the code further and discovered one remaining instance of O(n) code.  Upon
removal, execution proceeded as expected for O(1) during runtime.
> 
> 
> > 2) If a select on an epoll fd (not one inside the epoll, the actual epoll fd
> > itself) returns EBADF, is there a way to determine which fd is causing the
> > error and then remove it?  I am occasionally running into this issue, and it
> > seems to be caused by code which I do not necessarily control closing a fd
> > that is part of my epoll fd without my knowledge (meaning that the closed
> > fd is still in epoll).
> 
> Strange, I never got this EBADF error. On epoll_ctl() or epoll_wait() ?
> (I dont understand your "select on epoll fd"). epoll is meant to replace
> select()...
In some cases, you cannot use epoll_wait because you are using fds from other
libraries which you do not control (here we have integrated glib's main loop
into our own, and so are monitoring fds which we do not directly own).  In
these cases, you must use select instead.
> 
> When you close a file descriptor, its automatically removed from epoll
> as well.

-- 
Mike Blumenkrantz
Zentific: Our boolean values are huge.
