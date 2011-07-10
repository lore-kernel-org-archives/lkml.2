Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab1GJS06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:26:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51418 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab1GJS0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:26:53 -0400
Message-ID: <4E19EEC2.7060806@zytor.com>
Date: Sun, 10 Jul 2011 11:26:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kill handle_signal()->set_fs()
References: <20110710164424.GA20261@redhat.com>
In-Reply-To: <20110710164424.GA20261@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2011 09:44 AM, Oleg Nesterov wrote:
> handle_signal()->set_fs() has a nice comment which explains what
> set_fs() is, but it doesn't explain why it is needed and why it
> depends on CONFIG_X86_64.
> 
> Afaics, the history of this confusion is:
> 
> 	1. I guess today nobody can explain why it was needed
> 	   in arch/i386/kernel/signal.c, perhaps it was always
> 	   wrong. This predates 2.4.0 kernel.
> 
> 	2. then it was copy-and-past'ed to the new x86_64 arch.
> 
> 	3. then it was removed from i386 (but not from x86_64)
> 	   by b93b6ca3 "i386: remove unnecessary code".
> 
> 	4. then it was reintroduced under CONFIG_X86_64 when x86
> 	   unified i386 and x86_64, because the patch above didn't
> 	   touch x86_64.
> 
> Remove it. ->addr_limit should be correct. Even if it was possible
> that it is wrong, it is too late to fix it after setup_rt_frame().
> 

The main reason I could think of why this would be necessary is if we
take an event while we have fs == KERNEL_DS inside the kernel which is
then promoted to a signal.  Are you absolutely sure that can't happen?

In particular, there should be a setting upstream of this, as you're
correctly pointing out that it's too late.  If not, we might actually
have a problem.

	-hpa
