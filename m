Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1BHFJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:09:52 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35303 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1BHFJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HmLA0wXJ3IdK3j3svFyUqG4snjlquHG+Wp9ce9q9rwYq1ufS5BbmsUmhM8nNSUa7MV
         /WBY9aQSGRrPPJOvKXrWxeJIVv5jzzUGiHo6Efb+lY21ql9/SwgNw5wFIbr8DX8OMU4f
         DDJiB99tA4vgrZyCvnbwOmEL7EwYwv1848jF8=
MIME-Version: 1.0
In-Reply-To: <4D50CCFA.1040004@goop.org>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
	<4D4A3782.3050702@zytor.com>
	<alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
	<4D4ADFAD.7060507@zytor.com>
	<alpine.DEB.2.00.1102041130060.7277@kaball-desktop>
	<4D4CA568.70907@goop.org>
	<AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com>
	<4D4E4E0D.2080806@zytor.com>
	<4D4EF553.6000000@kernel.org>
	<alpine.DEB.2.00.1102071524140.7277@kaball-desktop>
	<4D50343E.1020906@kernel.org>
	<alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
	<4D504161.2060900@kernel.org>
	<4D506A85.9030802@goop.org>
	<4D50B4B5.4050505@kernel.org>
	<4D50CCFA.1040004@goop.org>
Date: Mon, 7 Feb 2011 21:09:50 -0800
X-Google-Sender-Auth: yAZbvCkTbL2_QmUshcNb8-ZcMVM
Message-ID: <AANLkTi=koyyz8h1A3qWbp2F+N3kA46rJfHPSPN+Ms8hm@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
From: Yinghai Lu <yinghai@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 8:56 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 02/07/2011 07:12 PM, Yinghai Lu wrote:
>> On 02/07/2011 01:56 PM, Jeremy Fitzhardinge wrote:
>>> On 02/07/2011 11:00 AM, Yinghai Lu wrote:
>>>> On 02/07/2011 10:58 AM, Stefano Stabellini wrote:
>>>>> On Mon, 7 Feb 2011, Yinghai Lu wrote:
>>>>>> On 02/07/2011 08:50 AM, Stefano Stabellini wrote:
>>>>>>> On Sun, 6 Feb 2011, Yinghai Lu wrote:
>>>>>>>> On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
>>>>>>>>> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>>>>>>>>>> why not just move calling cleanup_highmap down?
>>>>>>>>>>
>>>>>>>>>> something like attached patch.
>>>>>>>>> This patch looks very clean and looks on the surface of it like it is
>>>>>>>>> removing some ugly ad hoc code, but (as always) it needs a description
>>>>>>>>> about the problem it solves and why it is correct.
>>>>>>>> Sure.
>>>>>>>>
>>>>>>>>
>>>>>>>> Jeremy and xen guys, can you please check if it works well with xen ?
>>>>>>>>
>>>>>>> Actually this patch makes things worse on xen, because before
>>>>>>> cleanup_highmap() wasn't called at all on xen (on purpose) and now it
>>>>>>> is, fully destroying all the mappings we have at _end.
>>>>>>>
>>>>>>> Can we add a check on memblock reserved regions in cleanup_highmap()?
>>>>>>> Otherwise could we avoid calling cleanup_highmap() at all on xen?
>>>>>> why DO xen need over-mapped kernel initial mapping?
>>>>>>
>>>>>> what is in that range after _end to 512M?
>>>>> The mfn list that is the list of machine frame numbers assigned to this
>>>>> domain; it is used across the kernel to convert pfns into mfns.
>>>>> It passed to us at that address by the domain builder.
>>>> is it possible for you to pass physical address, and then map it in kernel?
>>> That is possible in principle, but very difficult in practice.
>>>
>>> What's wrong with honouring reserved memory ranges under all circumstances?
>> why punishing native path with those checking?
>
> Why is it punishing anyone to expect memory reservations to be observed?
>
>> please check if
>>
>> +      * max_pfn_mapped is set to KERNEL_IMAGE_SIZE >> PAGE_SHIFT in
>> +      *   head64.c::x86_start_kernel(), aka native path
>> +      */
>> +     if (max_pfn_mapped != (KERNEL_IMAGE_SIZE >> PAGE_SHIFT))
>> +             return;
>>
>> could be used to skip clear highmap for xen path?
>
> Seems pretty ad-hoc.
>

then what is size for mfn-list after _end...

could be copied or move to BRK.

Yinghai
