Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1F1CH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:07:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39403 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab1F1CGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:06:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E093725.7010002@jp.fujitsu.com>
Date: Tue, 28 Jun 2011 11:06:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: kkourt@cslab.ece.ntua.gr
CC: bkk@cslab.ece.ntua.gr, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-numa@vger.kernel.org
Subject: Re: [BUG] Invalid return address of mmap() followed by mbind() in
 multithreaded context
References: <4DFB710D.7000902@cslab.ece.ntua.gr> <20110627171842.GA7554@solar.cslab.ece.ntua.gr>
In-Reply-To: <20110627171842.GA7554@solar.cslab.ece.ntua.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/28 2:18), Kornilios Kourtis wrote:
> 
> Hi,
> 
> On Fri, Jun 17, 2011 at 06:21:49PM +0300, Vasileios Karakasis wrote:
>> Hi,
>>
>> I am implementing a multithreaded numa aware code where each thread
>> mmap()'s an anonymous private region and then mbind()'s it to its local
>> node. The threads are performing a series of such mmap() + mbind()
>> operations. My program crashed with SIGSEGV and I noticed that mmap()
>> returned an invalid address.
> 
> I've taken a closer look at this issue.
> 
> As Vasileios said, it can be reproduced by having two threads doing the
> following loop:
> | for {
> | 	addr = mmap(4096, MAP_ANONUMOUS)
> | 	if (addr == (void *)-1)
> | 		continue
> | 	mbind(addr, 4096, 0x1) // do mbind on first NUMA node
> | }
> After a couple of iterations, mbind() will return EFAULT, although the addr is
> valid.
> 
> Doing a bisect, pins it down to the following commit (Author added to To:):
> 	9d8cebd4bcd7c3878462fdfda34bbcdeb4df7ef4
> 	mm: fix mbind vma merge problem
> Which adds merging of vmas in the mbind() path.
> Reverting this commit, seems to fix the issue.
> 
> I 've added some printks to track down the issue, and EFAULT is returned on:
> mm/mempolicy.c: mbind_range()
> |   vma = find_vma_prev(mm. start, &prev);
> |   if (!vma |vma->vm_start > start)
> |       return EFAULT;
> Where: vma->start > start
> 
> I am not sure what exactly happens, but concurrent merges and splits
> of (already mapped) VMAs do not seem to work well together.

Hi

Thank you for digging this! I look it at soon as far as possible.

 - kosaki

