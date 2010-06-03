Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0FCXN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:13:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0FCXN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:13:57 -0400
Date: Thu, 3 Jun 2010 16:09:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603155414.6ebd1d78@nehalam>
Message-ID: <alpine.LFD.2.00.1006031606040.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam> <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org> <20100603120313.10a73b20@nehalam> <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
 <20100603144913.24828629@nehalam> <alpine.LFD.2.00.1006031455280.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006031515030.8175@i5.linux-foundation.org> <20100603155414.6ebd1d78@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> 
> Thank you for confirming my suspicions.  Given the state of destruction
> there, bug fixing is like playing Jenga.

I suspect it's fixable, but it would probably involve a lot of careful 
moving around of that "floppy_lock" spinlock. Add various asserts to make 
sure that it's held in all cases, and then for each warning you get, you 
add the proper spinlock until it's all properly protected.

The _original_ protection was just from irqs being atomic (UP, remember), 
and the block layer queueing happening from irq-safe context. You're still 
running it on UP, but we've even lost the irq-handler protection (and then 
later, the bottom-half mutual exclusion).

			Linus
