Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2BZXys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:54:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2BZXyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:54:46 -0500
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20120226000630.GC22460@alea.gnuu.de>
Date: Mon, 27 Feb 2012 00:54:44 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B4D3CBBA-2863-4735-A655-563840992518@suse.de>
References: <20111107194838.GA23558@alea.gnuu.de> <20111122200414.GA28205@alea.gnuu.de> <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de> <20120220173844.GA2546@alea.gnuu.de> <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de> <20120221083213.GA19059@alea.gnuu.de> <20120225145115.GB22460@alea.gnuu.de> <20120226000630.GC22460@alea.gnuu.de>
To: =?iso-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.02.2012, at 01:06, Jörg Sommer wrote:

> Jörg Sommer hat am Sat 25. Feb, 15:51 (+0100) geschrieben:
>> Jörg Sommer hat am Tue 21. Feb, 09:32 (+0100) geschrieben:
>>> Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
>>>> On 20.02.2012, at 18:38, Jörg Sommer wrote:
>>>>> Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
>>>>>> On 22.11.2011, at 21:04, Jörg Sommer wrote:
>>>>>>> [1] »kernel BUG at include/linux/kvm_host.h:603!«
>>>>>>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
>>>>>> 
>>>>>> This is unfortunately still there. It's because of preemption being
>>>>>> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
>>>>> 
>>>>> This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getting
>>>>> this Oops, when I start qemu.
>>>> 
>>>> Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I
>>>> fixed a bunch of things with preemption since then and it definitely
>>>> worked for me. If it still fails in that tree, I can try again to
>>>> reproduce it :).
>>> 
>>> This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to build:
>>> 
>>>  CC [M]  arch/powerpc/kvm/book3s_pr.o
>>> arch/powerpc/kvm/book3s_pr.c: In function ‘kvm_vcpu_ioctl_get_one_reg’:
>>> arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:284: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:327: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:459: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:748: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:1112: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:1476: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>> arch/powerpc/kvm/book3s_pr.c:883:1867: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> 
>> @@ -652,6 +653,11 @@ static int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
>>        int r = -EINVAL;
>> 
>>        switch (reg->id) {
>> +#ifdef CONFIG_PPC_BOOK3S
>> +       case KVM_REG_PPC_HIOR:
>> +               r = put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->addr);
>> +               break;
>> +#endif
>>        default:
>>                break;
>>        }
> 
> Is this the right fix for this code?

The idea of the put/get_user is to access memory that is at the address "reg->addr". The code works as expected on book3s_64 for me too, where sizeof(u64) == sizeof(ulong). On book3s_32 however, sizeof(ulong) is 4, which is not the same as the size of reg->addr, which is u64, thus 8.

So we need to tell the compiler to cut off the high 32 bits (because we can't access them anyways) and instead take the lower 32 bits as the pointer at which address we want to access things. That's basically what the patch I sent out earlier today did :).


Alex

