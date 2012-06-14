Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2FNTaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:30:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40682 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2FNT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:29:59 -0400
Message-ID: <4FDA3BB4.9040607@wwwdotorg.org>
Date: Thu, 14 Jun 2012 13:29:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: swarren@nvidia.com, linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk, kay@vrfy.org
Subject: Re: Follow-up to remaining issue with alignment of __log_buf in printk.c
References: <87aa05vgzg.fsf@free.fr>
In-Reply-To: <87aa05vgzg.fsf@free.fr>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 01:19 PM, Robert Jarzmik wrote:
> 
> Hi Stephen and others,
> 
> I have a XScale PXA based board with has the alignement issue which makes the
> kernel trap during its early stage.
> 
> I wonder what is the status now, is there a fix available ?
> 
> I have tracked what happens on PXA. The pxa is an ARM v5TE chip. The new printk
> version you submitted is translated to the following assembly on the line :
>         msg->ts_nsec = local_clock();
> Into:
> => 0xc001bbe0 <log_store+496>:	strd	r0, [r4, r5]
> 
> In ARMv5, the "strd" assembly opcode expects the address to be 64bits aligned,
> hence the bug.
> 
> Now the solutions I have seen so far in the mailing lists :
>  - #define LOG_ALIGN (__alignof__(u64))
>    Does always work.
>  - #define LOG_ALIGN (__alignof__(struct log))
>    Doesn't work with my toolchain, as __alignof__(struct log) is 4, not 8

Isn't that a bug in the toolchain; isn't the alignment of a struct
required to be the greatest alignment of any of its members? Otherwise,
this problem could arise with any usage of that struct.

I suppose this could be worked around with something like:

#define LOG_ALIGN max(__alignof__(struct log), __alignof__(u64))
