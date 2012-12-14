Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2LNAPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:15:19 -0500
Received: from atl.turmel.org ([74.117.157.138]:53410 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab2LNAPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:15:15 -0500
Message-ID: <50CA6E04.1070105@turmel.org>
Date: Thu, 13 Dec 2012 19:08:36 -0500
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121103 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Andreas Voellmy <andreas.voellmy@yale.edu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: epoll with ONESHOT possibly fails to deliver events
References: <BC680BE9-F6EB-4278-819C-C552009CA884@yale.edu> <AF8622CA-CF9D-4F57-B4EB-FE088A752D80@yale.edu> <20121213093242.GA25436@dcvr.yhbt.net>
In-Reply-To: <20121213093242.GA25436@dcvr.yhbt.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 04:32 AM, Eric Wong wrote:
> Andreas Voellmy <andreas.voellmy@yale.edu> wrote:

[trim /]

>>> Another thread, distinct from all of the threads serving particular
>>> sockets, is perfoming epoll_wait calls. When sockets are returned as
>>> being ready from an epoll_wait call, the thread signals to the
>>> condition variable for the socket.
> 
> Perhaps there is a bug in the way your epoll_wait thread
> uses the condition variable to notify other threads?

Have you considered the possibility that data is arriving between
epoll_ctl and pthread_cond_wait ?  If your monitoring thread returns
from epoll_wait within this race window, it will call
pthread_cond_signal while the first thread is not yet waiting for it.
With the one-shot flag, the next iteration of epoll_wait won't see that
socket's new data.

Phil
