Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0CWDsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:48:10 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:65197 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0CWDsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NMZn0Y34QK+cECdCP+WF8KgUnyLeMvWTbLmQb7/M3PWLhHEmOXAt3Wu+PP4n2Iao8Q
         4VGMkJd4SWy6UKjDZOPiGEVCdiX2Y+muWFqf2P+TlXm3/M3ZFJfLWif6udCgFM83cujh
         OTDlZZXH5sqd1iI2kste+qbLnsMvXSAWB9DKY=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.1003230346010.12017@obet.zrqbmnf.qr>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
	 <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
	 <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
	 <alpine.LSU.2.01.1003230346010.12017@obet.zrqbmnf.qr>
Date: Tue, 23 Mar 2010 11:48:06 +0800
Message-ID: <628d1651003222048k1eaf6929r81fd06e401190e0@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
From: wzt wzt <wzt.wzt@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Patrick McHardy <kaber@trash.net>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1、 suppose *len = 35,  sizeof(struct ipt_get_entries) = 36
2、 set get.size = 0xffffffff from user space
3、 sizeof(struct ipt_get_entries) + get.size = 36  + 0xffffffff = 35;
4、 if (*len != sizeof(struct ipt_get_entries) + get.size) was bypassed.

you can test with c code:

#include <stdio.h>

int main(void)
{
        unsigned int arg = 0xffffffff;

        printf("%u\n", arg + 36);
        if (35 != arg + 36) {
                printf("not over flow.\n");
                return -1;
        }
        printf("arg over flow.\n");

        return 0;
}

On Tue, Mar 23, 2010 at 11:04 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2010-03-23 03:37, wzt wzt wrote:
>>> And, for the addition overflow, can it be caught by
>>>
>>> "if (*len != sizeof(struct ipt_get_entries) + get.size)"  ???
>>
>>sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
>>get.size is control by user space with copy_from_user().
>
> The != should catch it.
>
> For 64-bit environments:
> * + invoked with size_t, unsigned int
>  => right side promoted to size_t, result type is size_t
> * != invoked with int and size_t
>  => left-side promoted to ssize_t (probably; but something as large as size_t)
> * get.size is 32-bit bounded, as is *len,
>  so no overflow to worry about at all unless you make
>  sizeof(X) hilariously big close to 2^64 which is rather unlikely.
>
> For 32-bit environments:
> * Let *len be a number of choice (e.g. 36)
> * Find a sizeof(X)+get.size that equals 36 mod 2^32.
> * Since sizeof(X) is const, get.size must be 0 mod 2^32.
> * So get.size must be a multiple of 2^32 to fool the system.
> * Since get.size itself is only a 32-bit quantity, you cannot
>  represent any value larger than 4294967295.
>
>
> What Was What Was Wanted.
>
