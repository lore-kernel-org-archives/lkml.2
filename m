Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab0E0UDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:03:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47647 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355Ab0E0UDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:03:45 -0400
Message-ID: <4BFECFEB.6040308@zytor.com>
Date: Thu, 27 May 2010 13:02:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 2/3] sys_personality: make sure (int)personality >= 0
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153613.GC13858@redhat.com>
In-Reply-To: <20100527153613.GC13858@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 08:36 AM, Oleg Nesterov wrote:
> Not sure about this patch. The kernel/libc part is correct, but
> since user-space declares "int personality(unsigned long persona)"
> the current behaviour can confuse the (poor written) applications
> even on 64-bit machines.
> 
> Consider:
> 
> 	personality(0xffffffff - 1);	// == (int)-2
> 
> 	...
> 
> 	int ret = personality(0);	// returns the old personality
> 	if (ret < 0)
> 		oops_we_cant_set_PER_LINUX(errno);
> 
> And, since libc correctly detects the successful return from syscall,
> errno is random.
> 
> Change sys_personality() to ensure personality can not look like a
> negative int. This disallows the MSB, it is not used for PER_ flags.
> 
> Suggested-by: Wenming Zhang <wezhang@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I'm fine with this, even though it is indeed there to support extremely
poorly written applications (error is specifially -1, not < 0).

However, since we almost certainly have enough brokenness in here, and
since there definitely don't seem to be a whole lot of demand for new
personality bits, I'm more than happy to waste bit 31 at not having to
deal with it, ever.

However, it would be better if we returned -EINVAL on attempts to set
*any* of the reserved bits, not just bit 31.

	-hpa
