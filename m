Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0CWFtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 01:49:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49340 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0CWFtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 01:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WfS8zc3mb3dAny0CjEA3RwcWFyYR1w9CtrdqRyB/ZDv83EmmYXz5qp4Mzf+vcziqks
         E/bPoD/eV1pITJVgOZYemveov4YYY97HYZf2E1L8cm1MTglZEGrbx0lKUWd259TII0HE
         SItUJebPJR78r7eEWeQX4yFLQWFLm+DqEBaYw=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a51003222149v5346c3eje94ed1182b207206@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
	 <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
	 <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
	 <alpine.LSU.2.01.1003230346010.12017@obet.zrqbmnf.qr>
	 <628d1651003222048k1eaf6929r81fd06e401190e0@mail.gmail.com>
	 <7b6bb4a51003222149v5346c3eje94ed1182b207206@mail.gmail.com>
Date: Tue, 23 Mar 2010 13:49:38 +0800
Message-ID: <628d1651003222249w45be1559u6a29406cb1e749a6@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
From: wzt wzt <wzt.wzt@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You didn't get his point... The key point is that sizeof() result type
> is size_t, slightly modify you code, try the result.
>> int main(void)
>> {
>>        unsigned int arg = 0xffffffff;
>>        unsigned int foo;
>>        printf("%lu\n", arg + sizeof(foo));
>>        if (sizeof(foo) - 1 != arg + sizeof(foo)) {
>>                printf("not over flow.\n");
>>                return -1;
>>        }
>>        printf("arg over flow.\n");
>>
>>        return 0;
>> }

sizeof() is size_t(unsigned int), get.size is also unsigned int,  arg
+ sizeof(foo) can overflow as sizeof(foo) - 1
[root@localhost test]# ./test
3
arg over flow.

my fault is *len is check with:
        if (*len < sizeof(get)) {
                duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
                return -EINVAL;
        }

so, *len must >= sizeof(get), then:

        if (*len != sizeof(struct ipt_get_entries) + get.size) {
                duprintf("get_entries: %u != %zu\n",
                         *len, sizeof(get) + get.size);
                return -EINVAL;
        }
if sizeof(struct ipt_get_entries) + get.size oveflow, it must <
sizeof(struct ipt_get_entries),  It not make any problem, just return.
get.size overflow can't make any problem,  thx Feng and Jan for helping me.


On Tue, Mar 23, 2010 at 12:49 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Tue, Mar 23, 2010 at 11:48 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
>> 1、 suppose *len = 35,  sizeof(struct ipt_get_entries) = 36
>> 2、 set get.size = 0xffffffff from user space
>> 3、 sizeof(struct ipt_get_entries) + get.size = 36  + 0xffffffff = 35;
>> 4、 if (*len != sizeof(struct ipt_get_entries) + get.size) was bypassed.
>>
>> you can test with c code:
>>
>> #include <stdio.h>
>>
>> int main(void)
>> {
>>        unsigned int arg = 0xffffffff;
>>
>>        printf("%u\n", arg + 36);
>>        if (35 != arg + 36) {
>>                printf("not over flow.\n");
>>                return -1;
>>        }
>>        printf("arg over flow.\n");
>>
>>        return 0;
>> }
>>
>
> You didn't get his point... The key point is that sizeof() result type
> is size_t, slightly modify you code, try the result.
>> int main(void)
>> {
>>        unsigned int arg = 0xffffffff;
>>        unsigned int foo;
>>        printf("%lu\n", arg + sizeof(foo));
>>        if (sizeof(foo) - 1 != arg + sizeof(foo)) {
>>                printf("not over flow.\n");
>>                return -1;
>>        }
>>        printf("arg over flow.\n");
>>
>>        return 0;
>> }
>
>> On Tue, Mar 23, 2010 at 11:04 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>>
>>> On Tuesday 2010-03-23 03:37, wzt wzt wrote:
>>>>> And, for the addition overflow, can it be caught by
>>>>>
>>>>> "if (*len != sizeof(struct ipt_get_entries) + get.size)"  ???
>>>>
>>>>sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
>>>>get.size is control by user space with copy_from_user().
>>>
>>> The != should catch it.
>>>
>>> For 64-bit environments:
>>> * + invoked with size_t, unsigned int
>>>  => right side promoted to size_t, result type is size_t
>>> * != invoked with int and size_t
>>>  => left-side promoted to ssize_t (probably; but something as large as size_t)
>>> * get.size is 32-bit bounded, as is *len,
>>>  so no overflow to worry about at all unless you make
>>>  sizeof(X) hilariously big close to 2^64 which is rather unlikely.
>>>
>>> For 32-bit environments:
>>> * Let *len be a number of choice (e.g. 36)
>>> * Find a sizeof(X)+get.size that equals 36 mod 2^32.
>>> * Since sizeof(X) is const, get.size must be 0 mod 2^32.
>>> * So get.size must be a multiple of 2^32 to fool the system.
>>> * Since get.size itself is only a 32-bit quantity, you cannot
>>>  represent any value larger than 4294967295.
>>>
>>>
>>> What Was What Was Wanted.
>>>
>>
>
