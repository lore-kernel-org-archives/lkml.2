Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1GFRTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:19:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1GFRTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:19:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=mbiPzRsdG0ITfi92wuZ1b1WommEqxGQUmoUPhRwyPlhLnScToHFqcjhXCZsba6tsi
	+pD82WRBfp1f3+3CsPPrg==
MIME-Version: 1.0
In-Reply-To: <4E0F0835.4090104@gmail.com>
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org>
 <1309483720-1407-4-git-send-email-sergiu@chromium.org> <4E0E0D03.2080203@gmail.com>
 <BANLkTim_TVCq-oStBmLVVEPb5SRkA-HS7SuejXYn1kn1F+CwaA@mail.gmail.com>
 <4E0ED041.9030802@gmail.com> <CAGDaqBQSeWxhWU53rBnY8t61ueSh9=RkqTLqnAUjA28Lub8HdA@mail.gmail.com>
 <4E0F0835.4090104@gmail.com>
From: Sergiu Iordache <sergiu@chromium.org>
Date: Wed, 6 Jul 2011 10:18:37 -0700
X-Google-Sender-Auth: QzUdOCHPfIL3tGHutAokAdQSOQE
Message-ID: <CAGDaqBROm=nWEU2QP7TTeeYoiBj5MEet5X5tzfYXJa7i4EAVpw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] char drivers: ramoops debugfs entry
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 4:59 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Il 02/07/2011 11:01, Sergiu Iordache ha scritto:
>>
>> On Sat, Jul 2, 2011 at 1:01 AM, Marco Stornelli
>> <marco.stornelli@gmail.com>  wrote:
>
>>>
>>>
>>> It was easy because the record size had a fixed length (4096), so maybe
>>> at
>>> this point it can be sufficient the record size information. I see a
>>> little
>>> problem however. I think we could use debugfs interface to dump the log
>>> in
>>> an easy way but we should be able to dump it even with /dev/mem.
>>> Specially
>>> on embedded systems, debugfs can be no mounted or not available at all.
>>> So
>>> maybe, as you said below, with these new patches we need a memset over
>>> all
>>> the memory area when the first dump is taken. However, the original idea
>>> was
>>> to store even old dumps. In addition, there's the problem to catch an
>>> oops
>>> after a start-up that "clean" the area before we read it. At that point
>>> we
>>> lost the previous dumps. To solve this we could use a "reset" paramater,
>>> but
>>> I think all of this is a little overkilling. Maybe we can only bump up
>>> the
>>> record size if needed. What do you think?
>>
>> The problem with a fixed record size of 4K is that it is not very
>> flexible as some setups may need more dump data (and 4K doesn't mean
>> that much). Setting the record size via a module parameter or platform
>> data doesn't seem as a huge problem to me if you are not using debugfs
>> as you should be able to somehow export the record size (since you
>> were the one who set it through the parameter in the first place) and
>> get the dumps from /dev/mem.
>
> The point here is not how to set record size, but what it does mean to have
> a variable record size compared with the current situation. However, if we
> know that there are situation where 4k are not sufficient, ok we can modify
> it.
Well right now I don't see any major disadvantages in making it
configurable as long as the present behavior is preserved (no set
record_size -> set it to 4K). Are there any other things to consider?

>> I've thought more about this problem today and I have thought of the
>> following alternative solution: Have a debugfs entry which returns a
>> record size chunk at a time by starting with the first entry and then
>> checking each of the entries for the header (and the presence of the
>> timestamp maybe to be sure). It will then return each entry that is
>> valid skipping over the invalid ones and it will return an empty
>> result when it reaches the end of the memory zone. It could also have
>> an entry to reset to the first entry so you can start over. This way
>> you wouldn't lose old entries and you could still get a pretty easy to
>> parse result.
>>
>
> It seems a good strategy for me.
I'll implement this and come back with a patch.

Sergiu
