Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0EKFuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:50:22 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33316 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0EKFuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:50:16 -0400
Message-ID: <4BE8F0F2.60706@oss.ntt.co.jp>
Date: Tue, 11 May 2010 14:53:54 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
       agraf@suse.de, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/12] KVM: introduce new API for getting/switching
 dirty bitmaps
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <20100504220821.d68bde57.takuya.yoshikawa@gmail.com> <20100511034329.GB3458@amt.cnet>
In-Reply-To: <20100511034329.GB3458@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/11 12:43), Marcelo Tosatti wrote:
> On Tue, May 04, 2010 at 10:08:21PM +0900, Takuya Yoshikawa wrote:
>> +How to Get
>> +
>> +Before calling this, you have to set the slot member of kvm_user_dirty_log
>> +to indicate the target memory slot.
>> +
>> +struct kvm_user_dirty_log {
>> +	__u32 slot;
>> +	__u32 flags;
>> +	__u64 dirty_bitmap;
>> +	__u64 dirty_bitmap_old;
>> +};
>> +
>> +The addresses will be set in the paired members: dirty_bitmap and _old.
>
> Why not pass the bitmap address to the kernel, instead of having the
> kernel allocate it. Because apparently you plan to do that in a new
> generation anyway?

Yes, we want to make qemu allocate and free bitmaps in the future.
But currently, those are strictly tied with memory slot registration and
changing it in one patch set is really difficult.

Anyway, we need kernel side allocation mechanism to keep the current
GET_DIRTY_LOG api. I don't mind not exporting kernel allocated bitmaps
in this patch set and later introducing a bitmap registration mechanism
in another patch set.

As this RFC is suggesting, kernel side double buffering infrastructure is
designed as general as possible and adding a new API like SWITCH can be done
naturally.

>
> Also, why does the kernel need to know about different bitmaps?

Because we need to support current GET API. We don't have any way to get
a new bitmap in the case of GET and we don't want to do_mmap() every time
for GET.

>
> One alternative would be:
>
> KVM_SWITCH_DIRTY_LOG passing the address of a bitmap. If the active
> bitmap was clean, it returns 0, no switch performed. If the active
> bitmap was dirty, the kernel switches to the new bitmap and returns 1.
>
> And the responsability of cleaning the new bitmap could also be left
> for userspace.
>

That is a beautiful approach but we can do that only when we give up using
GET api.


I follow you and Avi's advice about that kind of maintenance policy!
What do you think?
