Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1HIRF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:05:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47962 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1HIRF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <4E416716.1040904@zytor.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
 <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
 <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
 <4E416716.1040904@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 13:05:07 -0400
X-Google-Sender-Auth: JqhyUWuj6QAlTCtnRtS5lupg-48
Message-ID: <CAObL_7FzTisOGJLP7wGUKDCO6qJ20-kaMFWdjm0a+dKpNWBe3g@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 12:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/09/2011 10:22 AM, Andrew Lutomirski wrote:
>>
>> In any case, my patch fixes DynamoRIO but not pin.  Pin dies with:
>>
>> [ 4988.945491] test_vsyscall[4587] emulated vsyscall from bogus
>> address -- fix your code nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88
>> ax:ffffffffff600000 si:0 di:400d0a
>> [ 4988.945497] test_vsyscall[4587] vsyscall fault (exploit attempt?)
>> nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88 ax:ffffffffff600000 si:0
>> di:400d0a
>>
>> and I don't know what's going on.  I suspect that the tracer assumes
>> that int 0x40 continues execution at the next instruction.
>>
>> x86 maintainers: I can think of a few choices:
>>
>> 1. Stick a ret instruction in the vsyscall page.  Downside: now
>> there's an unrestricted ret instruction in the vsyscall page.
>>
>
> How much worse is a ret instruction over the INT instructions that
> modifies very little of the register state and then rets?

I'm far from an expert in exploit writing, but I suspect it's
sometimes an additional challenge to make sure that esi and edi are
valid pointers before jumping into the vsyscall.  That's why I added
the code that turns EFAULT into SIGSEGV.

>
>> 3. Apply my patch and assume that the number of users that would
>> benefit from a more complete fix is close to zero, since pin won't
>> even try to run on 3.0 or 3.1 without gross hacks.  (Pin is prerelease
>> software and apparently actively maintained by people who make it very
>> hard for non-users to contact, but I'm trying.)
>
> Since pin is going to have to be fixed anyway to run on 3.x, it seems
> reasonable to me that they can just fix their vsyscall handling at the
> same time.
>
> Now, the multimodal patch seems reasonable, too.
>
> I think to some extent there are no actually good solutions here, just
> varying degrees of bad.  Being able to completely disable vsyscall
> without having to recompile seems attractive, though.

Agreed.

I have a rather minimal vm that actually works with vsyscall=none.  If
you like that patch, I can send it on top of the patch it depends on.
I could also try to keep it from wasting one page of memory for the
unused image by playing some initdata games or otherwise freeing
whichever page isn't selected.

--Andy
