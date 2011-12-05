Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1LEFjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:39:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49379 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LEFji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:39:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111204121000.GC12507@redhat.com>
References: <4ED212A1.3060300@redhat.com>
	<1322807192-14147-1-git-send-email-kernelfans@gmail.com>
	<4ED91871.4050904@siemens.com>
	<CAFgQCTvDQ9E5cGVxRP3ZPv8=TmhFqVOdMbcdcSMC8ctR3S+m6A@mail.gmail.com>
	<20111204121000.GC12507@redhat.com>
Date: Mon, 5 Dec 2011 13:39:37 +0800
Message-ID: <CAFgQCTu32fTfV2ZwTy+S4RxD4mr_pq8dddQnttLnSGvYsmh+HQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 4, 2011 at 8:10 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Sun, Dec 04, 2011 at 07:53:37PM +0800, Liu ping fan wrote:
>> On Sat, Dec 3, 2011 at 2:26 AM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> > On 2011-12-02 07:26, Liu Ping Fan wrote:
>> >> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> >>
>> >> Currently, vcpu can be destructed only when kvm instance destroyed.
>> >> Change this to vcpu's destruction taken when its refcnt is zero,
>> >> and then vcpu MUST and CAN be destroyed before kvm's destroy.
>> >
>> > I'm lacking the big picture yet (would be good to have in the change log
>> > - at least I'm too lazy to read the code):
>> >
>> > What increments the refcnt, what decrements it again? IOW, how does user
>> > space controls the life-cycle of a vcpu after your changes?
>> >
>> In local APIC mode, delivering IPI to target APIC, target's refcnt is
>> incremented, and decremented when finished. At other times, using RCU to
> Why is this needed?
>
Suppose the following scene:

#define kvm_for_each_vcpu(idx, vcpup, kvm) \
        for (idx = 0; \
             idx < atomic_read(&kvm->online_vcpus) && \
             (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
             idx++)

------------------------------------------------------------------------------------------>
Here kvm_vcpu's destruction is called
              vcpup->vcpu_id ...  //oops!


Regards,
ping fan



>> protect the vcpu's reference from its destruction.
>>
>> If kvm_vcpu is not needed by guest, user space can close the
>> kvm_vcpu's file
>> descriptors, and then,if the kvm_vcpu has crossed the period of local
>> APCI mode's reference,it will be destroyed.
>>
>> Regards,
>> ping fan
>>
>> > Thanks,
>> > Jan
>> >
>> > --
>> > Siemens AG, Corporate Technology, CT T DE IT 1
>> > Corporate Competence Center Embedded Linux
>
> --
>                        Gleb.
