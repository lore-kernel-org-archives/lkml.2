Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1CGXbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:31:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45107
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756512Ab1CGXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:31:00 -0500
Date: Mon, 07 Mar 2011 15:31:37 -0800 (PST)
Message-Id: <20110307.153137.212682178.davem@davemloft.net>
To: rweikusat@mobileactivedefense.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix multithreaded signal handling in unix recv
 routines
From: David Miller <davem@davemloft.net>
In-Reply-To: <877hck43hs.fsf@sapphire.mobileactivedefense.com>
References: <877hck43hs.fsf@sapphire.mobileactivedefense.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Date: Mon, 28 Feb 2011 14:50:55 +0000

> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> 
> The unix_dgram_recvmsg and unix_stream_recvmsg routines in
> net/af_unix.c utilize mutex_lock(&u->readlock) calls in order to
> serialize read operations of multiple threads on a single socket. This
> implies that, if all n threads of a process block in an AF_UNIX recv
> call trying to read data from the same socket, one of these threads
> will be sleeping in state TASK_INTERRUPTIBLE and all others in state
> TASK_UNINTERRUPTIBLE. Provided that a particular signal is supposed to
> be handled by a signal handler defined by the process and that none of
> this threads is blocking the signal, the complete_signal routine in
> kernel/signal.c will select the 'first' such thread it happens to
> encounter when deciding which thread to notify that a signal is
> supposed to be handled and if this is one of the TASK_UNINTERRUPTIBLE
> threads, the signal won't be handled until the one thread not blocking
> on the u->readlock mutex is woken up because some data to process has
> arrived (if this ever happens). The included patch fixes this by
> changing mutex_lock to mutex_lock_interruptible and handling possible
> error returns in the same way interruptions are handled by the actual
> receive-code.
> 
> Signed-off-by: Rainer Weikusat <rweikusat@mobileactivedefense.com>

Looks good, applied, thanks.
