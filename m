Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0CWChJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:37:09 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:59571 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0CWChH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DbchEk3DCOZSp70C4GCVJ12xxSQffZnLC7qIwQp9Drd9xBlBBBLj9E054SQSlRRy9y
         e6p6h1I7rr3GVPY+tTdeWt11SVPi8SY/e0pl9qDriHidhTJPxG4Y+IpHX743cNyQrQQz
         t6eNhLSCO/Z2tphN3sUeHRGZ3iG1wLMEiXPe4=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
	 <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
Date: Tue, 23 Mar 2010 10:37:06 +0800
Message-ID: <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
From: wzt wzt <wzt.wzt@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patrick's point is that you're using "if (get.size >= INT_MAX /
> sizeof(struct ipt_get_entries))"
> So, did you find any chance that get.size * sizeof(struct
> ipt_get_entries) >= INT_MAX ?
>
would you carefully read my explain???
get.size is copy from the user space,  it can be set as 0x7fffffff,
addition with sizeof(struct ipt_get_entries) can be overflow.

> And, for the addition overflow, can it be caught by
>
> "if (*len != sizeof(struct ipt_get_entries) + get.size)"  ???
>
sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
get.size is control by user space with copy_from_user().

On Tue, Mar 23, 2010 at 10:29 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Tue, Mar 23, 2010 at 9:34 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
>>> I can see that the size might cause an overflow in the addition with
>>> sizeof(struct ipt_get_entries)
>> That's the integer overflow i pointed.
>> get.size is copy from the user space,  it can be set as 0x7fffffff,
>> addition with sizeof(struct ipt_get_entries) can be overflow.
>
> Patrick's point is that you're using "if (get.size >= INT_MAX /
> sizeof(struct ipt_get_entries))"
> So, did you find any chance that get.size * sizeof(struct
> ipt_get_entries) >= INT_MAX ?
>
> And, for the addition overflow, can it be caught by
>
> "if (*len != sizeof(struct ipt_get_entries) + get.size)"  ???
>
>>
>>        if (*len != sizeof(struct ipt_get_entries) + get.size) {
>>                duprintf("get_entries: %u != %zu\n",
>>                         *len, sizeof(get) + get.size);
>>                return -EINVAL;
>>        }
>>
>> so, check get.size max value before addition with sizeof(struct
>> ipt_get_entries) to prevent the integer overflow.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
