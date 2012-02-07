Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2BGGNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:13:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35807 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2BGGNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F30AA7E.3020803@oss.ntt.co.jp>
References: <1328582057-31549-1-git-send-email-kernelfans@gmail.com>
	<4F30AA7E.3020803@oss.ntt.co.jp>
Date: Tue, 7 Feb 2012 14:13:33 +0800
Message-ID: <CAFgQCTte3g0xz6pQ0CT8J5En_L5yzQE8DTOfoU6q9pG9F2AOeg@mail.gmail.com>
Subject: Re: [PATCH v8] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        xiaoguangrong.eric@gmail.com, jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/7 Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>:
> (2012/02/07 11:34), Liu Ping Fan wrote:
>
>>   static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>
> Is this a hot path?
> If no, do you really need to pre-allocate the space for the next vcpus?
>
No, it is not a hot path, I will try your way in next version.

>>   {
>> +     int i;
>>       struct kvm_vcpu *vcpu = filp->private_data;
>> +     struct kvm *kvm = vcpu->kvm;
>> +     struct kvm_vcpu *vcpus_next;
>> +     filp->private_data = NULL;
>> +
>> +     for (i = 0; i<  atomic_read(&kvm->online_vcpus); i++) {
>> +             if (vcpu == kvm->vcpus+i)
>> +                     break;
>> +     }
>> +     mutex_lock(&kvm->lock);
>> +     vcpus_next =  kvm->vcpus_array +
>> +             ((kvm->vcpus - kvm->vcpus_array) ? 0 : KVM_MAX_VCPUS);
>> +
>> +     memset(vcpus_next, 0, KVM_MAX_VCPUS*sizeof(struct kvm_vcpu *));
>> +     memcpy(vcpus_next, kvm->vcpus, i*sizeof(struct kvm_vcpu *));
>> +     memcpy(vcpus_next+i, kvm->vcpus+i+1,
>> +             (atomic_read(&kvm->online_vcpus)-i)*sizeof(struct kvm_vcpu *));
>> +     atomic_dec(&kvm->online_vcpus);
>> +     /* Removed vcpu can not be seen from vcpus[] */
>
> This comment is confusing.
>
I mean after assigning pointer, vcpu which to be removed can not be
seen from vcpus[]. I will fix this comment.
>> +     rcu_assign_pointer(kvm->vcpus, vcpus_next);
>> +     mutex_unlock(&kvm->lock);
>> +
>> +     synchronize_rcu();
>>
>> -     kvm_put_kvm(vcpu->kvm);
>> +     /* vcpu is out of list,drop it safely */
>
> Ditto.
>
> Do you mean something like
> "now that there is no reader of it we can safely free this" ?
>
Yes, that is exactly what I mean

Thanks and regards,
ping fan

> (Please do not trust me:  I am not a native English speaker as you know.)
>
>> +     kvm_vcpu_destruct(vcpu);
>>       return 0;
>>   }
>
>
>        Takuya
