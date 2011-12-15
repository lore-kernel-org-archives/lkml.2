Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab1LOI6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:58:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34835 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1LOI6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:58:06 -0500
Message-ID: <4EE9B694.1000905@gmail.com>
Date: Thu, 15 Dec 2011 16:57:56 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Liu ping fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, jan.kiszka@web.de
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com> <1323923328-917-1-git-send-email-kernelfans@gmail.com> <4EE9869F.4070702@linux.vnet.ibm.com> <CAFgQCTu_S9=ve1=FTZ-BHaXExqPhtPu2D92Gy=85XaZw=e81bQ@mail.gmail.com> <4EE9AF0F.9040206@linux.vnet.ibm.com>
In-Reply-To: <4EE9AF0F.9040206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 04:25 PM, Xiao Guangrong wrote:

> On 12/15/2011 02:53 PM, Liu ping fan wrote:
> 
> 
>>
>>>> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +     if (vcpu == NULL)
>>>> +             return NULL;
>>>> +     if (atomic_add_unless(&vcpu->refcount, 1, 0))
>>>
>>>
>>> Why do not use atomic_inc()?
>>> Also, i think a memory barrier is needed after increasing refcount.
>>>
>> Because when refcout==0, we prepare to destroy vcpu, and do not to
>> disturb it by increasing the refcount.
> 
> 
> Oh, get it.
> 


But i think we can do it like this:

On the vcpu free path:

hold kvm->lock
delete vcpu from the kvm->vcpus
release kvm->lock

synchronize_rcu()
kvm_vcpu_put()

then, we can avoid get invalid instance and it can make the code simple?
