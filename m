Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab1EXXFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:05:07 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:57346 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab1EXXFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:05:05 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <4DDC31DF.5010303@zytor.com>
References: <1306269105.21443.20.camel@dan>  <4DDC31DF.5010303@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 19:04:56 -0400
Message-ID: <1306278296.1921.10.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 15:31 -0700, H. Peter Anvin wrote:
> On 05/24/2011 01:31 PM, Dan Rosenberg wrote:
> > This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> > which the kernel is decompressed at boot as a security feature that
> > deters exploit attempts relying on knowledge of the location of kernel
> > internals.  The default values of the kptr_restrict and dmesg_restrict
> > sysctls are set to (1) when this is enabled, since hiding kernel
> > pointers is necessary to preserve the secrecy of the randomized base
> > address.
> > 
> > This feature also uses a fixed mapping to move the IDT (if not already
> > done as a fix for the F00F bug), to avoid exposing the location of
> > kernel internals relative to the original IDT.  This has the additional
> > security benefit of marking the new virtual address of the IDT
> > read-only.
> 
> As written, I think this is unsafe, simply because the kernel has no
> idea what memory is actually safe to relocate into, and your code
> doesn't actually make any attempt at doing so.
> 
> The fact that you change CONFIG_PHYSICAL_ALIGN is particularly
> devastating, and will introduce boot failures on real systems.
> 
> For this to be acceptable, you need to at the very least:
> 
> 1. Verify the in the address map passed to the kernel where it is safe
>    to locate the kernel;

I'll do this, thanks.

> 2. Not introduce a performance regression (we avoid locating in the
>    bottom 16 MiB for performance reasons, except on very small systems);

I altered the boot code so that it uses CONFIG_PHYSICAL_START, which
defaults to 16 MiB, as a lower bound on location.  So nothing will ever
get loaded below there, and I still can take advantage of higher
alignment granularity.  Are there other problems I'm not anticipating?

> 3. Make sure not to break kdump.
> 

Ok, I'll be sure to add this to the list of things to test.

Thanks for the feedback.

-Dan


