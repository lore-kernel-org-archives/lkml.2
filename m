Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0C2Q14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0C2Q1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:27:55 -0400
Message-ID: <4BB0D500.1090409@redhat.com>
Date: Mon, 29 Mar 2010 12:27:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: KVM bug, git bisected
References: <4BADFD74.8060904@gmail.com> <4BB0D11A.607@redhat.com>
In-Reply-To: <4BB0D11A.607@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 12:11 PM, Rik van Riel wrote:
> On 03/27/2010 08:43 AM, Kent Overstreet wrote:
>> commit 5beb49305251e5669852ed541e8e2f2f7696c53e
>> Author: Rik van Riel <riel@redhat.com>
>> Date: Fri Mar 5 13:42:07 2010 -0800
>>
>> mm: change anon_vma linking to fix multi-process server scalability issue
>>
>> I get this when starting kvm. The warning hasn't caused me problems, but
>> I've also been getting a scheduling while atomic panic when I start kvm
>> that I can only reproduce when I don't want to. It's definitely config
>> dependent, I'd guess preempt might have something to do with it.
>
>  From your trace, it looks like mm_take_all_locks is taking close
> to 256 locks, which is where the preempt_count could overflow into
> the softirq count.
>
> Since kvm-qemu is exec'd, I am guessing you have a very large
> number of VMAs in your qemu process. Is that correct?

I just took a look at a qemu-kvm process on my own system.

It has a staggering 385 VMAs!

That definately has the potential of overflowing PREEMPT_BITS
when undergoing mm_take_all_locks...

> Peter, would it be safe to increase PREEMPT_BITS to eg. 10?

Looks like we'll have to.   At least on 64 bits...
