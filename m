Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0LIXsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:48:09 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15751 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0LIXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:48:08 -0500
Date: Fri, 10 Dec 2010 00:41:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH RESEND] x86/irq: assign vectors from numa_node
In-Reply-To: <20101209224830.GH20481@sgi.com>
Message-ID: <alpine.LNX.2.00.1012100036090.25880@swampdragon.chaosbits.net>
References: <20101209224830.GH20481@sgi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Arthur Kepner wrote:

> 
> (Resending with expanded cc list.)
> 
> Several drivers (e.g., mlx4_core) do something similar to:
> 
> 	err = pci_enable_msix(pdev, entries, num_possible_cpus());
> 
> which takes us down this code path:
> 
> 	pci_enable_msix
> 	native_setup_msi_irqs
> 	create_irq_nr
> 	__assign_irq_vector
> 
> __assign_irq_vector() preferentially uses vectors from low-numbered 
> CPUs. On a system with a large number (>256) CPUs this can result in 
> a CPU running out of vectors, and subsequent attempts to assign an 
> interrupt to that CPU will fail.
> 
> The following patch prefers vectors from the node associated with the 
> device (if the device is associated with a node). This should make it 
> far less likely that a single CPU's vectors will be exhausted.
> 

I'm not going to pretend that I know this code *at all*, but what you 
wrote made me think, and I want to share my thoughts. Perhaps they are 
useful, perhaps not.

Assigning to the CPU associated with a device sounds sane and sounds like 
it will distribute things more. So far so good. But I can't help wondering 
if it wouldn't be sane (besides doing this) to simply fall back to the 
next higher CPU if the chosen one is exhausted (or wrap around to the 
first one if we are already at the highest one)... So that we'll only fail 
completely if *all* CPU's are exhausted..?


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

