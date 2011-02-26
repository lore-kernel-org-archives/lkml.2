Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1BZOhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 09:37:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38054 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1BZOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 09:37:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LLZitxCLiTasi4iHVTeOdT5e6mWBmtAZIBkZz8uPVn305AiwLD5RQmz7fWhlq/prcR
         Svg5v5EBsD5xIt6rvpKDRJ3pAATNnziaR4e/Eanvfd1OOy3mqlKdrmJQpPVk3MS9oLlH
         nwaouoXRSvlqsEBovSreU/agGuFef2DpJCSAE=
Date: Sat, 26 Feb 2011 15:37:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110226143730.GA26864@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been looking through NUMA-affine page table allocation code and
the proposed changes, and there currently are the a couple of
problems.

1. Holes or misaligned nodes will force use of smaller sized mappings.
   Patches to fix the problem have been posted by Yinghai[1].

2. find_early_table_space() always calculates the amount of the needed
   space from 0 to the specified @end.  As nodes are registered, each
   node would try to allocate accumulative amount of space for page
   table.  This probably wouldn't cause any actual problem (may affect
   emulated configurations a bit tho).

IMHO, it would be better to avoid adding fixes for #1 and #2 at this
stage as we're very close to the next merge window and this is
(somewhat unnecessarily) delicate piece of code.  Also, I do think
that the NUMA affine page table allocation is generally overdone given
its limited usefulness when 1GiB mapping is available.

I'd like to revert NUMA-affine page table allocation for now and come
back to it in the next devel cycle.  Thanks to the memblock top-down
change, the RED-PEN condition (page table ending up in DMA memory)
doesn't exist with or without NUMA affine allocation and the only
downside of reverting would be page tables allocated in foreign nodes
on machines which don't support 1GiB mapping.

What do you think?

Thanks.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1104672
