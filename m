Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2E3PFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2E3PFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:05:37 -0400
Message-ID: <4FC62C33.7080509@redhat.com>
Date: Wed, 30 May 2012 17:18:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <4FBB7185.6040105@redhat.com> <alpine.LFD.2.02.1205221919260.3231@ionos> <4FBCFDD1.5050405@redhat.com> <alpine.LFD.2.02.1205232037220.3231@ionos> <4FBD39BE.8040101@zytor.com> <alpine.LFD.2.02.1205232210440.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205232210440.3231@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 01:00 AM, Thomas Gleixner wrote:

> Thought more about that.
> 
> We have a clear distinction between HW accessed data and software
> accessed data.
> 
> If I look at TPR then it is special cased already and it does:
> 
>    case APIC_TASKPRI:
>                 report_tpr_access(apic, false|true);
>                 /* fall thru */
> 
> And the fall through is using the general accessor for all not special
> cased registers.
> 
> So all you have to do is 
> 
>    case APIC_TASKPRI:
>                 report_tpr_access(apic, false|true);
> +		return access_mapped_reg(...);
> 
> Instead of the fall through.
> 
> So there is no synchronizing back and forth problem simply because you
> already have a special case for that register.
> 
> I know you'll argue that the tpr reporting is a special hack for
> windows guests, at least that's what the changelog tells.
> 
> But even if we have a few more registers accessed by hardware and if
> they do not require a special casing, I really doubt that the overhead
> of special casing those few regs will be worse than not having the
> obvious optimization in place.
> 
> And looking deeper it's a total non issue. The apic mapping is 4k. The
> register stride is strictly 0x10. That makes a total of 256 possible
> registers.
> 
> So now you have two possibilites:
> 
> 1) Create a 256 bit == 64byte bitfield to select the one or the other
>    representation.
> 
>    The overhead of checking the bit is not going to be observable.
> 
> 2) Create a 256 function pointer array == 2k resp. 1k (64 / 32bit)
> 
>    That's not a lot of memory even if you have to maintain two
>    separate variants for read and write, but it allows you to get rid
>    of the already horribly compiled switch case in apic_read/write and
>    you'll get the optional stuff like report_tpr_access() w/o extra
>    conditionals just for free.
> 
>    An extra goodie is that you can catch any access to a non existing
>    register which you now just silently ignore.  And that allows you
>    to react on any future hardware oddities without adding a single
>    runtime conditional.
> 
>    This is stricly x86 and x86 is way better at dealing with indirect
>    calls than with the mess gcc creates compiling those switch case
>    constructs.
> 
>    So I'd go for that and rather spend the memory and the time in
>    setting up the function pointers on init/ioctl than dealing with
>    the inconsistency of HW/SW representation with magic hacks.
> 

I like the bitmap version, it seems very lightweight.  But by itself it
doesn't allow us to use bitmap_weight (or the other bitmap accessors),
unless you assume beforehand that those registers will never be in the
hardware-layout region.

(you also need extra code for copying the APIC state to and from
userspace; right now we just memcpy the APIC page)


-- 
error compiling committee.c: too many arguments to function
