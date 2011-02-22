Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1BVOZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:25:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab1BVOZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:25:31 -0500
Message-ID: <4D63C753.3030906@redhat.com>
Date: Tue, 22 Feb 2011 16:25:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 4/7] KVM: sort memslots and use binary search to search
 the right slot
References: <4D636EF8.60800@cn.fujitsu.com> <4D636FE8.8000505@cn.fujitsu.com>
In-Reply-To: <4D636FE8.8000505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:12 AM, Xiao Guangrong wrote:
> Sort memslots then search the slot with binary search to speed up the
> slot searching
>

I'm not sure if a binary search is the right algorithm here.  It 
introduces a lot of branches which may be mispredicted.

Options we've discussed are:

- Sort slots by size, use linear search (so the largest slots are found 
quickly)
- Weighted balanced tree 
http://en.wikipedia.org/wiki/Weight-balanced_tree, use weight == slot size

Both options still make the miss case (mmio) slow.  We could cache the 
result of a miss in an spte by using a reserved bit, and checking the 
page fault error code (or seeing if we get an ept violation or ept 
misconfiguration), so if we get repeated mmio on a page, we don't need 
to search the slot list/tree.

-- 
error compiling committee.c: too many arguments to function

