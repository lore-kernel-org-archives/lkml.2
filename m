Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1FVTBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:01:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596Ab1FVTBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G6xkmarbcs9usJ4PLAzwJO5T+fYHwW/KAIzbhNppQ38jO0mhBARzqQA1w5rCJh0RW+
         lbEh29krAFUeeDwBXf1w==
MIME-Version: 1.0
In-Reply-To: <4E0230CD.1030505@zytor.com>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110622110034.89ee399c.akpm@linux-foundation.org>
	<4E0230CD.1030505@zytor.com>
Date: Wed, 22 Jun 2011 12:01:50 -0700
Message-ID: <BANLkTinMrMcDw8KX3BxmZh12-kULmecT-s9gdRGpYUCfNjFO7Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Nancy Yuen <yuenn@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, rick@vanrein.org, rdunlap@xenotime.net,
        Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:13, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/22/2011 11:00 AM, Andrew Morton wrote:
>> :
>> : Second, the BadRAM patch expands the address patterns from the command
>> : line into individual entries in the kernel's e820 table.  The e820
>> : table is a fixed buffer that supports a very small, hard coded number
>> : of entries (128).  We require a much larger number of entries (on
>> : the order of a few thousand), so much of the google kernel patch deals
>> : with expanding the e820 table.
>
> This has not been true for a long time.

Good point.  There's the MAX_NODES that expands it, though it's still
hard coded, and as I understand, intended for NUMA node entries.  We
need anywhere from 8K to 64K 'bad' entries.  This creates holes and
translates to twice as many entries in the e820.  We only want to
allow this memory if it's needed, instead of hard coding it.

>
>> I have a couple of thoughts here:
>>
>> - If this patchset is merged and a major user such as google is
>>   unable to use it and has to continue to carry a separate patch then
>>   that's a regrettable situation for the upstream kernel.
>>
>> - Google's is, afaik, the largest use case we know of: zillions of
>>   machines for a number of years.  And this real-world experience tells
>>   us that the badram patchset has shortcomings.  Shortcomings which we
>>   can expect other users to experience.
>>
>> So.  What are your thoughts on these issues?
>
> I think a binary structure fed as a linked list data object makes a lot
> more sense.  We already support feeding e820 entries in this way,
> bypassing the 128-entry limitation of the fixed table in the zeropage.
>
> The main issue then is priority; in particular memory marked UNUSABLE
> (type 5) in the fed-in e820 map will of course overlap entries with
> normal RAM (type 1) information in the native map; we need to make sure
> that the type 5 information takes priority.
>
>        -hpa
>
