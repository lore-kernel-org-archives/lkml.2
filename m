Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2BALCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:02:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab2BALCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:02:03 -0500
Message-ID: <4F291B92.8070402@redhat.com>
Date: Wed, 01 Feb 2012 13:01:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com>  <1328017807.2446.230.camel@twins>  <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp>
In-Reply-To: <4F291B56.30600@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 01:00 PM, Takuya Yoshikawa wrote:
>
>> rcu_assign_pointer), and use atomic operations to copy and clear:
>>
>>    word = bitmap[i]
>>    put_user(word)
>>    atomic_and(&bitmap[i], ~word)
>>
>>
>
> This kind of this was really slow IIRC.
>
>
> How about just doing:
>
> take a spin_lock
> copy the entire (or some portions of) bitmap locally
> clear the bitmap
> unlock
>

That means that vcpus dirtying memory also have to take that lock, and
spin while the bitmap is being copied.  So kvm_vm_ioctl_get_dirty_log()
will become faster, at the expense of vcpus, which I think is a bad
tradeoff.

> write protect the dirty pages based on the copied dirty data
>
> copy_to_user
>
>
>
> I can show you some performance numbers, this weekend, if you like.

That'll be great, numbers are better than speculation.

-- 
error compiling committee.c: too many arguments to function

